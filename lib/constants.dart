import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllColors {
  static const darkGray = Color(0xFF333333);
  static const lightGray = Color(0xFFEEEEEE);
}

enum MessageContentType { text, file, media }

class AllStyles {
  static const font15w400black = TextStyle(
    fontSize: 15.0,
    color: Colors.black,
    fontWeight: FontWeight.w400,
  );

  static const font14w400white = TextStyle(
    fontSize: 14.0,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  static const font15w400lightGrayAnother = TextStyle(
    fontSize: 15.0,
    color: Color(0xFFBFC1C3),
    fontWeight: FontWeight.w400,
  );

  static const font15w500lightGray = TextStyle(
    fontSize: 15.0,
    color: Color(0xFFB5B5B5),
    fontWeight: FontWeight.w500,
  );

  static const font15w500darkGray = TextStyle(
    fontSize: 15.0,
    color: AllColors.darkGray,
    fontWeight: FontWeight.w500,
  );

  static const font15w500white = TextStyle(
    fontSize: 15.0,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static const font20w500darkGray = TextStyle(
    fontSize: 20.0,
    color: AllColors.darkGray,
    fontWeight: FontWeight.w500,
  );

  static const font15w500purple = TextStyle(
    fontSize: 15.0,
    color: Color(0xFF7F48FB),
    fontWeight: FontWeight.w500,
  );

  static const font28w900white = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );
  static const font36w900white = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );

  static final signInInputDecoration = InputDecoration(
    hintStyle: TextStyle(color: Colors.black26),
    filled: true,
    fillColor: Colors.white70,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black26),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black26),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black26),
      borderRadius: BorderRadius.circular(8),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black26),
      borderRadius: BorderRadius.circular(8),
    ),
    contentPadding: EdgeInsets.all(8.0),
  );

  static const myProfileInputDecoration = InputDecoration(
    helperText: ' ',
    hintStyle: AllStyles.font15w500lightGray,
    border: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: Color(0xFFEEEEEE),
      ),
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: Color(0xFFEEEEEE),
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: Color(0xFFEEEEEE),
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Color(0xFFEEEEEE),
      ),
    ),
  );

  static final messageBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(100)),
    borderSide: BorderSide(
      color: Color(0xFFB5B5B5).withOpacity(0.4),
      width: 1.0,
    ),
  );
}
