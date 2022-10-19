import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/colors.dart';
import 'package:lookup/common/utils/utils.dart';
import 'package:lookup/common/widgets/custom_button.dart';
import 'package:lookup/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry(){
    showCountryPicker(
      context: context, 
      onSelect: (Country countryy) {
        //Here, we need setState bcz we set our global variable country to _country.
        //Now, to show the country code bcz it is no longer null we want to tell our build function to run again.
        setState(() {
          country = countryy;
        });
      });
  }

  void sendPhoneNumber(){
    String phoneNumber = phoneController.text.trim();
    if(country!= null && phoneNumber.isNotEmpty){
      ref.read(authConrollerProvider).signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
      // read() = Provider.of(context, listen: false)  OR context.read()
      // Provider Ref -> Interact Provider with provider
      // WidgetRef -> makes widget interact with provider
    }else{
      showSnackBar(context: context, content: 'Fill out all the things');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "LookUp will nedd to verify your phone no."
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: pickCountry, 
                child: const Text('Pick Country')
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if(country != null)
                    // We use $ for intrpolation
                    Text('+${country!.phoneCode}'),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width*0.75,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'phone number',
                      ),
                    )),
                ],
              ),
              SizedBox(height: size.height*0.6,),
      
              SizedBox(
                width: 90,
                child: CustomButton(
                  onPressed: sendPhoneNumber,
                  text: 'Next',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}