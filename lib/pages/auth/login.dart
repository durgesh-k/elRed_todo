import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/widgets/loader.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.red, width: 1)))),
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: getHeight(context) * 0.5,
            width: getWidth(context),
            child: Padding(
              padding: const EdgeInsets.all(100.0),
              child: Image.asset('assets/images/2.jpg'),
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
                        'Sign In\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Bold', color: secondary, fontSize: 30),
                      ),
                      Text(
                        "Access and organize your tasks effortlessly with our Todo App!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Regular',
                            color: secondary,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => authProvider.googleLogin(context),
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
                            child: Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/google.svg',
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: authProvider.loader
                                          ? const Loader(
                                              color: Colors.white,
                                            )
                                          : const Text(
                                              'Continue with Google',
                                              style: TextStyle(
                                                  fontFamily: 'SemiBold',
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                    )
                                  ],
                                )),
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
