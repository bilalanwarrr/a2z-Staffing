import 'package:flutter/widgets.dart';
import 'package:pull/const.dart';
import 'package:pull/models/notification_model.dart';
import 'package:pull/models/skills_model.dart';
import 'package:pull/models/worker_model.dart';
import 'package:pull/models/workshift_model.dart';

class StaffProvider extends ChangeNotifier{
  bool isLoading = false;
  int filterOpt = 0;
  List<WorkerModel>  workersList = [];
  List<WorkShiftModel>  workerShiftList = [];
  List<WorkShiftModel>  filterList = [];
  List<NotificationModel>  notificationsList = [];
  List<WorkerSkills>  skillsList = [];
  WorkerModel? worker;


  setLoading(val){
    isLoading = val;
    notifyListeners();
  }

  setFilterOpt(val){
    filterOpt = val;
    notifyListeners();
  }

  setFilterList(List<WorkShiftModel> val){
    filterList = val;
    notifyListeners();
  }

  Future fetchUserById() async {
    var msg = await service.fetchLoginUser(worker!.uid);

    if (msg != null) {
      worker = WorkerModel.fromSnapshot(msg);
      notifyListeners();
    }

    return msg;
  }

  Future signInWorker(name, pass) async {
    var msg = await service.signIn(name, pass);

    if(msg != null){
      worker = WorkerModel.fromSnapshot(msg);
      notifyListeners();
    }

    return msg;
  }

  Future updateWorker(uid, Map<String, dynamic> data) async {
    var msg = await service.updateDocument("workers", uid, data);

    if (msg['success'] == true) {
      await fetchUserById();
      await fetchWorkers();
    }

    return msg;
  }

  Future addWorker(data) async {

    var msg = await service.postDocumentWithId('workers', data['uid'], data);

    if(msg['success'] == true){
      await fetchWorkers();
    }

    return msg;
  }

  Future fetchWorkers() async {

    var msg = await service.fetchDocuments("workers");

    if (workersList.isNotEmpty) {
      workersList.clear();

      msg.docs.forEach((doc) {
        WorkerModel u = WorkerModel.fromSnapshot(doc);
        workersList.add(u);
        notifyListeners();
      });
    } else {
      msg.docs.forEach((doc) {
        WorkerModel u = WorkerModel.fromSnapshot(doc);
        workersList.add(u);
        notifyListeners();
      });
    }
  }

  Future addWorkShift(data) async {

    var msg = await service.postDocumentWithId('workShift', data['uid'], data);

    if(msg['success'] == true){
      await fetchWorkShift();
    }

    return msg;
  }

  Future updateWorkShift(uid, Map<String, dynamic> data) async {
    var msg = await service.updateDocument("workShift", uid, data);

    if (msg['success'] == true) {
      await fetchWorkShift();
    }

    return msg;
  }

  Future fetchWorkerSkills() async {

    var msg = await service.fetchDocuments("skills");

    if (skillsList.isNotEmpty) {
      skillsList.clear();

      msg.docs.forEach((doc) {
        WorkerSkills u = WorkerSkills.fromSnapshot(doc);
        skillsList.add(u);
        notifyListeners();
      });
    } else {
      msg.docs.forEach((doc) {
        WorkerSkills u = WorkerSkills.fromSnapshot(doc);
        skillsList.add(u);
        notifyListeners();
      });
    }
  }

  Future addWorkSkill(data) async {

    var msg = await service.postDocumentWithId('skills', data['uid'], data);

    if(msg['success'] == true){
      await fetchWorkerSkills();
    }

    return msg;
  }

  Future updateWorkerSkill(uid, Map<String, dynamic> data) async {
    var msg = await service.updateDocument("skills", uid, data);

    if (msg['success'] == true) {
      await fetchWorkerSkills();
    }

    return msg;
  }

  Future fetchWorkShift() async {

    var msg = await service.fetchDocuments("workShift");

    if (workerShiftList.isNotEmpty) {
      workerShiftList.clear();

      msg.docs.forEach((doc) {
        WorkShiftModel u = WorkShiftModel.fromSnapshot(doc);
        workerShiftList.add(u);
        notifyListeners();
      });
    } else {
      msg.docs.forEach((doc) {
        WorkShiftModel u = WorkShiftModel.fromSnapshot(doc);
        workerShiftList.add(u);
        notifyListeners();
      });
    }
  }

  Future postNotifications(data) async {

    var msg = await service.postDocumentWithId('notifications', data['uid'], data);

    if(msg['success'] == true){
      await fetchNotifications();
    }

    return msg;
  }

  Future fetchNotifications() async {

    var msg = await service.fetchDocuments("notifications");

    if (notificationsList.isNotEmpty) {
      notificationsList.clear();

      msg.docs.forEach((doc) {
        NotificationModel u = NotificationModel.fromSnapshot(doc);
        notificationsList.add(u);
        notifyListeners();
      });
    } else {
      msg.docs.forEach((doc) {
        NotificationModel u = NotificationModel.fromSnapshot(doc);
        notificationsList.add(u);
        notifyListeners();
      });
    }
  }

  Future<String> postStorage(dir,data) async {
    var msg = await service.postStorage(dir, data);
    return msg;
  }
}