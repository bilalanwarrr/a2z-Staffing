import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerSkills{
  String? uid;
  String? title;
  int? timestamp;

  WorkerSkills.fromSnapshot(DocumentSnapshot snapshot) :
      uid = snapshot.get('uid') ?? '',
      title = snapshot.get('title') ?? '',
      timestamp = snapshot.get('timestamp') ?? '';
}