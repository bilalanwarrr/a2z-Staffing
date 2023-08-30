import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull/models/worker_model.dart';
import 'package:pull/providers/staff_provider.dart';

import '../const.dart';
import '../widgets/CustomButtonView.dart';
import '../widgets/CustomTxtFieldView.dart';
import 'package:provider/provider.dart';

class AddWorkerView extends StatefulWidget {
  AddWorkerView({Key? key, this.worker}) : super(key: key);

  final WorkerModel? worker;

  @override
  State<AddWorkerView> createState() => _AddWorkerViewState();
}

class _AddWorkerViewState extends State<AddWorkerView> {
  var skillList = [];

  final workerNameTxt = TextEditingController();
  final userNameTxt = TextEditingController();
  final passwordTxt = TextEditingController();
  final skillTxt = TextEditingController();
  final roleTxt = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.worker != null){
      setState(() {
        workerNameTxt.text = widget.worker!.workerName;
        userNameTxt.text = widget.worker!.userName;
        passwordTxt.text = widget.worker!.password;
        skillTxt.text = widget.worker!.skills;
        roleTxt.text = widget.worker!.skills;
      });

      setState(() {
        skillTxt.text.split(',').toList().forEach((s) {
          skillList.add(s.trim());
        });
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(
                '${widget.worker == null ? 'Add' : 'Update'} Worker',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: whiteColor)),
              ),
              SizedBox(
                height: 25.h,
              ),
              CustomTxtFieldView(hint: 'Worker Name', txt: workerNameTxt),
              SizedBox(
                height: 20.h,
              ),
              CustomTxtFieldView(hint: 'Username', txt: userNameTxt),
              widget.worker == null ? SizedBox(
                height: 20.h,
              ) : Container(),
              widget.worker == null ? GestureDetector(
                  onTap: () {
                    showRoles(context);
                  },
                  child: CustomTxtFieldView(hint: 'Role', txt: roleTxt, enabled: false,)) : Container(),
              SizedBox(
                height: 20.h,
              ),
               GestureDetector(
                  onTap: () {
                    if(roleTxt.text == 'Admin'){
                      showToast('Change role for worker');
                    }else{
                      showSkillList(context);
                    }
                  },
                  child: CustomTxtFieldView(hint: 'Skills', txt: skillTxt, enabled: false,)),
              SizedBox(
                height: 20.h,
              ),
              CustomTxtFieldView(hint: 'Password', txt: passwordTxt),
              SizedBox(
                height: 80.h,
              ),
              staff.isLoading == false ? CustomButtonView(
                  title: widget.worker == null ? 'Add' : 'Update',
                  bColor: colorOne,
                  onTap: () {
                    if(widget.worker != null){
                      updateWorker();
                    }else{
                      if(workerNameTxt.text.isEmpty){
                        showToast('Worker Name should not be empty !');
                      }else if(userNameTxt.text.isEmpty){
                        showToast('User Name should not be empty !');
                      }else if(skillTxt.text.isEmpty && roleTxt.text != 'Admin'){
                        showToast('Skills should not be empty !');
                      }else if(passwordTxt.text.isEmpty){
                        showToast('Password should not be empty !');
                      }else{
                          postWorker();
                      }
                    }
                  }) : Row(
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

  postWorker() async {
    var staff = Provider.of<StaffProvider>(context, listen: false);

    // staff.setLoading(true);
    var uid = getRandomString(28);

    var data = {
      'uid': uid,
      'userName': userNameTxt.text,
      'workerName': workerNameTxt.text,
      'password': passwordTxt.text,
      'skills': skillTxt.text,
      'profilePicture': 'https://i.pravatar.cc/150?img=3',
      'role': roleTxt.text.toLowerCase()
    };

    await staff.addWorker(data).then((value) {
      staff.setLoading(false);

      if(value['success'] == true){
        showToast('Worker added successfully !');
        Navigator.pop(context);
      }else{
        showToast(errorTxt);
      }

    }).catchError((e){
      staff.setLoading(false);
      showToast(errorTxt);
    });
  }

  updateWorker() async {
    var staff = Provider.of<StaffProvider>(context, listen: false);

    staff.setLoading(true);

    var data = {
      'userName': userNameTxt.text,
      'workerName': workerNameTxt.text,
      'password': passwordTxt.text,
      'skills': skillTxt.text
    };

    await staff.updateWorker(widget.worker!.uid, data).then((value) {
      staff.setLoading(false);

      if(value['success'] == true){
        showToast('Worker updated successfully !');
        Navigator.pop(context);
      }else{
        showToast(errorTxt);
      }

    }).catchError((e){
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
                                 if(s != skillList.last) {
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

  showRoles(context) {
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
                              'Select Role',
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
                        GestureDetector(
                          onTap: () {
                            if (roleTxt.text == 'Admin') {
                              setState(() {
                                roleTxt.clear();
                              });
                            } else {
                              setState(() {
                                roleTxt.text = 'Admin';
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 20.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: colorOne)),
                                child: Center(
                                  child: roleTxt.text == 'Admin'
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
                                'Admin',
                                style: GoogleFonts.sourceSansPro(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (roleTxt.text == 'Worker') {
                              setState(() {
                                roleTxt.clear();
                              });
                            } else {
                              setState(() {
                                roleTxt.text = 'Worker';
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 20.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: colorOne)),
                                child: Center(
                                  child: roleTxt.text == 'Worker'
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
                                'Worker',
                                style: GoogleFonts.sourceSansPro(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          minWidth: 140.w,
                          height: 50.h,
                          child: Text(
                            'Select Role',
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
