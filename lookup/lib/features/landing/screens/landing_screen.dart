// In this file we have build scaffold part of our landing page

import 'package:flutter/material.dart';
// import 'package:lookup/colors.dart';
import 'package:lookup/common/widgets/custom_button.dart';
import 'package:lookup/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void navigateToLoginScreen(BuildContext context){
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // We can put safearea to overcome the overriding of the notch in Mobile phone. nothc maens above part which contains the camera and all things.
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              "Welcome to LookUp",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600
              ),
              ),

              SizedBox(height: size.height/9,),

              Image.asset('assets/app_logo.png', height: 340, width: 340,),

              SizedBox(height: size.height / 9),

              const Padding(
                padding:  EdgeInsets.all(15.0),
                child:  Text(
                  'Read our Privacy Policy. tap "Agree and continue to accept the Terms of Services."',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: size.width*0.75,
                child: CustomButton(text: 'AGREE & CONTINUE', onPressed: () => navigateToLoginScreen(context),)
                ),
          ]
          ),
      ),
    );
  }
}