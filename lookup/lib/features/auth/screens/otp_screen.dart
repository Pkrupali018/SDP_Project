import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/colors.dart';
import 'package:lookup/common/utils/utils.dart';
import 'package:lookup/features/auth/controller/auth_controller.dart';

// It is statefull bcz we have textediting controller here.
class OTPScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  // This verificationId is Id which is send by the firebase to our applictaion.
  final String verificationId;
  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);


  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP){
    ref.read(authConrollerProvider).verifyOTP(
      context, 
      verificationId, 
      userOTP
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verifying your number"
        ),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            const Text(
              "We have sent an SMS with a code."
            ),
            SizedBox(
              width: size.width*0.50,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '_ _ _ _ _ _',
                  hintStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (value){
                  if(value.length == 6){
                    verifyOTP(ref, context, value.trim());
                  }else{
                    showSnackBar(context: context, content: 'OTP must be 6 digit.');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}


// phoneNumber verification done from the auth_repository.dart there otp was send we enter this otp in this
// pase and otp which is we entered and otp send by firebase mathches or not is main logic.