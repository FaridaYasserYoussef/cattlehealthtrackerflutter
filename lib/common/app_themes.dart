import 'package:cattlehealthtracker/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemes{
 static final  lightTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.backgroundColorLight,
  appBarTheme: AppBarTheme(backgroundColor: AppColors.light_green),
  brightness: Brightness.light,
  textTheme: TextTheme(
    titleLarge: TextStyle(color: AppColors.greenColor, fontSize: 30.sp, fontWeight: FontWeight.bold)
  )

 );

  static final  darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColorDark,
      appBarTheme: AppBarTheme(backgroundColor: AppColors.greenColor),

  brightness: Brightness.dark,
  textTheme: TextTheme(

    titleLarge: TextStyle(color: Colors.white, fontSize: 30.sp, fontWeight: FontWeight.bold)
  )

 );
}