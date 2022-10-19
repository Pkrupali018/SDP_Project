import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/common/enums/message_enum.dart';
import 'package:lookup/common/utils/utils.dart';
import 'package:lookup/info.dart';
import 'package:lookup/models/chat_contact.dart';
import 'package:lookup/models/message_model.dart';
import 'package:lookup/models/user_model.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(((ref) =>
    ChatRepository(
      firebaseFirestore: FirebaseFirestore.instance, 
      auth: FirebaseAuth.instance
    )
));

class ChatRepository{
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firebaseFirestore, 
    required this.auth
  });

  
  Stream<List<ChatContact>> getChatContacts() {
    return firebaseFirestore.collection('users').doc(auth.currentUser!.uid).collection('chats').
    snapshots().asyncMap((event) async{
      List<ChatContact> contacts = [];
      for(var documnet in event.docs){
        var chatContact = ChatContact.fromMap(documnet.data());
        var userData = await firebaseFirestore.collection('users').doc(chatContact.contactId).get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(ChatContact(
          name: user.name, 
          profilePicture: user.profilePic, 
          contactId: chatContact.contactId, 
          timeSent: chatContact.timeSent, 
          lastmessage: chatContact.lastmessage,
        ));
      }
      return contacts;
    });
  }

  Stream<List<MessageModel>> getChatStream(String reciverUserId) {
    return firebaseFirestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(reciverUserId).collection('messages').orderBy('timeSent')
    .snapshots().map((event){
      List<MessageModel> messages = [];
      for(var document in event.docs){
        messages.add(MessageModel.fromMap(document.data()));
      }
      return messages;
    });
  }


  // Here we don't take try catch bcz it is alway going to implement in try catch block.
  void _saveDataToContactSubCollection(
    UserModel senderUserData,
    UserModel reciverUserData,
    String text,
    DateTime timeSent,
    String reciverUserId,
  ) async{
    // users -> reciverId document-> chats collection-> current user id document-> set data of the current contact chat
    // Create two chat contacts instances
    // 1) Reciver user id:
    var reciverChatContact = ChatContact(
      name: senderUserData.name, 
      profilePicture: senderUserData.profilePic, 
      contactId: senderUserData.uid, 
      timeSent: timeSent, 
      lastmessage: text,
    );

    await firebaseFirestore.collection('users').doc(reciverUserId).collection('chats').doc(auth.currentUser!.uid).set(reciverChatContact.toMap());
    // If we have only above request then last msg is shown at reciver side but not shown at sender side so we need to send reverse request
    // users -> current user id document-> chats collection-> reciverId document-> set data of the current contact chat
    // 2) Sender user id:
    var senderChatContact = ChatContact(
      name: reciverUserData.name, 
      profilePicture: reciverUserData.profilePic, 
      contactId: reciverUserData.uid, 
      timeSent: timeSent, 
      lastmessage: text,
    );

    await firebaseFirestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(reciverUserId).set(senderChatContact.toMap());

  }

  void _saveMessageToMessageSubCollection(
    String reciverUserId,
    String text,
    DateTime timeSent,
    String messageId,
    String senderUsername,
    String reciverUserName,
    MessageEnum messageType,
  ) async{
    // user -> senderId -> chats -> reciverId -> messages collection -> messageId -> store message
    final message = MessageModel(
      senderId: auth.currentUser!.uid, 
      reciverId: reciverUserId, 
      text: text, 
      type: messageType, 
      timeSent: timeSent, 
      messageId: messageId, 
      isSeen: false
    );
    await firebaseFirestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(reciverUserId).collection('messages').doc(messageId).set(message.toMap());

    // user -> reciverId -> chats -> senderId -> messages collection -> messageId -> store message
    
    await firebaseFirestore.collection('users').doc(reciverUserId).collection('chats').doc(auth.currentUser!.uid).collection('messages').doc(messageId).set(message.toMap());
  }

  // Here we use named parameters bcz we need so many parameters.
  // BuildContext to display errors.
  /// How we store chat collection:
  /// Formating user -> senderId -> reciverId -> messages collection -> messageId -> store message
  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String reciverUserId,
    required UserModel senderUser,
  }) async{
    try{
      var timeSent = DateTime.now();
      UserModel reciverUserData;

      var userDataMap = await firebaseFirestore.collection('users').doc(reciverUserId).get();
      reciverUserData = UserModel.fromMap(userDataMap.data()!);

      // Saving the data to two connections.
      /// one connection is contact chat subcollection. Means when we go to MobileScreenLayout then we need to display name of the user and last msg
      /// contact chat subcollection: users -> reciverId document-> chats collection-> current user id document-> set data of the current contact chat
      /// If we use only users -> reciverId -> set data then here we have only one collection so data is overwritten.
      /// data(Profile pic, name, lastmsg = text here etc.)
      
      /// second connection is messages subcollection. We need msg in real time so need this chatScreen
      /// user -> senderId -> reciverId -> messages collection -> messageId -> store message
      
      //Need to save the data to contact subcollection. -->above
      //We make this private so only can use within chatRepository class

      //Create unique msg id for this we can use uuid package
      var messageId = const Uuid().v1();  // Why put v1??
      _saveDataToContactSubCollection(
        senderUser,
        reciverUserData,
        text,
        timeSent,
        reciverUserId
      );

    _saveMessageToMessageSubCollection(
      reciverUserId,
      text,
      timeSent,
      messageId,
      senderUser.name,
      reciverUserData.name,
      MessageEnum.text,
    );
    }catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }
}