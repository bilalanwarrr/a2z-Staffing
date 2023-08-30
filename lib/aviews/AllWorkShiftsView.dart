import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import '../providers/staff_provider.dart';

class AllWorkShiftsView extends StatefulWidget {
  const AllWorkShiftsView({Key? key}) : super(key: key);

  @override
  State<AllWorkShiftsView> createState() => _AllWorkShiftsViewState();
}

class _AllWorkShiftsViewState extends State<AllWorkShiftsView> {
  String searchTxt = '';

  @override
  Widget build(BuildContext context) {
    var staff = Provider.of<StaffProvider>(context);

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
              'Work Shifts',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: whiteColor)),
            ),
            SizedBox(
              height: 25.h,
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
                      hintText: 'Search by Workplace',
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
                  child: Container(
                    margin: EdgeInsets.only(left: 5.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        color: colorOne,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Center(
                      child: Icon(
                        Icons.calendar_month,
                        color: whiteColor,
                      ),
                    ),
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
                              horizontal: 8.w, vertical: 12.h),
                          decoration: BoxDecoration(
                              color: colorOne,
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Center(
                            child: Icon(
                              Icons.close,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'WorkerPlace',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: whiteColor)),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.w),
                      child: Text(
                        'Accepted By',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: whiteColor)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.w),
                      child: Text(
                        'Date',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: whiteColor)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Status',
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
            //list of workshifts
            Expanded(
                child: ListView.builder(
                    itemCount: staff.workerShiftList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      var ws = staff.workerShiftList[index];

                      return searchTxt.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 10.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${ws.workPlace}',
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
                                      '${ws.accepted != '' ? staff.workersList.where((w) => w.uid == ws.accepted).first.workerName : ws.rejected.isNotEmpty ? '${ws.rejected.length} Worker Reject' : 'Pending'}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: whiteColor)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 25.w),
                                      child: Text(
                                        '${ws.date}',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: whiteColor)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (ws.rejected.isNotEmpty ||
                                            ws.accepted == '') {
                                          await staff.updateWorkShift(
                                              ws.uid, {'rejected': []});
                                        }
                                      },
                                      child: Text(
                                        '${ws.accepted != '' ? 'Accepted' : ws.rejected.isNotEmpty ? 'Resend' : 'Pending'}',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: ws.accepted != ''
                                                    ? Colors.green
                                                    : ws.rejected.isNotEmpty
                                                        ? Colors.red
                                                        : whiteColor)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ws.workPlace
                                      .toLowerCase()
                                      .contains(searchTxt.toLowerCase()) ||
                          ws.accepted.isNotEmpty && staff.workersList
                                      .where((wl) =>
                                          ws.accepted == wl.uid)
                                      .first
                                      .workerName
                                      .toLowerCase()
                                      .contains(searchTxt.toLowerCase()) ||
                                  ws.date == searchTxt
                              ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 10.h),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${ws.workPlace}',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 25.w),
                                child: Text(
                                  '${ws.accepted != '' ? staff.workersList.where((w) => w.uid == ws.accepted).first.workerName : ws.rejected.isNotEmpty ? 'Rejected' : 'Pending'}',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: whiteColor)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 25.w),
                                child: Text(
                                  '${ws.date}',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: whiteColor)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  if (ws.rejected.isNotEmpty ||
                                      ws.accepted == '') {
                                    await staff.updateWorkShift(
                                        ws.uid, {'rejected': []});
                                  }
                                },
                                child: Text(
                                  '${ws.accepted != '' ? 'Accepted' : ws.rejected.isNotEmpty ? 'Resend' : 'Pending'}',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: ws.accepted != ''
                                              ? Colors.green
                                              : ws.rejected.isNotEmpty
                                              ? Colors.red
                                              : whiteColor)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                              : Container();
                    }))
          ],
        ),
      ),
    );
  }
}
