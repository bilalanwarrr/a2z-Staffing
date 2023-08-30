import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull/models/workshift_model.dart';
import 'package:pull/providers/staff_provider.dart';
import 'package:pull/aviews/FileSaveLocationView.dart';
import 'package:pull/widgets/CustomButtonView.dart';

import '../const.dart';
//
//Worklog list view
//
class WorkLogListView extends StatefulWidget {
  const WorkLogListView({Key? key}) : super(key: key);

  @override
  State<WorkLogListView> createState() => _WorkLogListViewState();
}

class _WorkLogListViewState extends State<WorkLogListView> {
  String searchTxt = '';
  List<List<dynamic>> employeeData = [['Worker', 'Date & Time', 'Shift Hours', 'WorkPlace']];//for exporting to csv file

  @override
  void initState() {
    super.initState();

    var staff = Provider.of<StaffProvider>(context, listen: false);
    staff.fetchWorkShift();
    staff.fetchWorkers();
  }

  //generate csv file
  generatetCSVFile(logList) async {
    var staff = Provider.of<StaffProvider>(context, listen: false);

    if (await Permission.storage.request().isGranted) {
      await Permission.storage.request();

      logList.forEach((l) {
        var temp = [];
        setState(() {
          if (staff.workersList
                  .where((u) => l.accepted != '' && u.uid == l.accepted)
                  .length >
              0) {
            temp.add(
              '${staff.workersList.where((u) => u.uid == l.accepted).first.workerName}'
            );
            temp.add('${l.date}\n${l.startTime}-${l.endTime}');
            temp.add('${l.hoursLog.length}');
            temp.add('${l.workPlace}');
            employeeData.add(temp);
          }
        });
      });

      //Navigate to select location for file saving
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FileSaveLocationView(employeeData: employeeData)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var staff = Provider.of<StaffProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              staff.setFilterOpt(0);
              Navigator.pop(context);
            },
            child: Image.asset('assets/icons/back.png')),
      ),
      body: WillPopScope(
        onWillPop: () async {
          staff.setFilterOpt(0);
          return true;
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Work Log List',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: whiteColor)),
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          searchTxt = val;
                        });
                      },
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: whiteColor)),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: whiteColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: whiteColor)),
                        suffixIcon: Icon(
                          CupertinoIcons.search,
                          color: colorOne,
                        ),
                        hintText: 'Search by Workplace or Worker',
                        // hintText: 'Search by ${staff.filterOpt == 2 ? 'Workplace' : 'Worker'}',
                        hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp,
                                color: whiteColor)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var msg = await showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(),
                        dialogSize: const Size(325, 400),
                        borderRadius: BorderRadius.circular(15),
                      );

                      if (msg != null) {
                        setState(() {
                          searchTxt =
                              '${msg.first!.day.toString().length == 1 ? '0${msg.first!.day}' : msg.first!.day}/${msg.first!.month.toString().length == 1 ? '0${msg.first!.month}' : msg.first!.month}/${msg.first!.year}';
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 5.w),
                            // margin: EdgeInsets.only(bottom: 5.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 18.h, horizontal: 15.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: whiteColor)),
                            child: Image.asset(
                              'assets/icons/date.png',
                              color:
                                  staff.filterOpt == 1 ? whiteColor : colorOne,
                            )),
                      ],
                    ),
                  ),
                  searchTxt.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              searchTxt = '';
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 3.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 20.h),
                            decoration: BoxDecoration(
                                border: Border.all(color: whiteColor),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                color: colorOne,
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.h, top: 25.h),
                child: Text(
                  '${searchTxt.isEmpty ? staff.workerShiftList.where((w) => w.accepted != '').length : staff.workerShiftList.where((w) => w.accepted != '' && staff.workersList.where((u) => u.uid == w.accepted).first.workerName.toLowerCase().contains(searchTxt.toLowerCase())).length} Results',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(235, 235, 245, 0.5))),
                ),
              ),
              Expanded(
                child: Container(
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
                                'Worker',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: whiteColor)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Date & Time',
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: whiteColor)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Shift Hours',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: whiteColor)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'WorkPlace',
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
                        child: staff.filterOpt == 0 || staff.filterOpt == 2
                            ? logList(staff.workerShiftList)
                            : logList(staff.filterList),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text('Export CSV',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: whiteColor))),
                  color: blackColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.r),
                      side: BorderSide(color: colorOne)),
                  onPressed: () {
                    staff.filterOpt == 0
                        ? generatetCSVFile(staff.workerShiftList)
                        : generatetCSVFile(staff.filterList);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //Show all logs here...
  Widget logList(items) {
    var staff = Provider.of<StaffProvider>(context, listen: false);
    return ListView.separated(
        itemCount: items.where((w) => w.accepted != '').toList().length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) {
          var w = items.where((w) => w.accepted != '').toList()[index];
          return searchTxt.isEmpty
              ? staff.workersList.where((u) => u.uid == w.accepted).length > 0
                  ? Divider(
                      color: blackColor,
                      thickness: 1.0,
                    )
                  : Container()
              : staff.workersList
                          .where((u) => u.uid == w.accepted)
                          .first
                          .workerName
                          .toLowerCase()
                          .contains(searchTxt.toLowerCase()) ==
                      true
                  ? staff.workersList.where((u) => u.uid == w.accepted).length >
                          0
                      ? Divider(
                          color: blackColor,
                          thickness: 1.0,
                        )
                      : Container()
                  : Container();
        },
        itemBuilder: (context, index) {
          var w = items.where((w) => w.accepted != '').toList()[index];
          return searchTxt.isEmpty
              ? staff.workersList.where((u) => u.uid == w.accepted).length > 0
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${staff.workersList.where((u) => u.uid == w.accepted).first.workerName}',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor)),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${w.date}\n${w.startTime}-${w.endTime}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 25.w),
                              child: Text(
                                '${w.hoursLog.length}',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${w.workPlace} ',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container()
              : staff.workersList
                          .where((u) => u.uid == w.accepted)
                          .first
                          .workerName
                          .toLowerCase()
                          .contains(searchTxt.toLowerCase()) ||
                      items
                          .where((w) => w.accepted != '')
                          .toList()[index]
                          .workPlace
                          .toLowerCase()
                          .contains(searchTxt.toLowerCase()) ||
                      items
                          .where((w) => w.accepted != '')
                          .toList()[index]
                          .date
                          .toLowerCase()
                          .contains(searchTxt.toLowerCase())
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${staff.workersList.where((u) => u.uid == w.accepted).first.workerName} ',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor)),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${w.date}\n${w.startTime}-${w.endTime}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 25.w),
                              child: Text(
                                '${w.hoursLog.length}',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${w.workPlace} ',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container();
        });
  }
}
