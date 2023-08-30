import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull/aviews/AdminSettingsView.dart';
import 'package:pull/const.dart';
import 'package:pull/models/workshift_model.dart';
import 'package:pull/providers/staff_provider.dart';
import 'package:pull/SignInView.dart';
import 'package:pull/views/DetailHourLogView.dart';
import 'package:pull/views/HelpFeedbackView.dart';
import 'package:pull/views/ProfileView.dart';
import 'package:pull/views/ScheduleListView.dart';

import 'NotificationsView.dart';
//
//Main View When User Sign In successfully
//
class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool notify = false;
  WorkShiftModel? workShift; //    //non rejected workshift
  GlobalKey<ScaffoldState> scafKey = GlobalKey();
  String date = '${DateTime.now().day.toString().length == 1 ? '0${DateTime.now().day}' : DateTime.now().day}/${DateTime.now().month.toString().length == 1 ? '0${DateTime.now().month}' : DateTime.now().month}/${DateTime.now().year}';

  @override
  void initState() {
    super.initState();

    //call method to fetch data from database
    init();
  }

  init() async {
    var staff = Provider.of<StaffProvider>(context, listen: false);
    await staff.fetchWorkShift();
    await staff.fetchNotifications();

    //notifications
    staff.workerShiftList
        .where((w) => w.accepted == staff.worker!.uid)
        .forEach((ws) {
      var d1 = DateTime(
          int.parse(ws.date.split('/').last),
          int.parse(ws.date.split('/')[1]),
          int.parse(ws.date.split('/').first));

      if (DateTime.now().difference(d1).inDays == 1) {
        if (staff.notificationsList.where((n) => n.shiftId != ws.uid).isNotEmpty) {
          var id = getRandomString(28);
          staff.postNotifications({
            'uid': id,
            'userId': staff.worker!.uid,
            'title': 'Shift Reminder',
            'shiftId': ws.uid,
            'message':
                'You have an upcoming shift at Oxforf Hotel Street Lordan in 1 Day 3 Hour.',
            'timestamp': DateTime.now().microsecondsSinceEpoch,
            'status': false
          });
        }
      }
    });
    //end

    //checking non rejected workshift by current loggedin
    if (staff.workerShiftList.length > 0) {
      staff.workerShiftList.forEach((w) {

        if (w.accepted == '' && w.rejected.contains(staff.worker!.uid) == false && w.skills
            .split(',')
            .where((s) =>
        staff.worker!.skills
            .split(',')
            .where((ss) => ss
            .replaceAll(' ', '')
            .contains(s.replaceAll(' ', '')))
            .length >
            0)
            .length > 0) {

          setState(() {
            workShift = w;
          });
        }
      });
    }

    //non rejected workshift by current loggedin user present so show him/ her popup
    if (workShift != null) {
      shiftHour();
    }
  }

  @override
  Widget build(BuildContext context) {
    var staff = Provider.of<StaffProvider>(context);
    return Scaffold(
      key: scafKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              scafKey.currentState!.openDrawer();
            },
            child: Image.asset('assets/icons/drawer.png')),
        actions: [
          GestureDetector(
              onTap: () {
                init();
              },
              child: Icon(
                Icons.refresh,
                color: whiteColor,
                size: 35.sp,
              )),
          SizedBox(
            width: 15.w,
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileView()));
              },
              child: Image.asset(
                'assets/icons/user.png',
                color: whiteColor,
                height: 20.h,
                width: 20.w,
              )),
          SizedBox(
            width: 15.w,
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsView()));
              },
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/icons/notification.png',
                      height: 26.h,
                      width: 24.w,
                    ),
                  ),
                  staff.notificationsList
                      .where((n) => n.userId == staff.worker!.uid && n.status == false)
                      .length > 0 ?
                  Positioned(
                      top: 20.h,
                      left: 0.w,
                      child: CircleAvatar(
                        radius: 5.r,
                        backgroundColor: Colors.red,
                      )
                  ) : Container()
                ],
              )),
          SizedBox(
            width: 20.w,
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: colorThree,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 80.h, left: 30.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundImage: NetworkImage('${staff.worker!.profilePicture}'),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${staff.worker!.workerName}',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: whiteColor)),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            '${staff.workerShiftList.where((ws) => ws.accepted == staff.worker!.uid).length} Work Shifts done',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                    color: colorFive)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 15.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 35.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Notifications',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                    color: whiteColor)),
                          ),
                          SizedBox(
                            height: 28.h,
                            width: 50.w,
                            child: FlutterSwitch(
                              value: notify,
                              activeToggleColor: whiteColor,
                              activeColor: colorOne,
                              inactiveToggleColor: colorOne,
                              inactiveColor: whiteColor,
                              onToggle: (val) {
                                setState(() {
                                  notify = val;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Divider(
                        color: colorFive.withOpacity(0.5),
                      ),
                      SizedBox(
                        height: 28.h,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileView()));
                        },
                        child: Row(
                          children: [
                            Image.asset('assets/icons/user.png',
                                height: 20.h, width: 20.w),
                            SizedBox(
                              width: 20.w,
                            ),
                            Text(
                              'Profile',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: whiteColor)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScheduleListView()));
                        },
                        child: Row(
                          children: [
                            Image.asset('assets/icons/schedule.png',
                                height: 20.h, width: 20.w),
                            SizedBox(
                              width: 20.w,
                            ),
                            Text(
                              'Schedule List',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: whiteColor)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => HelpFeedBackView()));
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Image.asset('assets/icons/help.png',
                      //           height: 20.h, width: 20.w),
                      //       SizedBox(
                      //         width: 20.w,
                      //       ),
                      //       Text(
                      //         'Help',
                      //         style: GoogleFonts.poppins(
                      //             textStyle: TextStyle(
                      //                 fontSize: 16.sp,
                      //                 fontWeight: FontWeight.w600,
                      //                 color: whiteColor)),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 25.h,
                      // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminSettingsView()));
                        },
                        child: Row(
                          children: [
                            Image.asset('assets/icons/setting.png',
                                height: 20.h, width: 20.w),
                            SizedBox(
                              width: 20.w,
                            ),
                            Text(
                              'Settings',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: whiteColor)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => SignInView()));
            //   },
            //   child: Padding(
            //     padding: EdgeInsets.only(left: 20.w, bottom: 25.h),
            //     child: Row(
            //       children: [
            //         Image.asset('assets/icons/logout.png',
            //             height: 20.h, width: 20.w),
            //         SizedBox(
            //           width: 20.w,
            //         ),
            //         Text(
            //           'Sign Out',
            //           style: GoogleFonts.poppins(
            //               textStyle: TextStyle(
            //                   fontSize: 16.sp,
            //                   fontWeight: FontWeight.w600,
            //                   color: whiteColor)),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Shift Calender',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24.sp,
                        color: whiteColor)),
              ),
              Container(
                margin: EdgeInsets.only(top: 30.h),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: whiteColor),
                    borderRadius: BorderRadius.circular(12.r)),
                child: CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                      currentDate: DateTime(int.parse(date.split('/').last), int.parse(date.split('/')[1]), int.parse(date.split('/').first)),
                      calendarType: CalendarDatePicker2Type.single,
                      lastMonthIcon: Icon(
                        Icons.arrow_back_ios,
                        color: whiteColor,
                        size: 20.sp,
                      ),
                      nextMonthIcon: Icon(
                        Icons.arrow_forward_ios,
                        color: whiteColor,
                        size: 20.sp,
                      ),
                      disableModePicker: true,
                      controlsTextStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: whiteColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500)),
                      centerAlignModePicker: true,
                      selectedDayHighlightColor: colorOne,
                      weekdayLabelTextStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              color: Color.fromRGBO(235, 235, 245, 0.3))),
                      yearTextStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: whiteColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500)),
                      dayTextStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: whiteColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500))),
                  value: [],
                  onValueChanged: (dates) {
                    setState(() {
                      date = '${dates.first!.day.toString().length == 1 ? '0${dates.first!.day}' : dates.first!.day}/${dates.first!.month.toString().length == 1 ? '0${dates.first!.month}' : dates.first!.month}/${dates.first!.year}';
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h, bottom: 15.h),
                child: Text(
                  '${date}',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: colorTwo)),
                ),
              ),

              //show shifts based on selected date
              Expanded(
                child: ListView.separated(
                    itemCount: staff.workerShiftList
                        .where((w) => w.accepted.contains(staff.worker!.uid))
                        .length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index) {
                      var w = staff.workerShiftList
                          .where((w) => w.accepted.contains(staff.worker!.uid))
                          .toList()[index];

                      var diffH = DateTime(int.parse(w.date.split('/').last), int.parse(w.date.split('/')[1]), int.parse(w.date.split('/').first)).difference(DateTime.now()).inHours;

                      return diffH > 0 ?
                      date == w.date ? Divider(
                        color: colorFive.withOpacity(0.5),
                        thickness: 1.0,
                        indent: 15.w,
                        endIndent: 15.w,
                      ) : Container() : Container();
                    },
                    itemBuilder: (context, index) {
                      var w = staff.workerShiftList
                          .where((w) => w.accepted.contains(staff.worker!.uid))
                          .toList()[index];
                      var d = '';

                      //comparing selected date and today date
                      if(DateTime(int.parse(w.date.split('/').last), int.parse(w.date.split('/')[1]), int.parse(w.date.split('/').first)).difference(DateTime.now()).inHours > 24){
                        d = DateTime(int.parse(w.date.split('/').last), int.parse(w.date.split('/')[1]), int.parse(w.date.split('/').first)).difference(DateTime.now()).inDays.toString() + ' days';
                      }else{
                        d = DateTime(int.parse(w.date.split('/').last), int.parse(w.date.split('/')[1]), int.parse(w.date.split('/').first)).difference(DateTime.now()).inHours.toString() + ' hours';
                      }

                      var diffH = DateTime(int.parse(w.date.split('/').last), int.parse(w.date.split('/')[1]), int.parse(w.date.split('/').first)).difference(DateTime.now()).inHours;

                      return diffH > 0 ?
                      date == w.date ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailHourLogView(workShift: w)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 5.w,
                                  height: 45.h,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: colorTwo,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.r),
                                          bottomLeft: Radius.circular(10.r))),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/location.png',
                                          height: 15.h,
                                          width: 12.w,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          '${w.workPlace}',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: whiteColor)),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${w.skills}',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  253, 235, 245, 0.5))),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      'assets/icons/time.png',
                                      height: 10.h,
                                      width: 10.w,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      '${w.startTime} - ${w.endTime}',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              color: whiteColor)),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      'assets/icons/wait.png',
                                      height: 10.h,
                                      width: 10.w,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      'Due in ${d}',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              color: Color.fromRGBO(
                                                  235, 235, 245, 0.5))),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ) : Container() : Container();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  shiftHour() {
    var staff = Provider.of<StaffProvider>(context, listen: false);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: [
              Container(
                color: colorThree,
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
                child: Column(
                  children: [
                    Text(
                      'Shift Offer',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: whiteColor,
                              decoration: TextDecoration.none)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                      child: Divider(
                        color: colorFive.withOpacity(0.5),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15.h),
                      padding:
                          EdgeInsets.only(left: 10.h, bottom: 30.h, top: 10.h),
                      decoration: BoxDecoration(
                          color: colorFive.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Place:',
                                style: GoogleFonts.sourceSansPro(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromRGBO(235, 235, 245, 0.5),
                                        decoration: TextDecoration.none)),
                              ),
                              SizedBox(
                                width: 25.w,
                              ),
                              Text(
                                '${workShift!.workPlace}',
                                style: GoogleFonts.sourceSansPro(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor,
                                        decoration: TextDecoration.none)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              Text(
                                'Date:',
                                style: GoogleFonts.sourceSansPro(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromRGBO(235, 235, 245, 0.5),
                                        decoration: TextDecoration.none)),
                              ),
                              SizedBox(
                                width: 25.w,
                              ),
                              Text(
                                '${workShift!.date}',
                                style: GoogleFonts.sourceSansPro(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor),
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              Text(
                                'Time:',
                                style: GoogleFonts.sourceSansPro(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromRGBO(235, 235, 245, 0.5),
                                        decoration: TextDecoration.none)),
                              ),
                              SizedBox(
                                width: 25.w,
                              ),
                              Text(
                                '${workShift!.startTime}-${workShift!.endTime}',
                                style: GoogleFonts.sourceSansPro(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor),
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              Text(
                                'Skill:',
                                style: GoogleFonts.sourceSansPro(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromRGBO(235, 235, 245, 0.5),
                                        decoration: TextDecoration.none)),
                              ),
                              SizedBox(
                                width: 25.w,
                              ),
                              Text(
                                '${workShift!.skills}',
                                style: GoogleFonts.sourceSansPro(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor,
                                        decoration: TextDecoration.none)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        MaterialButton(
                          onPressed: () {
                            staff.updateWorkShift(workShift!.uid,
                                {'rejected': FieldValue.arrayUnion([staff.worker!.uid])});
                            Navigator.pop(context);

                            setState(() {
                              workShift = null;
                            });

                            var id = getRandomString(28);
                            staff.postNotifications({
                              'uid': id,
                              'userId': '0hXyXlB4mN3LvcZkMQ99LEJw0LA0',
                              'title': 'Shift Rejected',
                              'shiftId': '',
                              'message':
                              '${staff.worker!.workerName} worker has rejected your shift offer.',
                              'timestamp': DateTime.now().microsecondsSinceEpoch,
                              'status': false
                            });
                          },
                          minWidth: 140.w,
                          height: 50.h,
                          child: Text(
                            'Reject',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: whiteColor,
                                    decoration: TextDecoration.none)),
                          ),
                          color: blackColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              side: BorderSide(color: colorOne)),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        MaterialButton(
                          onPressed: () {
                            staff.updateWorkShift(workShift!.uid,
                                {'accepted': staff.worker!.uid});
                            Navigator.pop(context);
                            setState(() {
                              workShift = null;
                            });

                            var id = getRandomString(28);
                            staff.postNotifications({
                              'uid': id,
                              'userId': '0hXyXlB4mN3LvcZkMQ99LEJw0LA0',
                              'title': 'Shift Accepted',
                              'shiftId': '',
                              'message':
                              '${staff.worker!.workerName} worker has accepted your shift offer.',
                              'timestamp': DateTime.now().microsecondsSinceEpoch,
                              'status': false
                            });
                          },
                          minWidth: 140.w,
                          height: 50.h,
                          child: Text(
                            'Accept',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: whiteColor,
                                    decoration: TextDecoration.none)),
                          ),
                          color: colorOne,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              side: BorderSide(color: colorOne)),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  shiftLog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: colorThree,
            child: Wrap(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
                  child: Column(
                    children: [
                      Text(
                        'Hour Log',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: whiteColor)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                        child: Divider(
                          color: colorFive.withOpacity(0.5),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 15.h),
                        padding: EdgeInsets.only(
                            left: 10.w, right: 20.w, bottom: 30.h, top: 10.h),
                        decoration: BoxDecoration(
                            color: colorFive.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PYour Schedule shift has ended',
                              style: GoogleFonts.sourceSansPro(
                                  textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Color.fromRGBO(235, 235, 245, 0.5))),
                            ),
                            SizedBox(
                              width: 25.w,
                            ),
                            Text(
                              '22 June 2022, 20:02',
                              style: GoogleFonts.sourceSansPro(
                                  textStyle: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor)),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () => Navigator.pop(context),
                        minWidth: 140.w,
                        height: 50.h,
                        child: Text(
                          'Accept',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor)),
                        ),
                        color: colorOne,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            side: BorderSide(color: colorOne)),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
