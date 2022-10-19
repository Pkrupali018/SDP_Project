import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/colors.dart';
import 'package:lookup/features/auth/controller/auth_controller.dart';
import 'package:lookup/features/landing/screens/landing_screen.dart';
import 'package:lookup/features/select_contact/screens/select_contact_screen.dart';
import 'package:lookup/features/chat/widgets/contacts_list.dart';


class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

// didChangeAppLifecycleState funcion is not work with Stf widget so we can uase with WidgetBindingObserver
class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout> with WidgetsBindingObserver{
  String? uid;
  // Any thing which is observed is need to initialize in initState.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // This method is useful to know where are our app state like Pause, resume, inactive etc.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        ref.read(authConrollerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authConrollerProvider).setUserState(false);
        break;
      
      

    }
  }

  void logout() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => LandingScreen()), 
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          // Elevation is used for shadow.
          elevation: 0,
          title: const Text(
            "LookUp",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search, color:  Colors.grey)),
            IconButton(onPressed: logout, icon: const Icon(Icons.logout, color:  Colors.grey))
          ],
          bottom: const TabBar(
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
            tabs: [
            Tab(text: "Chats"),
            Tab(text: "Status"),
            Tab(text: "Calls"),
          ],),
        ),
        body: const ContactsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, SelectContactScreen.routeName);
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}