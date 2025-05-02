import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpTextField extends StatefulWidget {
  void Function(String)? onChanged;
  TextEditingController? controller;
  String placeholder;
   OtpTextField({this.onChanged, this.controller, required this.placeholder, super.key});

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Padding(
      padding:  EdgeInsets.symmetric(horizontal: 2.w),
      child: TextField(
              
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey),
                hintText: widget.placeholder,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.r))
                )
              ),
              controller: widget.controller,
               textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: widget.onChanged,
              inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly
              ],
            ),
    ));
  }
}