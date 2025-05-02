import 'package:cattlehealthtracker/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemes{
 static final  lightTheme = ThemeData(
  secondaryHeaderColor: Colors.black,
  scaffoldBackgroundColor: AppColors.backgroundColorLight,
  appBarTheme: AppBarTheme(backgroundColor: AppColors.backgroundColorLight),
  elevatedButtonTheme:  ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.greenColor,
    disabledBackgroundColor: Colors.grey,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(9.r)
    )
  )
),
  brightness: Brightness.light,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColors.text_light, fontSize: 18.sp, fontFamily: "Tajawal", fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(color: AppColors.text_light, fontSize: 15.sp, fontFamily: "Tajawal", fontWeight: FontWeight.bold),

    titleLarge: TextStyle(color: AppColors.text_light, fontSize: 30.sp, fontFamily: "Tajawal", fontWeight: FontWeight.bold)
  )

 );

  static final  darkTheme = ThemeData(
    secondaryHeaderColor: Colors.black,
    scaffoldBackgroundColor: AppColors.backgroundColorDark,
      appBarTheme: AppBarTheme(backgroundColor: AppColors.backgroundColorDark),
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.greenColor,
    disabledBackgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.r)

      )


  )
),
  brightness: Brightness.dark,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColors.text_dark, fontSize: 18.sp, fontFamily: "Tajawal", fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(color: AppColors.text_dark, fontSize: 15.sp, fontFamily: "Tajawal", fontWeight: FontWeight.bold),

    titleLarge: TextStyle(color: AppColors.text_dark, fontSize: 30.sp, fontFamily: "Tajawal", fontWeight: FontWeight.bold)
  )

 );
}