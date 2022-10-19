import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/common/repositories/common_firebase_storage_repository.dart';
import 'package:lookup/common/utils/utils.dart';
import 'package:lookup/features/auth/screens/otp_screen.dart';
import 'package:lookup/models/user_model.dart';
import 'package:lookup/screen/mobile_screen_layout.dart';

import '../screens/user_infomation_screen.dart';

// Make sure that provide instance of AuthRepository to the controller bcz repository didn't directly 
// connected with the UI. So, we can take suppoert of controller.


// Provider ref is allows us to interact with other provider.
/// EX. we have two provider authRepositoryProvider and authControllerProvide and if we want to 
/// authControllerProvide access the authRepositoryProvider then we need to pass the ref.
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance, 
    firestore: FirebaseFirestore.instance,
  ),
); //Add this line globally

class AuthRepository{
  // Get instances of firebaseauth and firestore
  // Exepting constructor we create var here bcz it will make unit test quite easier.
  // This will help in dependncy injection.

  // final auth1 = FirebaseAuth.instance; //This is not follow the DI.
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository(
    {required this.auth, 
    required this.firestore 
  });

  Future<UserModel?> getCurrentUserData() async{
    // Here we don't use the ! we use ? bcz if user has null then don't go ahead otherwise go ahead.
    var userData = await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if(userData.data() != null){
      user = UserModel.fromMap(userData.data()!);
    }

    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async{
    // Nedd try catch bcz want to send some http calls which is in the back of the firebase thing.
    try{
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber, 
        // verifyPhoneNumber take phoneNumber as a input and then send the OTP.
        // After OTP matches with OTP which user enters we are going to send signInWithCredential
        // that means we can login successfully.
        verificationCompleted: (PhoneAuthCredential credential) async{
          await auth.signInWithCredential(credential);
        }, 
        verificationFailed: (e) {
          throw Exception(e.message);
        }, 
        // verificationId = OTP which firebase created.
        codeSent: ((String verificationId, int? resendToken) async{
          // Whenever firebase send otp then we need to go to otp screeen.
          Navigator.pushNamed(context, OTPScreen.routeName, arguments: verificationId);
        }), 
        // Auto resolution have timed out.
        codeAutoRetrievalTimeout: (String verificationId) {}
      );
    }on FirebaseAuthException catch(e){
      showSnackBar(context: context, content: e.message!);
    } 
    // catch(e){
    //   showSnackBar(context: context, content: e.toString());
    // } OR
    
  }

  void verifyOTP(
    {
      required BuildContext context, //To show an error
      required String verificationId,
      required String userOTP,
    }
  ) async{
    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamed(
        context, 
        UserInformationScreen.routeName, 
        arguments: (route) => false
      );
    }on FirebaseException catch(e){
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic, //This file we upload in firebase storage and it will give us a download url. Taking Url make sure that store file in firestore.
    required ProviderRef ref,
    required BuildContext context,
  }) async{
    try{
      String uid = auth.currentUser!.uid;
      String photoUrl = 'https://www.bing.com/images/search?view=detailV2&ccid=xo%2bBCC1Z&id=24BEB579E2AAF2953A153436B3A51E9163479D69&thid=OIP.xo-BCC1ZKFpLL65D93eHcgHaGe&mediaurl=https%3a%2f%2fwww.pngall.com%2fwp-content%2fuploads%2f5%2fUser-Profile-PNG-Clipart.png&exph=752&expw=860&q=user+profile+image&simid=608000802200694891&FORM=IRPRST&ck=2CD88C6D5CF81253B4FD6530E98A05CB&selectedIndex=8&ajaxhist=0&ajaxserp=0';

      if(profilePic!=null){
        /// To store profilePic in photoUrl we need to work with firebase storage.
        /// We want to store so many files in firebase. so, we will create new class in common folder.
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid', 
              profilePic
            );
      }

      /// We will need model class here which is basically structure for our user model.
      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl, 
        isOnline: true, 
        phoneNumber: auth.currentUser!.phoneNumber!, 
        groupId: []
      );

      //Push into firestore
      await firestore.collection('users').doc(uid).set(user.toMap());

      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => const MobileScreenLayout()), 
        (route) => false,
      );
    }catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId){
    return firestore.collection('users').doc(userId).snapshots().map(
      (event) => UserModel.fromMap(
        event.data()!
      ),
    ); // Here, we can use the short hand property for converting to USrModel
  }

  void setUserState(bool isOnline) async{
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}