import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull/const.dart';
import 'package:pull/models/workshift_model.dart';
import 'package:pull/providers/staff_provider.dart';
//
//Shift Detail View
//
class DetailHourLogView extends StatefulWidget {
  DetailHourLogView({Key? key, required this.workShift}) : super(key: key);

  WorkShiftModel workShift;

  @override
  State<DetailHourLogView> createState() => _DetailHourLogViewState();
}

class _DetailHourLogViewState extends State<DetailHourLogView> {
  final startTimeTxt1 = TextEditingController();

  final endTimeTxt1 = TextEditingController();

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
              Container(
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
                            Text(
                              '${widget.workShift.date}',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                      color: whiteColor)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${widget.workShift.startTime} - ${widget.workShift.endTime}',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: colorOne)),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25.h),
                padding: EdgeInsets.only(top: 28.h, left: 24.w, bottom: 15.h),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: colorThree,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Place:',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(235, 235, 245, 0.5))),
                        ),
                        SizedBox(
                          width: 25.w,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/location.png',
                              height: 15.h,
                              width: 12.w,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              '${widget.workShift.workPlace}',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Text(
                          'Skills:',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(235, 235, 245, 0.5))),
                        ),
                        SizedBox(
                          width: 35.w,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/location.png',
                              height: 15.h,
                              width: 12.w,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              '${widget.workShift.skills}',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor)),
                            ),
                          ],
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
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(235, 235, 245, 0.5))),
                        ),
                        SizedBox(
                          width: 28.w,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/time.png',
                              height: 15.h,
                              width: 12.w,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              '${widget.workShift.startTime} - ${widget.workShift.endTime}',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Divider(
                      color: colorFive.withOpacity(0.5),
                      thickness: 1.0,
                      indent: 15.w,
                      endIndent: 15.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Text(
                        'Log Work Hours',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: whiteColor)),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Start Time:',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Color.fromRGBO(235, 235, 245, 0.5))),
                            ),
                            SizedBox(
                              width: 22.w,
                            ),
                            Text(
                              '${widget.workShift.startTime}',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Text(
                              'End Time:',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Color.fromRGBO(235, 235, 245, 0.5))),
                            ),
                            SizedBox(
                              width: 28.w,
                            ),
                            Text(
                              '${widget.workShift.endTime}',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hour Logs',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: whiteColor)),
                  ),
                  GestureDetector(
                    onTap: () {
                      editHourLog(context, null);
                    },
                    child: Text(
                      'Add',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: colorTwo)),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 25.h),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: colorThree,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 10.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '#',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: whiteColor)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Start Time',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: whiteColor)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'End Time',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: whiteColor)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Edit',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: whiteColor)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Delete',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: whiteColor)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: blackColor,
                        thickness: 1.0,
                      ),
                      Expanded(
                        child: ListView.separated(
                            itemCount: widget.workShift.hoursLog.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: blackColor,
                                thickness: 1.0,
                              );
                            },
                            itemBuilder: (context, index) {
                              var items = widget.workShift.hoursLog;
                              items.sort((a, b) =>
                                  a['timestamp'].compareTo(b['timestamp']));
                              var h = items[index];

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 10.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${index + 1}',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: whiteColor)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${h['startTime']}',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: whiteColor)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${h['endTime']}',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: whiteColor)),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            startTimeTxt1.text = h['startTime'];
                                            endTimeTxt1.text = h['endTime'];
                                          });
                                          editHourLog(context, h);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Image.asset(
                                              'assets/icons/edit.png',
                                              height: 18.h,
                                              width: 18.w,
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          var staff =
                                              Provider.of<StaffProvider>(
                                                  context,
                                                  listen: false);

                                          await staff.updateWorkShift(
                                              widget.workShift.uid, {
                                            'hoursLog':
                                                FieldValue.arrayRemove([h])
                                          });

                                          setState(() {
                                            widget.workShift = staff
                                                .workerShiftList
                                                .where((w) =>
                                                    w.uid ==
                                                    widget.workShift.uid)
                                                .first;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Icon(
                                              CupertinoIcons.delete,
                                              size: 20.sp,
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  editHourLog(context, hourLog) {
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
                        'Edit Hour Log',
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
                      Row(
                        children: [
                          Text(
                            'Start Time:',
                            style: GoogleFonts.sourceSansPro(
                                textStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(235, 235, 245, 0.5))),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          GestureDetector(
                            onTap: () async {
                              var msg = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (msg != null) {
                                setState(() {
                                  startTimeTxt1.text =
                                  '${(msg.hour % 12).toString().length == 1 ? '0${msg.hour % 12}' : msg.hour % 12}:${msg.minute.toString().length == 1 ? '0${msg.minute}' : msg.minute}';
                                });
                              }
                            },
                            child: SizedBox(
                              height: 45.h,
                              width: 120.w,
                              child: TextField(
                                controller: startTimeTxt1,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                        color: whiteColor)),
                                textAlign: TextAlign.center,
                                enabled: false,
                                decoration: InputDecoration(
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(color: colorTwo)
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: -7.h),
                                  hintText: '00',
                                  hintStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                          color: whiteColor)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Text(
                            'End Time:',
                            style: GoogleFonts.sourceSansPro(
                                textStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(235, 235, 245, 0.5))),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          GestureDetector(
                            onTap: () async {
                              var msg = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (msg != null) {
                                setState(() {
                                  endTimeTxt1.text =
                                  '${(msg.hour % 12).toString().length == 1 ? '0${msg.hour % 12}' : msg.hour % 12}:${msg.minute.toString().length == 1 ? '0${msg.minute}' : msg.minute}';
                                });
                              }
                            },
                            child: SizedBox(
                              height: 45.h,
                              width: 120.w,
                              child: TextField(
                                controller: endTimeTxt1,
                                enabled: false,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                        color: whiteColor)),
                                textAlign: TextAlign.center,

                                decoration: InputDecoration(
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: BorderSide(color: colorTwo)
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: -7.h),
                                  hintText: '00',
                                  hintStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                          color: whiteColor)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          var staff = Provider.of<StaffProvider>(context,
                              listen: false);

                          if (hourLog == null) {
                            if (startTimeTxt1.text.isNotEmpty &&
                                endTimeTxt1.text.isNotEmpty) {
                              await staff
                                  .updateWorkShift(widget.workShift.uid, {
                                'hoursLog': FieldValue.arrayUnion([
                                  {
                                    'startTime':
                                        '${startTimeTxt1.text}',
                                    'endTime':
                                        '${endTimeTxt1.text}',
                                    'timestamp':
                                        DateTime.now().microsecondsSinceEpoch
                                  }
                                ])
                              });
                            }
                          } else {
                            await staff.updateWorkShift(widget.workShift.uid, {
                              'hoursLog': FieldValue.arrayRemove([hourLog])
                            });
                            await staff.updateWorkShift(widget.workShift.uid, {
                              'hoursLog': FieldValue.arrayUnion([
                                {
                                  'startTime': startTimeTxt1.text.isNotEmpty
                                      ? '${startTimeTxt1.text}'
                                      : hourLog['startTime'],
                                  'endTime': endTimeTxt1.text.isNotEmpty
                                      ? '${endTimeTxt1.text}'
                                      : hourLog['endTime'],
                                  'timestamp': hourLog['timestamp']
                                }
                              ])
                            });
                          }
                          Navigator.pop(context);

                          setState(() {
                            widget.workShift = staff.workerShiftList
                                .where((w) => w.uid == widget.workShift.uid)
                                .first;
                          });
                        },
                        minWidth: 140.w,
                        height: 50.h,
                        child: Text(
                          hourLog != null ? 'Save' : 'Add',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor)),
                        ),
                        color: blackColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            side: BorderSide(color: colorTwo)),
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
