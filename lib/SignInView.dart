import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull/aviews/AdminMainView.dart';
import 'package:pull/const.dart';

import 'providers/staff_provider.dart';
import 'widgets/CustomButtonView.dart';
import 'widgets/CustomTxtFieldView.dart';
import 'views/MainView.dart';

class SignInView extends StatefulWidget {
  SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool remember = false;
  final emailTxt = TextEditingController();

  final passwordTxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var staff = Provider.of<StaffProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 80.h,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'The easy way to recruit the right people!',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: colorTwo)),
                      ),

                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                      color: colorThree,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                  color: whiteColor)),
                        ),
                      ),
                      Text(
                        'Welcome Back!',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: whiteColor)),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      CustomTxtFieldView(hint: 'Username', txt: emailTxt),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomSecureTxtFieldView(
                          hint: 'Password', txt: passwordTxt),
                      SizedBox(
                        height: 30.h,
                      ),
                      CustomButtonView(
                        title: staff.isLoading == false ? 'Login' : 'Loading...',
                        bColor: colorOne,
                        onTap: () async {
                          var staff = Provider.of<StaffProvider>(context, listen: false);

                          staff.setLoading(true);

                          var msg = await staff.signInWorker(emailTxt.text, passwordTxt.text);

                          if(msg != null){
                            staff.setLoading(false);
                            if(msg.get('role') == 'admin'){

                              print("Admin hereee");

                              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminMainView()));
                            }else{
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => MainView()));
                            }
                          }else{
                            staff.setLoading(false);
                            showToast('Username or password is incorrect !');
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Privacy Policy', style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.sp, color: whiteColor)),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
