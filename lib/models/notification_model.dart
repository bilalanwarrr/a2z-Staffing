import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationModel {
  final String uid;
  final String userId;
  final String title;
  final String message;
  final String shiftId;
  final int timestamp;
  final bool status;

  NotificationModel.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.get('uid') ?? '',
        userId = snapshot.get('userId') ?? '',
        title = snapshot.get('title') ?? '',
        message = snapshot.get('message') ?? '',
        shiftId = snapshot.get('shiftId') ?? '',
        timestamp = snapshot.get('timestamp') ?? '',
        status = snapshot.get('status') ?? false;
}
