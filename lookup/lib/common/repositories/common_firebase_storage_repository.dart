import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRepositoryProvider = Provider(
  (ref) => CommonFirebaseStorageRepository(
    firebaseStorage: FirebaseStorage.instance,
    ),
);

class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;

  CommonFirebaseStorageRepository({
    required this.firebaseStorage,
  });

  /// Here String ref is pass bcz for differnt task ref is differnt.
  /// Ex. User info screen: child = /user/uid
  /// but in Some lookup Chat we can't save like this bcz it is not appropriate in the folder patter.
  /// here we need differnt ref like sender id, reciver id etc.
  Future<String> storeFileToFirebase(String ref, File file) async{
    /// Basically we can communicate with firebase console storage part and then child have some path on which
    /// the data will stored.
    /// If path = /user/uid then in folder user-> uid-> store data.
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}