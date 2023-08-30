import 'package:cloud_firestore/cloud_firestore.dart';

class WorkShiftModel{
  final String uid;
  final String workPlace;
  final String startTime;
  final String endTime;
  final String hourlyRate;
  final String skills;
  final String date;
  final String accepted;
  final List<dynamic> rejected;
  final List<dynamic> hoursLog;

  WorkShiftModel.fromSnapshot(DocumentSnapshot snapshot) :
      uid = snapshot.get('uid') ?? '',
      workPlace = snapshot.get('workPlace') ?? '',
      startTime = snapshot.get('startTime') ?? '',
      endTime = snapshot.get('endTime') ?? '',
      hourlyRate = snapshot.get('hourlyRate') ?? '',
      skills = snapshot.get('skills') ?? '',
      date = snapshot.get('date') ?? '',
      accepted = snapshot.get('accepted') ?? '',
      rejected = snapshot.get('rejected') ?? [],
      hoursLog = snapshot.get('hoursLog') ?? [];
}