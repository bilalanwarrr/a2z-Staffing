import 'package:cloud_firestore/cloud_firestore.dart';

import '../const.dart';

class FirebaseService {

  Future signIn(name, password) async {
    var doc;

    await fireStore.collection('workers').get().then((value) {
      value.docs.forEach((d) {
        if(d.get('userName').toString().trim() == name.toString().trim() && d.get('password').toString().trim() == password.toString().trim()){
          doc = d;
        }
      });
    });

    return doc;
  }

  Future<DocumentSnapshot> fetchLoginUser(uid) async {
    return await fireStore.collection('workers').doc(uid).get();
  }

  Future checkUser(uid) async {
    var msg = {};
    await fireStore.collection('users').doc(uid).get().then((value) {
      if (value.exists == true) {
        msg.addAll({'success': true});
      } else {
        msg.addAll({'success': false});
      }
    }).catchError((e) {
      msg.addAll({'success': false});
    });

    return msg;
  }

  Future postDocumentWithId(collection, uid, data) async {
    var msg = {};

    await fireStore.collection(collection).doc(uid).set(data).then((value) {
      msg.addAll({'success': true});
    }).catchError((e) {
      msg.addAll({'success': false});
    });

    return msg;
  }

  Future postDocument(collection, data) async {
    var msg = {};
    await fireStore.collection(collection).doc().set(data).then((value) {
      msg.addAll({'success': true});
    }).catchError((e) {
      msg.addAll({'success': false});
    });

    return msg;
  }

  Future deleteDocument(collection, uid) async {
    var msg = {};
    await fireStore.collection(collection).doc(uid).delete().then((value) {
      msg.addAll({'success': true});
    }).catchError((e) {
      msg.addAll({'success': false});
    });

    return msg;
  }

  Future<DocumentSnapshot> fetchDocumentById(collection, uid) async {
    return await fireStore.collection(collection).doc(uid).get();
  }

  Future<DocumentSnapshot> fetchDocument(collection) async {
    return await fireStore.collection(collection).doc().get();
  }

  Future<QuerySnapshot> fetchDocuments(collection) async {
    return await fireStore.collection(collection).get();
  }

  Future updateDocument(collection, uid, Map<String, dynamic> data) async {
    var msg = {};

    await fireStore.collection(collection).doc(uid).update(data).then((value) {
      msg.addAll({'success': true});
    }).catchError((e) {
      msg.addAll({'success': false});
    });

    return msg;
  }

  Future updateDocumentById(collection, uid, data) async {
    var msg = {};

    await fireStore
        .collection(collection)
        .where('uid', isEqualTo: uid)
        .get()
        .then((value) async {
      await fireStore
          .collection(collection)
          .doc(value.docs.first.id)
          .update(data)
          .then((value) {
        msg.addAll({'success': true});
      }).catchError((e) {
        msg.addAll({'success': false});
      });
    }).catchError((e) {
      msg.addAll({'success': false});
    });

    return msg;
  }

  Future<String> postStorage(dir, data) async {
    var msg;
    var ref = storage.ref().child("/${dir}/${data['id']}/${data['fileName']}");

    await ref.putFile(data['file']);
    msg = await ref.getDownloadURL();
    return msg;
  }
}
