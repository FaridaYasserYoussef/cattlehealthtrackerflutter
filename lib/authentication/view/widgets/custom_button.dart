import 'package:cattlehealthtracker/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
   void Function()? onTap;
   String text;
   Color? bgColor;
   CustomButton({this.onTap, required this.text, this.bgColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8.w),
      child: ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style!.copyWith(backgroundColor: bgColor != null? WidgetStatePropertyAll(bgColor): null,   padding: WidgetStatePropertyAll(EdgeInsets.only(top: 2.h))),
        onPressed:onTap, 
      child: Text(text, style: Theme.of(context).textTheme.bodyLarge)
      ),
    );
  }
}

