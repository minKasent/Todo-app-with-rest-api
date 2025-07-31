import 'package:flutter/material.dart';
import 'package:todo_app_with_rest_api/constants/app_colors_path.dart';

class AppTextStyle {

  static final text24SemiBold = TextStyle(
    fontFamily: 'Jost',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColorsPath.white,
  );
  static final text13Semibold = TextStyle(
    fontFamily: 'Jost',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColorsPath.purple,
  );
  static final text10Regular = TextStyle(
    fontFamily: "Jost",
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColorsPath.dark,
  );
}