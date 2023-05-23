import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todo_app/pages/onboard.dart';
import 'package:todo_app/widgets/toast.dart';

import '../pages/home.dart';

class AuthProvider extends ChangeNotifier {
  bool loader = false;
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  //this checks if user is logged in
  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null ? true : false;
  }

  //this gets the user info from firebase
  User? getUserInfo() {
    return FirebaseAuth.instance.currentUser;
  }

  //this function provides basic login with google functionality

  Future googleLogin(context) async {
    loader = true;
    notifyListeners();

    try {
      final googleUser = await googleSignIn.signIn();
      showToast('Please wait while we are fetching info...');

      if (googleUser == null) return;

      _user = googleUser;
      print('user...');
      print(_user);

      // fetches auth credentials and if not already present, creates new
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("Printing Access Token.........");
      print(googleAuth.idToken);
      print("Printed");
      print("Printing Access Token.........");
      print(googleAuth.accessToken);
      print("Printed");

      // sign in user with the credentials
      await FirebaseAuth.instance.signInWithCredential(credential);
      loader = false;
      notifyListeners();

      // after sign in, move to home screen

      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              type: PageTransitionType.rightToLeft,
              child: const Home()),
          (route) => false);

      showToast('Successfully logged in');
      return true;
    } catch (e) {
      print(e.toString());
      loader = false;
      notifyListeners();
      showToast('Could not Sign In\nPlease try again');
      return false;
    }
  }

  Future googlelogout(context) async {
    loader = true;
    notifyListeners();

    try {
      await googleSignIn.disconnect();
    } catch (e) {
      print(e);
      loader = false;
      notifyListeners();
      showToast('Error signing out');
    }

    FirebaseAuth.instance.signOut();

    showToast('Successfully signed out');

    loader = false;
    notifyListeners();

    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
            type: PageTransitionType.rightToLeft,
            child: const Onboard()),
        (route) => false);
  }
}
