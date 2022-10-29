import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color white = Color(0xFFFFFFFF);
Color black = Colors.black;
Color backgroundColor = Color(0xFFFAFAFA);
Color sermonTextAsh = Color(0xFF656F77);
Color miniTextWhite = Color.fromRGBO(240, 240, 240, 1);
Color babyBlue = Color.fromRGBO(0, 169, 203, 1);
Color lightBabyBlue = Color(0xFFb2e4ee);
Color deepBlue = Color.fromRGBO(58, 66, 118, 1);
Color darkBlue = Color.fromRGBO(27, 29, 40, 1);
Color highBabyBlue = Color.fromRGBO(0, 170, 204, 1);
Color sermonTextBlack = Color.fromRGBO(25, 29, 33, 1);
Color inactiveBabyBlue = Color.fromRGBO(0, 169, 203, 0.4);
Color redPayment = Color.fromRGBO(235, 87, 87, 1);
Color greenPayment = Color(0xFF00764C);
Color darkGray = Color.fromRGBO(130, 130, 130, 1);
Color partnerHintText = Color.fromRGBO(128, 128, 128, 1);

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      ).apply(
          bodyColor: isDarkTheme ? white : sermonTextBlack,
          displayColor: isDarkTheme ? white : black),
      primaryColor: isDarkTheme ? darkBlue : babyBlue,

      //DEEP BLUE TEXT
      primaryColorDark: isDarkTheme ? white : deepBlue,

      //DEEPBLUE - BABYBLUE CONVERSION
      primaryColorLight: isDarkTheme ? deepBlue : babyBlue,
      backgroundColor: isDarkTheme ? Colors.black : Color(0xFFFAFAFA),
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      iconTheme: IconThemeData(
        color: isDarkTheme ? white : black,
      ),
      //hint color changed for
      hintColor:
          isDarkTheme ? white.withOpacity(0.85) : Colors.black.withOpacity(0.75),
      //HIGHLIGHT COLOR REPRESENTS A SIMPLE BLACK - WHITE EXCHANGE
      highlightColor: isDarkTheme ? black : white,

      //HOVER COLOR CHANGED FOR CONTAINER THEME
      hoverColor: isDarkTheme ? darkBlue : white,

      //FOCUSCOLOR IS INVERTED HOVER
      focusColor: isDarkTheme ? white : darkBlue,

      disabledColor: isDarkTheme ? black : Colors.grey,

      //Button Gradient Values
      cardColor: isDarkTheme
          ? darkBlue.withOpacity(0.95)
          : Color.fromRGBO(0, 169, 203, 1), //first
      canvasColor: isDarkTheme
          ? darkBlue.withBlue(75)
          : Color.fromRGBO(0, 143, 172, 1), //second
      // Color.fromRGBO(0, 169, 203, 1),
      // Color.fromRGBO(0, 143, 172, 1),

      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: isDarkTheme ? darkBlue : white),
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
    );
  }
}
