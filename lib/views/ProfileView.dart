import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull/providers/staff_provider.dart';
import 'package:pull/widgets/CustomButtonView.dart';
import 'package:pull/widgets/CustomTxtFieldView.dart';

import '../const.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final userNameTxt = TextEditingController();
  final workerNameTxt = TextEditingController();
  final passwordTxt = TextEditingController();
  File? file;

  @override
  void initState() {
    super.initState();

    var staff = Provider.of<StaffProvider>(context, listen: false);

    setState(() {
      userNameTxt.text = staff.worker!.userName;
      workerNameTxt.text = staff.worker!.workerName;
      passwordTxt.text = staff.worker!.password;
    });
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Text(
                    'Profile',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: whiteColor)),
                  ),
                ],
              ),
              Container(
                height: 250.h,
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      var msg = await FilePicker.platform.pickFiles();

                      if (msg != null) {
                        setState(() {
                          file = File(msg.files.first.path!);
                        });
                      }
                    },
                    child: file == null
                        ? CircleAvatar(
                            radius: 80.h,
                            backgroundImage:
                                NetworkImage('${staff.worker!.profilePicture}'),
                          )
                        : CircleAvatar(
                            radius: 80.h,
                            backgroundImage: FileImage(file!),
                          ),
                  ),
                ),
              ),
              CustomTxtFieldView(hint: 'User Name', txt: userNameTxt),
              SizedBox(
                height: 20.h,
              ),
              CustomTxtFieldView(hint: 'Worker Name', txt: workerNameTxt),
              SizedBox(
                height: 20.h,
              ),
              CustomTxtFieldView(hint: 'Password', txt: passwordTxt),
              SizedBox(
                height: 60.h,
              ),
              CustomButtonView(
                  title: staff.isLoading == false ? 'Save' : 'Loading...',
                  bColor: colorOne,
                  onTap: () {
                    updateProfile();
                  })
            ],
          ),
        ),
      ),
    );
  }

  updateProfile() async {
    var staff = Provider.of<StaffProvider>(context, listen: false);

    staff.setLoading(true);

    var data = {
      'userName': userNameTxt.text,
      'workerName': workerNameTxt.text,
      'password': passwordTxt.text,
    };

    if (file != null) {
      var id = getRandomString(5);
      var f = {
        'id': id,
        'fileName': DateTime.now().microsecondsSinceEpoch.toString(),
        'file': file
      };

      await staff.postStorage('profiles', f).then((val) {
        data.addAll({'profilePicture': val});
      }).catchError((e) {
        staff.setLoading(false);
      });
    }

    await staff.updateWorker(staff.worker!.uid, data).then((value) {
      staff.setLoading(false);

      if (value['success'] == true) {
        showToast('Profile updated successfully !');
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
