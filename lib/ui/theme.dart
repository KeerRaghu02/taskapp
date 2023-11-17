import 'package:flutter/material.dart';
import 'package:get/get.dart';
const Color bluishclr=Color(0xFF4e5ae8);
const Color yellowclr=Color(0xFFFFB746);
const Color pinkclr=Color(0xFFff4667);
const Color primaryclr=bluishclr;
const Color white=Colors.white;
const Color darkgreyclr=Color(0xFF121212);
class Themes{
  static final light=  ThemeData(
    backgroundColor: Colors.white,
    primaryColor: primaryclr,
    brightness: Brightness.light
  );
  static final dark=  ThemeData(
    backgroundColor: darkgreyclr,
    primaryColor: darkgreyclr,
    brightness: Brightness.dark
  );
}

TextStyle get subHeadingStyle{
  return TextStyle(
          fontSize:18,
          fontWeight: FontWeight.bold,
          color:Get.isDarkMode?Colors.grey[400]:Colors.grey
  );
}
TextStyle get titleStyle{
  return TextStyle(
      fontSize:16,
      fontWeight: FontWeight.w400,
      color:Get.isDarkMode?Colors.white:Colors.black
  );
}
TextStyle get subtitleStyle{
  return TextStyle(
      fontSize:14,
      fontWeight: FontWeight.w400,
      color:Get.isDarkMode?Colors.grey[100]:Colors.grey[600]
  );
}


TextStyle get headingStyle{
  return TextStyle(
    fontSize:26,
    fontWeight: FontWeight.bold,
    color:Get.isDarkMode?Colors.white:Colors.black
  );
}