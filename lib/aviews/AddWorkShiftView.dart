import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull/aviews/AllWorkShiftsView.dart';
import 'package:pull/const.dart';
import 'package:pull/providers/staff_provider.dart';
import 'package:pull/widgets/CustomButtonView.dart';
import 'package:pull/widgets/CustomTxtFieldView.dart';

//
//Add new workshift
//
class AddWorkShiftView extends StatefulWidget {
  AddWorkShiftView({Key? key}) : super(key: key);

  @override
  State<AddWorkShiftView> createState() => _AddWorkShiftViewState();
}

class _AddWorkShiftViewState extends State<AddWorkShiftView> {
  final workplaceTxt = TextEditingController();
  final startTimeTxt = TextEditingController();
  final endTimeTxt = TextEditingController();
  final dateTxt = TextEditingController();
  final hourlyRateTxt = TextEditingController();
  final skillTxt = TextEditingController();

  var skillList = [];

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
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllWorkShiftsView()));
              },
              child: Text(
                'All Workshifts',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: colorOne)),
              ))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Add Work Shift',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: whiteColor)),
              ),
              SizedBox(
                height: 25.h,
              ),
              CustomTxtFieldView(hint: 'Workplace', txt: workplaceTxt),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                  onTap: () {
                    showSkillList(context);
                  },
                  child: CustomTxtFieldView(
                    hint: 'Skill',
                    txt: skillTxt,
                    enabled: false,
                  )),
              SizedBox(
                height: 20.h,
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
                        dateTxt.text =
                            '${msg.first!.day.toString().length == 1 ? '0${msg.first!.day}' : msg.first!.day}/${msg.first!.month.toString().length == 1 ? '0${msg.first!.month}' : msg.first!.month}/${msg.first!.year}';
                      });
                    }
                  },
                  child: CustomTxtFieldView(
                    hint: 'Date',
                    txt: dateTxt,
                    enabled: false,
                  )),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      var msg = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (msg != null) {
                        setState(() {
                          startTimeTxt.text =
                              '${(msg.hour % 12).toString().length == 1 ? '0${msg.hour % 12}' : msg.hour % 12}:${msg.minute.toString().length == 1 ? '0${msg.minute}' : msg.minute}';
                        });
                      }
                    },
                    child: CustomTxtFieldView(
                      hint: 'Start Time',
                      txt: startTimeTxt,
                      enabled: false,
                    ),
                  )),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      var msg = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (msg != null) {
                        setState(() {
                          endTimeTxt.text =
                              '${(msg.hour % 12).toString().length == 1 ? '0${msg.hour % 12}' : msg.hour % 12}:${msg.minute.toString().length == 1 ? '0${msg.minute}' : msg.minute}';
                        });
                      }
                    },
                    child: CustomTxtFieldView(
                      hint: 'End Time',
                      txt: endTimeTxt,
                      enabled: false,
                    ),
                  )),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomTxtFieldView(hint: 'Hourly Rate', txt: hourlyRateTxt),
              SizedBox(
                height: 80.h,
              ),
              staff.isLoading == false
                  ? CustomButtonView(
                      title: 'Add',
                      bColor: colorOne,
                      onTap: () {
                        if (workplaceTxt.text.isEmpty) {
                          showToast('Workplace should not be empty !');
                        } else if (skillTxt.text.isEmpty) {
                          showToast('Skills should not be empty !');
                        } else if (dateTxt.text.isEmpty) {
                          showToast('Date should not be empty !');
                        } else if (startTimeTxt.text.isEmpty) {
                          showToast('Start Time should not be empty !');
                        } else if (endTimeTxt.text.isEmpty) {
                          showToast('End Time should not be empty !');
                        } else if (hourlyRateTxt.text.isEmpty) {
                          showToast('Hourly Rate should not be empty !');
                        } else {
                          postWorkShift();
                        }
                      })
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingWidget(),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  postWorkShift() async {
    var staff = Provider.of<StaffProvider>(context, listen: false);

    staff.setLoading(true);

    var uid = getRandomString(28);
    var data = {
      'uid': uid,
      'workPlace': workplaceTxt.text,
      'startTime': startTimeTxt.text,
      'endTime': endTimeTxt.text,
      'hourlyRate': hourlyRateTxt.text,
      'skills': skillTxt.text,
      'rejected': [],
      'accepted': '',
      'date': dateTxt.text,
      'hoursLog': []
    };

    await staff.addWorkShift(data).then((value) {
      staff.setLoading(false);

      if (value['success'] == true) {
        showToast('Work shift added successfully !');
        setState(() {
          workplaceTxt.clear();
          startTimeTxt.clear();
          endTimeTxt.clear();
          skillTxt.clear();
          hourlyRateTxt.clear();
          dateTxt.clear();
        });
      } else {
        showToast(errorTxt);
      }
    }).catchError((e) {
      staff.setLoading(false);
      showToast(errorTxt);
    });
  }

  showSkillList(context) {
    var staff = Provider.of<StaffProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              backgroundColor: colorThree,
              child: Wrap(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              'Select Skills',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: whiteColor)),
                            ),
                            Spacer(),
                            GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  Icons.close,
                                  color: whiteColor,
                                  size: 20.sp,
                                ))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                          child: Divider(
                            color: colorFive.withOpacity(0.5),
                          ),
                        ),
                        SizedBox(
                          height: 200.h,
                          child: ListView.builder(
                              itemCount: staff.skillsList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index){
                                return GestureDetector(
                                  onTap: () {
                                    if (skillList.contains('${staff.skillsList[index].title}') == true) {
                                      setState(() {
                                        skillList.remove('${staff.skillsList[index].title}');
                                      });
                                    } else {
                                      setState(() {
                                        skillList.add('${staff.skillsList[index].title}');
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: index != (staff.skillsList.length - 1) ? 15.0 : 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 20.h,
                                          width: 20.w,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: colorOne)),
                                          child: Center(
                                            child: skillList.contains('${staff.skillsList[index].title}')
                                                ? Icon(
                                              Icons.done,
                                              size: 15.sp,
                                              color: colorOne,
                                            )
                                                : Container(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '${staff.skillsList[index].title}',
                                          style: GoogleFonts.sourceSansPro(
                                              textStyle: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: whiteColor)),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              skillTxt.clear();
                              skillList.forEach((s) {
                                skillTxt.text += s;
                                if (s != skillList.last) {
                                  skillTxt.text += ', ';
                                }
                              });
                            });

                            Navigator.pop(context);
                          },
                          minWidth: 140.w,
                          height: 50.h,
                          child: Text(
                            'Add Skills',
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
        });
  }
}
