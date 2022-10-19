import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/common/error.dart';
import 'package:lookup/common/widgets/loader.dart';
import 'package:lookup/features/select_contact/controller/select_contact_controller.dart';
// import 'package:lookup/widgets/contacts_list.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactScreen({Key? key}) : super(key: key);

  void selectContact(WidgetRef ref, Contact selectedContect, BuildContext context){
    ref.read(selectContactControllerProvider).selectContact(selectedContect, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Contact',
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {}, 
            icon: const Icon(
              Icons.more_vert,
            ),
          )
        ],
      ),
      body: ref.watch(getContactProvider).when(
        data: (contactsList) =>
          ListView.builder(
            itemCount: contactsList.length,
            itemBuilder: (context, index){
              final contact = contactsList[index];
              return InkWell(
                onTap: () => selectContact(ref, contact, context),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                      ),  
                    ),
                    leading: contact.photo == null ? null : CircleAvatar(
                      backgroundImage: MemoryImage(contact.photo!),
                      radius: 30,
                    ),
                  ),
                ),
              );
          }),
        error: (err, trace) =>
          ErrorScreen(error: err.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}