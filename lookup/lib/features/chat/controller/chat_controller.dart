import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/features/auth/controller/auth_controller.dart';
import 'package:lookup/features/chat/repository/chat_repository.dart';
import 'package:lookup/models/chat_contact.dart';
import 'package:lookup/models/message_model.dart';

final chatControllerProvider = Provider(
  (ref) {
    
    final chatRepository = ref.watch(chatRepositoryProvider);

    return ChatController(
      chatRepository: chatRepository, 
      ref: ref,
    );
  }
);

class ChatController{
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });
  
  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<MessageModel>> chatStream(String reciverUserId) {
    return chatRepository.getChatStream(reciverUserId);
  }
  void sendTextMessage(
    BuildContext context,
    String text,
    String reciverUserId,
  ){
    // We can't use senderUser as parameter bcz for get this we need to work with logic (We can convert to model UserModel)
    ref.read(userDataAuthProvider).whenData(
      (value) => chatRepository.sendTextMessage(
        context: context, 
        text: text, 
        reciverUserId: reciverUserId, 
        senderUser: value!
      ),
    );
  }
}