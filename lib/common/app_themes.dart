import 'package:cattlehealthtracker/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemes{
 static final  lightTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.backgroundColorLight,
  appBarTheme: AppBarTheme(backgroundColor: AppColors.light_green),
  elevatedButtonTheme:  ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.light_green,
    disabledBackgroundColor: Colors.grey,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(9.r)
    )
  )
),
  brightness: Brightness.light,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColors.greenColor, fontSize: 18.sp, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: AppColors.greenColor, fontSize: 30.sp, fontWeight: FontWeight.bold)
  )

 );

  static final  darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColorDark,
      appBarTheme: AppBarTheme(backgroundColor: AppColors.greenColor),
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
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: Colors.white, fontSize: 30.sp, fontWeight: FontWeight.bold)
  )

 );
}