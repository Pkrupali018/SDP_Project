// import 'package:flutter/material.dart';

class ChatContact{
  final String name;
  final String profilePicture;
  final String contactId;
  final DateTime timeSent;
  final String lastmessage;

  ChatContact({
    required this.name, 
    required this.profilePicture, 
    required this.contactId, 
    required this.timeSent, 
    required this.lastmessage
  });

  // Convert into Json Serialization
  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'profilePicture': profilePicture,
      'contactId': contactId,
      'timeSent': timeSent,
      'lastmessage': lastmessage,
    };
  }
  
  factory ChatContact.fromMap(Map<String, dynamic> map){
    return ChatContact(
      name: map['name'] ?? '', 
      profilePicture: map['profilePicture'] ?? '',
      contactId: map['contactId'] ?? '', 
      timeSent: map['timeSent'] ?? '', 
      lastmessage: map['lastmessage'] ?? '',
    );
  }

}