import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todo_app/pages/auth/login.dart';
import 'package:todo_app/utils/constants.dart';

// to onboard user if is not logged in
class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: getHeight(context) * 0.5,
            width: getWidth(context),
            child: Padding(
              padding: const EdgeInsets.all(100.0),
              child: Image.asset('assets/images/1.jpg'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60.0),
                  child: Column(
                    children: [
                      Text(
                        'Welcome to your productivity hub!\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Bold', color: secondary, fontSize: 30),
                      ),
                      Text(
                        "Simplify your tasks, maximize your productivity!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Regular',
                            color: secondary,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Get Started",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'SemiBold', color: secondary, fontSize: 12),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.bounceInOut,
                              type: PageTransitionType.rightToLeft,
                              child: const Login()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.08), width: 1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: tertiary,
                              borderRadius: BorderRadius.circular(100)),
                          child: const Padding(
                            padding: EdgeInsets.all(28.0),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
