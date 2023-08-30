import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull/aviews/AdminHelpView.dart';
import 'package:pull/aviews/AdminPrivacyView.dart';
import 'package:pull/const.dart';
import 'package:pull/SignInView.dart';

class AdminSettingsView extends StatelessWidget {
  const AdminSettingsView({Key? key}) : super(key: key);

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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminHelpView()));
              },
              child: tabs('Help'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminPrivacyView()));
              },
              child: tabs('Privacy Policy'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInView()));
              },
              child: tabs('Sign Out'),
            )
          ],
        ),
      ),
    );
  }

  Widget tabs(txt) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: colorFive.withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${txt}',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: whiteColor)),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 25.sp,
            color: colorOne,
          )
        ],
      ),
    );
  }
}
