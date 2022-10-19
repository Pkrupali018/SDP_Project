import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lookup/common/widgets/loader.dart';
import 'package:lookup/features/chat/controller/chat_controller.dart';
import 'package:lookup/models/chat_contact.dart';
// import 'package:whatsappclone/colors.dart';

import '../../../info.dart';
import '../screens/mobile_chat_screen.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          // ???
          Expanded(
            //Here we use StreamBuilder instead of ListView.builder bcz we want to chane lastmsg at any time so stram transfer is requried.
            child: StreamBuilder<List<ChatContact>>(
              stream: ref.watch(chatControllerProvider).chatContacts(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                    return const Loader();
                }
                print(snapshot.data?.length);

                return ListView.builder(
                  //Does not give errors in future.
                  shrinkWrap: true,
                  // itemCount: info.length,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    var chatContactData = snapshot.data![index];
                    // InkWelll make a clickable onTap
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              MobileChatScreen.routeName,
                              arguments: {
                                'name': chatContactData.name,
                                'uid': chatContactData.contactId,
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                // info[index]['name'].toString(),
                                  chatContactData.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  // info[index]['message'].toString(),
                                  chatContactData.lastmessage,
                                  style: const TextStyle(
                                    fontSize: 15
                                  ),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  // info[index]['profilePic'].toString(),
                                  chatContactData.profilePicture,
                                ),
                              ),
                              //Trailing is used to put any thing in the last means right side of the List
                              trailing: Text(
                                // info[index]['time'].toString(),
                                  DateFormat.Hm().format(chatContactData.timeSent),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            ),
          ),
          const Divider(
            color: Colors.white,
            // It's not very perment. 
            //indent: 85,
          ),
        ],
      ),
    );
  }
}