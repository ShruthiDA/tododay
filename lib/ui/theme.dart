import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_progress_tracker/services/theme_services.dart';

class Themes {
  static final light = ThemeData(
      //appBarTheme: AppBarTheme(color: Colors.amberAccent),
      backgroundColor: Color.fromRGBO(255, 215, 64, 1),
      primaryColor: Colors.amberAccent,
      brightness: Brightness.light);

  static final dark = ThemeData(
      //appBarTheme: AppBarTheme(color: Colors.amberAccent),
      backgroundColor: Colors.greenAccent,
      primaryColor: Colors.greenAccent,
      brightness: Brightness.dark);
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode
              ? ColorConstants.headingColorLight
              : ColorConstants.headingColor));
}

TextStyle get taskTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode
              ? ColorConstants.headingColorLight
              : ColorConstants.headingColor));
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode
              ? ColorConstants.headingColorLight
              : ColorConstants.headingColor));
}

TextStyle get toolbarTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode
              ? ColorConstants.headingColorLight
              : ColorConstants.headingColor));
}

TextStyle get subHeadingNormalStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Get.isDarkMode
              ? ColorConstants.headingColorLight
              : ColorConstants.headingColor));
}

TextStyle get normalTextStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Get.isDarkMode
              ? ColorConstants.textColorLight
              : ColorConstants.textColor));
}

TextStyle get normalTextStyle12 {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Get.isDarkMode
              ? ColorConstants.textColorLight
              : ColorConstants.textColor));
}

TextStyle get normalTextStyle14 {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Get.isDarkMode
              ? ColorConstants.textColorLight
              : ColorConstants.textColor));
}

TextStyle get normalTextStyle16 {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Get.isDarkMode
              ? ColorConstants.textColorWhite
              : ColorConstants.textColor));
}

TextStyle get boldTextStyle16 {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode
              ? ColorConstants.textColorLight
              : ColorConstants.textColor));
}

TextStyle get boldTextStyle12 {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode
              ? ColorConstants.textColorLight
              : ColorConstants.textColor));
}

TextStyle get boldTextStyle14 {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode
              ? ColorConstants.textColorLight
              : ColorConstants.textColor));
}

TextStyle get normalTextStyle18 {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: Get.isDarkMode
              ? ColorConstants.textColorWhite
              : ColorConstants.textColor));
}

TextStyle get boldTextStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode
              ? ColorConstants.textColorLight
              : ColorConstants.textColor));
}

TextStyle get boldHeadingTextStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode
              ? ColorConstants.headingColorLight
              : ColorConstants.headingColor));
}

TextStyle get inputLabelTextStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : ColorConstants.textColor));
}

TextStyle get inputHintTextStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Get.isDarkMode ? Colors.grey : Colors.grey));
}

TextStyle get quotesTextStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}

TextStyle get quotesAuthorStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 12,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.normal,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}
