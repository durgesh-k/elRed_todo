import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:todo_app/pages/home.dart';
import 'package:todo_app/pages/onboard.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(create: (context) => TaskProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: (context, child) {
          return ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, child!),
              maxWidth: getWidth(context),
              minWidth: 300,
              defaultScale: true,
              mediaQueryData:
                  MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
              breakpoints: [
                const ResponsiveBreakpoint.resize(300, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
              background: Container(color: const Color(0xFFF5F5F5)));
        },
        home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) =>
                (authProvider.isUserLoggedIn()
                    ? const Home()
                    : const Onboard())),
      ),
    );
  }
}
