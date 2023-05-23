import 'package:flutter/material.dart';

// functions to return current size(height/weight) of the screen
double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// Color variables
Color primary = const Color(0xFF2ebaef);
Color secondary = const Color(0xFF131517);
Color tertiary = const Color(0xFF46539e);

//These are the editing controllers
TextEditingController? titleController = TextEditingController();
TextEditingController? descriptionController = TextEditingController();
TextEditingController? placeController = TextEditingController();
TextEditingController? timeController = TextEditingController();
