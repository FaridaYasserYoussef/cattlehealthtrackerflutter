import 'package:cattlehealthtracker/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
   CustomTextFormField({super.key, required this.controller, required this.type, required this.hintText});
  TextEditingController controller;
  String type; 
  String hintText;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isVisible = false;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 25.h, left: 8.h, right: 8.h),
      child: TextFormField(
        obscureText: widget.type == "password"? isVisible? false: true: false,
        controller: widget.controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r)
          ),
          contentPadding: EdgeInsets.all(5.h),
          hintStyle: TextStyle(fontSize: 18.sp, color: AppColors.greenColor, fontWeight: FontWeight.bold),
          hintText: widget.hintText,
          suffixIconColor: widget.type == "password"? AppColors.light_green: null,
          suffixIcon: widget.type == "password"? IconButton(onPressed: (){
            setState(() {
              isVisible = !isVisible;
            });
          }, icon: Icon(isVisible == true? Icons.visibility_off: Icons.visibility)): null
        ),
      ),
    );
  }
}