import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull/providers/staff_provider.dart';

import '../const.dart';

class AdminNotificationsView extends StatefulWidget {
  const AdminNotificationsView({Key? key}) : super(key: key);

  @override
  State<AdminNotificationsView> createState() => _AdminNotificationsViewState();
}

class _AdminNotificationsViewState extends State<AdminNotificationsView> {

  @override
  void initState() {
    super.initState();

    updateNotifications();
  }

  updateNotifications() async {
    var staff = Provider.of<StaffProvider>(context, listen: false);

    var nList = staff.notificationsList
        .where((n) => n.userId == staff.worker!.uid)
        .toList();
    nList.forEach((n) async {
      if (n.status == false) {
        await fireStore
            .collection('notifications')
            .doc(n.uid)
            .update({'status': true});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var staff = Provider.of<StaffProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              staff.fetchNotifications();
              Navigator.pop(context);
            },
            child: Image.asset('assets/icons/back.png')),
      ),
      body: WillPopScope(
        onWillPop: () async {
          staff.fetchNotifications();
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
                'Notifications',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: whiteColor)),
              ),
              SizedBox(
                height: 25.h,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: staff.notificationsList.where((n) => n.userId == staff.worker!.uid).length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      var nList = staff.notificationsList.where((n) => n.userId == staff.worker!.uid).toList();
                      nList.sort((a,b) => b.timestamp.compareTo(a.timestamp));

                      var n =  nList[index];

                      return Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(64, 64, 64, 1),
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${n.title}', style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.sp,
                                            color: whiteColor)),),
                                    Text(
                                      '${n.message}', style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            color: whiteColor)),),
                                  ],
                                )),
                            SizedBox(width: 10.w,),
                            Text(
                              '${DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(n.timestamp))}', style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    color: whiteColor)),)
                          ],
                        ),
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
