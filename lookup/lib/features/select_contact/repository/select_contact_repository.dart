import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/common/utils/utils.dart';
import 'package:lookup/models/user_model.dart';
import 'package:lookup/features/chat/screens/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance
  ),
);

class SelectContactRepository{
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore
  });

  Future<List<Contact>> getContacts() async{
    List<Contact> contacts = [];
    try{
      if(await FlutterContacts.requestPermission()){
        /// withProperties gives a number proprty thats needed in our contactlist
        /// If we don't give withProperties then it wan't give us the number and it will just print out an empty string or null value.
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    }catch (e){
      // Here the chances of error is very less so we can use debugPrint.
      debugPrint(e.toString());
    }
    return contacts;
  }

  // Selected contact means if we click in name then select the contact number of this name
  void selectContact(Contact selectedContect, BuildContext context) async{
    try{
      var userCollection = await firestore.collection('users').get(); //This will get all the users
      bool isFound = false;

      for(var document in userCollection.docs){
        // Convert documnet in UserModel formate
        var userData = UserModel.fromMap(document.data());
        // Here if we write olny phones then user have multiple numbers like work, home etc. so we select the 1st one
        String selectedPhoneNumber = selectedContect.phones[0].number.replaceAll(' ', '');
        // print(selectedPhoneNumber);
        if(selectedPhoneNumber == userData.phoneNumber){
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.routeName, 
          // Sending a map
          arguments: {
            'name': userData.name,
            'uid': userData.uid,
          });
        }
      }

      if(!isFound){
        showSnackBar(context: context, content: 'This number does not exist in this app.');
      }
    }catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }
}