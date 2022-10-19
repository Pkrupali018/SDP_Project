import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lookup/common/widgets/loader.dart';
import 'package:lookup/features/chat/controller/chat_controller.dart';
import 'package:lookup/info.dart';
import 'package:lookup/models/message_model.dart';
import 'package:lookup/widgets/sendar_message_card.dart';

import '../../../widgets/my_message_card.dart';

class ChatList extends ConsumerWidget {
  final String reciverUserId;
  const ChatList({Key? key, required this.reciverUserId,}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<MessageModel>>(
      stream: ref.read(chatControllerProvider).chatStream(reciverUserId),
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Loader();
        }
        return ListView.builder(
          // itemCount: messages.length,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index){
            final messageData = snapshot.data![index];
            // var timeSent = DateFormat.Hm().format(messageData.timeSent);

            // if(messages[index]['isMe'] == true){
              if(messageData.senderId == FirebaseAuth.instance.currentUser!.uid){
              // My message card
              return MyMessageCard(
                // message: messages[index]['text'].toString(),
                message: messageData.text,
                // date: messages[index]['date'].toString(),
                date: messageData.timeSent.timeZoneName,
              );
            }

            // Sender message card
            return SenderMessageCard(
                // message: messages[index]['text'].toString(),
                message: messageData.text,
                // date: messages[index]['date'].toString(),
                date: messageData.timeSent.timeZoneName,
              );

          },
        );
      }
    );
  }
}