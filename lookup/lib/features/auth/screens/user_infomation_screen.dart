import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/common/utils/utils.dart';
import 'package:lookup/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const routeName = '/user-infromation';
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameContoller = TextEditingController();
  File? image;

  @override
  void dispose(){
    super.dispose();
    nameContoller.dispose();
  }

  void selectImage() async{
    image = await pickImageFromGallery(context);
    setState(() {
      
    });
  }

  void storeUserData() async{
    String name = nameContoller.text.trim();
    if(name.isNotEmpty){
      ref.read(authConrollerProvider).saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // Stack is used bcz we already have one default image and we need to select other image.
              Stack(
                children: [
                  image == null ? const CircleAvatar(
                    // backgroundImage: AssetImage('assets/dp.jpg'),
                    backgroundImage: NetworkImage('https://www.bing.com/images/search?view=detailV2&ccid=xo%2bBCC1Z&id=24BEB579E2AAF2953A153436B3A51E9163479D69&thid=OIP.xo-BCC1ZKFpLL65D93eHcgHaGe&mediaurl=https%3a%2f%2fwww.pngall.com%2fwp-content%2fuploads%2f5%2fUser-Profile-PNG-Clipart.png&exph=752&expw=860&q=user+profile+image&simid=608000802200694891&FORM=IRPRST&ck=2CD88C6D5CF81253B4FD6530E98A05CB&selectedIndex=8&ajaxhist=0&ajaxserp=0'),
                    radius: 64,
                  ): CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 64,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage, 
                      icon: const Icon(
                        Icons.add_a_photo
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width*0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameContoller,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: storeUserData, 
                    icon: const Icon(Icons.done)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}