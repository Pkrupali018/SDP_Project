// import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:lookup/features/auth/screens/login_screen.dart';
import 'package:lookup/features/chat/screens/mobile_chat_screen.dart';

import 'common/error.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/auth/screens/user_infomation_screen.dart';
import 'features/select_contact/screens/select_contact_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings){
  switch(routeSettings.name){
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case OTPScreen.routeName:
    final verificationId = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        )
      );

    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context) => const UserInformationScreen());

    case SelectContactScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SelectContactScreen());

    case MobileChatScreen.routeName:
    // Extracting a map
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(builder: (context) => MobileChatScreen(name: name, uid: uid,));
    default: 
      return MaterialPageRoute(builder: (context) => const Scaffold(
        body: ErrorScreen(error: "404 This page doesn't exist.",),
      ),);
  }
}