import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull/aviews/AddWorkerView.dart';
import 'package:pull/aviews/AdminNotificationsView.dart';
import 'package:pull/aviews/AdminProfileView.dart';
import 'package:pull/aviews/AdminSettingsView.dart';
import 'package:pull/aviews/WorkLogListView.dart';
import 'package:pull/aviews/WorkerListView.dart';
import 'package:pull/aviews/WorkerSkillsView.dart';
import 'package:pull/const.dart';
import 'package:pull/providers/staff_provider.dart';
import 'package:pull/views/DetailHourLogView.dart';

import 'AddWorkShiftView.dart';

class AdminMainView extends StatefulWidget {
  const AdminMainView({Key? key}) : super(key: key);

  @override
  State<AdminMainView> createState() => _AdminMainViewState();
}

class _AdminMainViewState extends State<AdminMainView> {
  bool notify = false;
  GlobalKey<ScaffoldState> scafKey = GlobalKey();
  String date = '${DateTime.now().day.toString().length == 1 ? '0${DateTime.now().day}' : DateTime.now().day}/${DateTime.now().month.toString().length == 1 ? '0${DateTime.now().month}' : DateTime.now().month}/${DateTime.now().year}';

  @override
  void initState() {
    super.initState();

    var staff = Provider.of<StaffProvider>(context, listen: false);
    staff.fetchWorkShift();
    staff.fetchWorkers();
    staff.fetchWorkerSkills();
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminProfileView()));
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminNotificationsView()));
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
                ]
              )),
          SizedBox(
            width: 20.w,
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: colorThree,
        child: Column(
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
                        '${staff.workerShiftList.length} Work Shifts done',
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 15.w, bottom: 20.h),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.h, bottom: 28.h),
                      child: Divider(
                        color: colorFive.withOpacity(0.5),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AdminProfileView()));
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddWorkShiftView()));
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/icons/addwork.png',
                              height: 20.h, width: 20.w),
                          SizedBox(
                            width: 20.w,
                          ),
                          Text(
                            'Add Work Shift',
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WorkerListView()));
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/icons/worker.png',
                              height: 20.h, width: 20.w),
                          SizedBox(
                            width: 20.w,
                          ),
                          Text(
                            'Worker',
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WorkerSkillsView()));
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/icons/worklog.png',
                              height: 20.h, width: 20.w),
                          SizedBox(
                            width: 20.w,
                          ),
                          Text(
                            'Worker Skills',
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WorkLogListView()));
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/icons/worklog.png',
                              height: 20.h, width: 20.w),
                          SizedBox(
                            width: 20.w,
                          ),
                          Text(
                            'Work Log List',
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminSettingsView()));
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
              ),
            )
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
                      selectedDayHighlightColor: colorOne,
                      controlsTextStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: whiteColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500)),
                      centerAlignModePicker: true,
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
              Expanded(
                child: ListView.separated(
                    itemCount: staff.workerShiftList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index){
                      var w = staff.workerShiftList
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
                      var w = staff.workerShiftList[index];
                      var d = '';
                      if(w.date != ''){
                        if(DateTime(int.parse(w.date.split('/').last), int.parse(w.date.split('/')[1]), int.parse(w.date.split('/').first)).difference(DateTime.now()).inHours > 24){
                          d = DateTime(int.parse(w.date.split('/').last), int.parse(w.date.split('/')[1]), int.parse(w.date.split('/').first)).difference(DateTime.now()).inDays.toString() + ' days';
                        }else{
                          d = DateTime(int.parse(w.date.split('/').last), int.parse(w.date.split('/')[1]), int.parse(w.date.split('/').first)).difference(DateTime.now()).inHours.toString() + ' hours';
                        }
                      }

                      var diffH = DateTime(int.parse(w.date.split('/').last), int.parse(w.date.split('/')[1]), int.parse(w.date.split('/').first)).difference(DateTime.now()).inHours;

                      return diffH > 0 ?
                      date == w.date ? GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailHourLogView(workShift: w)));
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
                                        Image.asset('assets/icons/location.png', height: 15.h, width: 12.w,),
                                        SizedBox(width: 5.w,),
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
                                    Image.asset('assets/icons/time.png', height: 10.h, width: 10.w,),
                                    SizedBox(width: 5.w,),
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
                                    Image.asset('assets/icons/wait.png', height: 10.h, width: 10.w,),
                                    SizedBox(width: 5.w,),
                                    Text(
                                      'Due in ${d}',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              color: Color.fromRGBO(235, 235, 245, 0.5))),
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
}
