import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import '../providers/staff_provider.dart';
import 'DetailHourLogView.dart';

class ScheduleListView extends StatefulWidget {
  const ScheduleListView({Key? key}) : super(key: key);

  @override
  State<ScheduleListView> createState() => _ScheduleListViewState();
}

class _ScheduleListViewState extends State<ScheduleListView> {
  List<String> dates = [];

  @override
  void initState() {
    super.initState();

    var staff = Provider.of<StaffProvider>(context, listen: false);

    List<String> tempList = [];

    setState(() {
      staff.workerShiftList
          .where((w) => w.accepted.contains(staff.worker!.uid))
          .toList().forEach((d) {
        tempList.add(d.date.replaceAll(' ', ''));
      });
    });

    dates = tempList.toSet().toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var staff = Provider.of<StaffProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/icons/back.png')),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Text(
                    'Schedule List',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: whiteColor)),
                  ),
                ],
              ),
              SizedBox(
                height: 25.h,
              ),

              Expanded(
                child: ListView.separated(
                    itemCount: dates
                        .length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: colorFive.withOpacity(0.5),
                        thickness: 1.0,
                        indent: 15.w,
                        endIndent: 15.w,
                      );
                    },
                    itemBuilder: (context, index) {
                      var wsList = dates;

                      wsList.sort((a, b) => DateTime(
                              int.parse(b.split('/').last),
                              int.parse(b.split('/')[1]),
                              int.parse(b.split('/').first))
                          .compareTo(DateTime(
                              int.parse(a.split('/').last),
                              int.parse(a.split('/')[1]),
                              int.parse(a.split('/').first))));

                      var w = wsList[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${w}', style: GoogleFonts.poppins(textStyle: TextStyle(color: whiteColor, fontWeight: FontWeight.w600, fontSize: 18.sp, letterSpacing: 1.0)),),
                          ListView.builder(
                              itemCount:  staff.workerShiftList
                                  .where((w) => w.accepted.contains(staff.worker!.uid)).length,
                              shrinkWrap: true,
                              itemBuilder: (context, index){
                                var ww =  staff.workerShiftList
                                    .where((w) => w.accepted.contains(staff.worker!.uid)).toList()[index];

                                var d = '';

                                if(DateTime(int.parse(ww.date.split('/').last), int.parse(ww.date.split('/')[1]), int.parse(ww.date.split('/').first)).difference(DateTime.now()).inHours > 24){
                                  d = DateTime(int.parse(ww.date.split('/').last), int.parse(ww.date.split('/')[1]), int.parse(ww.date.split('/').first)).difference(DateTime.now()).inDays.toString() + ' days';
                                }else{
                                  d = DateTime(int.parse(ww.date.split('/').last), int.parse(ww.date.split('/')[1]), int.parse(ww.date.split('/').first)).difference(DateTime.now()).inHours.toString() + ' hours';
                                }

                                return ww.date == w ? GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailHourLogView(workShift: ww)));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10.h),
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
                                                      '${ww.workPlace}',
                                                      style: GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight.w400,
                                                              color: whiteColor)),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '${ww.skills}',
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
                                                  '${ww.startTime} - ${ww.endTime}',
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
                                  ),
                                ) : Container();
                              }
                          )
                        ],
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
