import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/colors.dart';
import 'package:lookup/common/widgets/loader.dart';
import 'package:lookup/features/auth/controller/auth_controller.dart';
import 'package:lookup/features/chat/widgets/bottom_chat_field.dart';
import 'package:lookup/features/chat/widgets/chat_list.dart';

import '../../../models/user_model.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  const MobileChatScreen({Key? key, required this.name, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authConrollerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Loader();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    snapshot.data!.isOnline ? 'online' : 'offline',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
            );
          }
        ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
      ),
      body: Column(
        children: [
          // Chat List
          Expanded(
            child: ChatList(
              reciverUserId: uid,
            ),
          ),
          // Text input for message
          BottomChatField(
            reciverUserId: uid,
          ),
        ],
      ),
    );
  }
}

