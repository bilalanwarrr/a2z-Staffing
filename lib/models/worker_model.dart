import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerModel{
  final String uid;
  final String workerName;
  final String userName;
  final String password;
  final String skills;
  final String profilePicture;
  final String role;

  WorkerModel.fromSnapshot(DocumentSnapshot snapshot) :
      uid = snapshot.get('uid') ?? '',
      workerName = snapshot.get('workerName') ?? '',
      userName = snapshot.get('userName') ?? '',
      password = snapshot.get('password') ?? '',
      skills = snapshot.get('skills') ?? '',
      profilePicture = snapshot.get('profilePicture') ?? '',
      role = snapshot.get('role') ?? '';
}