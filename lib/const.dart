import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull/services/firebaseService.dart';


const colorOne = Color.fromRGBO(229, 174, 89, 1);
const colorTwo = Color.fromRGBO(249, 231, 165, 1);
const colorThree = Color.fromRGBO(30, 30, 30, 1);
const colorFour = Color.fromRGBO(255, 0, 0, 1);
const colorFive = Color.fromRGBO(175, 175, 175, 1);
//
const colorSix = Color.fromRGBO(69, 69, 69, 1);
const colorSeven = Color.fromRGBO(222, 222, 222, 1);
const blackColor = Colors.black;
const whiteColor = Colors.white;

FirebaseFirestore fireStore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
FirebaseService service = FirebaseService();

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String errorTxt = 'Something went wrong! try again';

String profilePicture = 'https://i.pravatar.cc/150?img=3';

showToast(msg) {
  Fluttertoast.showToast(
      msg: msg, backgroundColor: Colors.black, toastLength: Toast.LENGTH_SHORT);
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: CircularProgressIndicator(
        color: whiteColor,
      ),
    );
  }
}