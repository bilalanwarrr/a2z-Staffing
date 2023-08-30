import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull/models/skills_model.dart';
import 'package:pull/widgets/CustomTxtFieldView.dart';

import '../const.dart';
import '../providers/staff_provider.dart';
import '../widgets/CustomButtonView.dart';

class WorkerSkillsView extends StatefulWidget {
  const WorkerSkillsView({Key? key}) : super(key: key);

  @override
  State<WorkerSkillsView> createState() => _WorkerSkillsViewState();
}

class _WorkerSkillsViewState extends State<WorkerSkillsView> {
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
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddSkill()));
              },
              child: Text(
                'Add Skill',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Worker Skills',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: whiteColor)),
            ),
            SizedBox(
              height: 25.h,
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
                hintText: 'Search Skills',
                hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                        color: whiteColor)),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Skill',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: whiteColor)),
                    ),
                  ),
                  Expanded(
                    flex: 1,
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
                    flex: 1,
                    child: Text(
                      'Delete',
                      textAlign: TextAlign.end,
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
                child: ListView.builder(
                    itemCount: staff.skillsList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      staff.skillsList.sort((b, a) => b.timestamp!.compareTo(a.timestamp!));
                      var ws = staff.skillsList[index];

                      return searchTxt.isEmpty
                          ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 10.h),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                '${ws.title}',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor)),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  SizedBox(width: 5.w,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddSkill(skill: ws,)));
                                    },
                                    child: Image.asset(
                                      'assets/icons/edit.png',
                                      height: 16.h,
                                      width: 16.w,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await fireStore.collection('skills').doc(ws.uid).delete().then((value) {
                                        staff.fetchWorkerSkills();
                                      }).catchError((e){});
                                    },
                                    child: Icon(
                                      CupertinoIcons.delete,
                                      size: 18.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: 15.w,)
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                          : ws.title!.toLowerCase().contains(searchTxt.toLowerCase()) ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 10.h),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                '${ws.title}',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor)),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  SizedBox(width: 5.w,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddSkill(skill: ws,)));
                                    },
                                    child: Image.asset(
                                      'assets/icons/edit.png',
                                      height: 16.h,
                                      width: 16.w,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await fireStore.collection('skills').doc(ws.uid).delete().then((value) {
                                        staff.fetchWorkerSkills();
                                      }).catchError((e){});
                                    },
                                    child: Icon(
                                      CupertinoIcons.delete,
                                      size: 18.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: 15.w,)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ) : Container();
                    }))
          ],
        ),
      ),
    );
  }
}

class AddSkill extends StatefulWidget {
  AddSkill({Key? key, this.skill}) : super(key: key);

  WorkerSkills? skill;

  @override
  State<AddSkill> createState() => _AddSkillState();
}

class _AddSkillState extends State<AddSkill> {
  final skillTxt = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.skill != null){
      setState(() {
        skillTxt.text = widget.skill!.title!;
      });
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
              'Add Skill',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: whiteColor)),
            ),
            SizedBox(
              height: 25.h,
            ),
            CustomTxtFieldView(hint: 'Skill Title', txt: skillTxt),
            SizedBox(
              height: 60.h,
            ),
            staff.isLoading == false
                ? CustomButtonView(
                title: widget.skill == null ? 'Add' : 'Update',
                bColor: colorOne,
                onTap: () {
                  if (skillTxt.text.isEmpty) {
                    showToast('Skill should not be empty !');
                  }else {
                    if(widget.skill == null) {
                      postSkill(context);
                    }else{
                      updateSkill(context);
                    }
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
    );
  }

  postSkill(context) async {
    var staff = Provider.of<StaffProvider>(context, listen: false);

    staff.setLoading(true);

    var uid = getRandomString(28);
    var data = {
      'uid': uid,
      'title': skillTxt.text,
      'timestamp': DateTime.now().microsecondsSinceEpoch
    };

    await staff.addWorkSkill(data).then((value) {
      staff.setLoading(false);

      if (value['success'] == true) {
        showToast('Worker skill added successfully !');
        setState(() {
          skillTxt.clear();
        });
      } else {
        showToast(errorTxt);
      }
    }).catchError((e) {
      staff.setLoading(false);
      showToast(errorTxt);
    });
  }

  updateSkill(context) async {
    var staff = Provider.of<StaffProvider>(context, listen: false);

    staff.setLoading(true);

    await staff.updateWorkerSkill(widget.skill!.uid, {'title': skillTxt.text}).then((value) {
      staff.setLoading(false);

      if (value['success'] == true) {
        showToast('Worker skill updated successfully !');
        setState(() {
          skillTxt.clear();
        });
        Navigator.pop(context);
      } else {
        showToast(errorTxt);
      }
    }).catchError((e) {
      staff.setLoading(false);
      showToast(errorTxt);
    });
  }
}

