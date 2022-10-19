import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/colors.dart';
import 'package:lookup/features/chat/controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String reciverUserId;
  const BottomChatField({
    Key? key, required this.reciverUserId,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async{
    if(isShowSendButton){
      ref.read(chatControllerProvider).sendTextMessage(context, _messageController.text.trim(), widget.reciverUserId,);
    setState(() {
      _messageController.text = '';
    });
    }
  }

  @override
  void dispose(){
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Expanded make sure that textfield gets maximum available space.
        /// If we son't write expanded then Texfield is availbale in whole screeen thats why show the error.
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (value){
              if(value.isNotEmpty){
                setState(() {
                  isShowSendButton = true;
                });
              }else{
                setState(() {
                  isShowSendButton = false;
                });
              }
            },
            decoration: InputDecoration(
            //Filled by color
            filled: true,
            // Chnage the color of textbox
            fillColor: mobileChatBoxColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            // Put the left sides icon button
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.emoji_emotions, color: Colors.white,)
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.gif, color: Colors.white,)
                    ),
                  ],
                ),
              ),
            ),
            //To put the right sides icon button, but this is done by mainAxisAlignment property.
            suffixIcon: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt, color: Colors.white,)
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file, color: Colors.white,)
                    ),
                ]
              ),
            ),
            //???
            hintText: 'Type a message',
           ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
            right: 5,
            left: 5,
          ),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF128C7E),
            radius: 25,
            //We  use GestureDetector bcz here we have multiple options like ontap, onlongtap etc.
            child: GestureDetector(
              child: Icon(
                isShowSendButton ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
              onTap: sendTextMessage,
            ),
          ),
        ),
      ],
    );
  }
}