import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllColors {
  static const darkGray = Color(0xFF333333);
  static const lightGray = Color(0xFFEEEEEE);
  static const lightGray2 = Color(0xFF787878);
  static const white = Color(0xFFFFFFFF);
  static const purple = Color(0xFF7F48FB);
  static const modalSheetLine = Color(0XFFEBEBEB);
  static const lightPurple = Color(0xFFB291FD);
  static const profileImageBackground = Color(0xFFF2F2F2);
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
    color: AllColors.white,
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
    color: AllColors.white,
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
    color: AllColors.white,
  );
  static const font36w900white = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w900,
    color: AllColors.white,
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
        color: AllColors.lightGray,
      ),
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: AllColors.lightGray,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: AllColors.lightGray,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: AllColors.lightGray,
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
