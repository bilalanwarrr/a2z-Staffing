import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const.dart';

class CustomButtonView extends StatelessWidget {
  const CustomButtonView({Key? key, required this.title, this.bColor, required this.onTap}) : super(key: key);

  final String title;
  final Color? bColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 16),
      minWidth: MediaQuery.of(context).size.width,
      child: Text('${title}',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: whiteColor))),
      color: bColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35.r)),
      onPressed: onTap,
    );
  }
}
