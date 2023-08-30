import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const.dart';

class HelpFeedBackView extends StatelessWidget {
  const HelpFeedBackView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/icons/back.png')),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Text(
                  'Help',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color:
                          whiteColor)),
                ),
              ],
            ),
            SizedBox(height: 25.h,),
            Text(
              '${txt}\n\n${txt}\n\n${txt}',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color:
                      whiteColor)),
            ),
          ],
        ),
      ),
    );
  }
}

const String txt = 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English.';