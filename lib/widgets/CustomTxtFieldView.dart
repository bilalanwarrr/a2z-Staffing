import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const.dart';

class CustomTxtFieldView extends StatelessWidget {
  const CustomTxtFieldView({Key? key, required this.hint, required this.txt, this.bcolor = blackColor, this.bbcolor = colorFive, this.maxLines = 1, this.enabled = true}) : super(key: key);

  final String hint;
  final TextEditingController txt;
  final Color bcolor, bbcolor;
  final int maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: txt,
      maxLines: maxLines,
      enabled: enabled,
      style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp,color: whiteColor)),
      decoration: InputDecoration(
          filled: true,
          fillColor: bcolor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: bbcolor)
          ),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: bbcolor)
        ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: bbcolor)
          ),
          suffixIcon: hint == 'Skills' || hint == 'Role' ? Icon(Icons.keyboard_arrow_down, color: whiteColor,) : hint == 'Date' ? Image.asset('assets/icons/calender.png', height: 22.h,width: 22.w,) : Container(height: 0, width: 0,),
        enabled: hint == 'Role' || hint == 'Skills' || hint == 'Date' ? false : true,
        hintText: '${hint}',
          hintStyle: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp,color: whiteColor)),
        labelText: '${hint}',
        labelStyle: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp,color: whiteColor)),
      ),
    );
  }
}

class CustomSecureTxtFieldView extends StatefulWidget {
  const CustomSecureTxtFieldView({Key? key, required this.hint, required this.txt, this.bcolor = Colors.transparent}) : super(key: key);

  final String hint;
  final TextEditingController txt;
  final Color bcolor;

  @override
  State<CustomSecureTxtFieldView> createState() => _CustomSecureTxtFieldViewState();
}

class _CustomSecureTxtFieldViewState extends State<CustomSecureTxtFieldView> {
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.txt,
      style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp,color: whiteColor)),
      obscureText: hide,
      decoration: InputDecoration(
          filled: true,
          fillColor: blackColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colorFive)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colorFive)
          ),
          hintText: '${widget.hint}',
          hintStyle: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp,color: whiteColor)),
          labelText: '${widget.hint}',
          labelStyle: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp,color: whiteColor)),
          suffixIcon:  GestureDetector(onTap: (){
            setState(() {
              hide = !hide;
            });
          }, child: Icon(hide == true ? Icons.visibility_off : Icons.visibility, color: whiteColor, size: 20.sp,))
      ),
    );
  }
}

