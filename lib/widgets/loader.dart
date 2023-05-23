import 'package:flutter/material.dart';

//this basic loader is used wherever a loading animation is needed
class Loader extends StatelessWidget {
  final Color? color;
  const Loader({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      width: 15,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color!),
      ),
    );
  }
}
