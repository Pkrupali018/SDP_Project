import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/features/auth/repository/auth_repository.dart';
import 'package:lookup/models/user_model.dart';

final authConrollerProvider = Provider((ref){
  final authRepository = ref.watch(authRepositoryProvider);
  // watch = Provider.of<AuthRepository>(context);
  return AuthConroller(authRepository: authRepository, ref: ref);
});


// Future Provider
final userDataAuthProvider = FutureProvider((ref){
  final authController = ref.watch(authConrollerProvider);
  return authController.getUserData();
});

class AuthConroller{
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthConroller({
    required this.authRepository,
    required this.ref,
  });
  
  // We need futureprovider to access this not a authcontrollerprovider so we can make this function as a Future.
  Future<UserModel?> getUserData() async{
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber){
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP){
    authRepository.verifyOTP(
      context: context, 
      verificationId: verificationId, 
      userOTP: userOTP
    );
  }

  void saveUserDataToFirebase(BuildContext context, String name, File? profilePic){
    authRepository.saveUserDataToFirebase(
      name: name, 
      profilePic: profilePic, 
      ref: ref, 
      context: context
    );
  }

  Stream<UserModel> userDataById(String userId){
    return authRepository.userData(userId);
  }
  
}