import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull/aviews/AddWorkerView.dart';
import 'package:pull/providers/staff_provider.dart';

import '../const.dart';
//
//All Workers
//
class WorkerListView extends StatefulWidget {
  const WorkerListView({Key? key}) : super(key: key);

  @override
  State<WorkerListView> createState() => _WorkerListViewState();
}

class _WorkerListViewState extends State<WorkerListView> {
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
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddWorkerView()));
              },
              color: colorOne,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
              child: Text(
                'New Worker',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: whiteColor)),
              ),
            ),
          ),
          SizedBox(
            width: 20.w,
          )
        ],
      ),
      body: Container(
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
              'Worker List',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: whiteColor)),
            ),
            SizedBox(
              height: 30.h,
            ),
            TextField(
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
                hintText: 'Search Worker',
                hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                        color: whiteColor)),
              ),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
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
                              'Username',
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
                              'Password',
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
                              'Role',
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
                          itemCount: staff.workersList.length,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return staff.workersList[index].userName
                                        .contains(searchTxt)
                                    ? Divider(
                                        color: blackColor,
                                        thickness: 1.0,
                                      )
                                    : Container();
                          },
                          itemBuilder: (context, index) {
                            return staff.workersList[index].userName
                                        .contains(searchTxt)
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 10.h),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${index}',
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: whiteColor)),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                '${staff.workersList[index].userName}',
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: whiteColor)),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                '${staff.workersList[index].password}',
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: whiteColor)),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                '${staff.workersList[index].role}',
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        color: whiteColor)),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddWorkerView(
                                                                worker: staff
                                                                        .workersList[
                                                                    index],
                                                              )));
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
                                                      height: 12.h,
                                                      width: 12.w,
                                                      color: Colors.red,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await fireStore
                                                      .collection('workShift')
                                                      .get()
                                                      .then((val) {
                                                    val.docs.forEach((doc) async {
                                                      if(doc.get('accepted') == staff.workersList[index].uid || doc.get('rejected').contains(staff.workersList[index].uid)){
                                                        await fireStore.collection('workShift').doc(doc.id).delete();
                                                      }
                                                    });
                                                  });

                                                  await fireStore.collection('workers').doc(staff.workersList[index].uid).delete().then((value) async {
                                                    await staff.fetchWorkers();

                                                    showToast('Worker deleted successfully !');
                                                  }).catchError((e){showToast(errorTxt);});
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
                                                      size: 14.sp,
                                                      color: Colors.red,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container();
                          }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
