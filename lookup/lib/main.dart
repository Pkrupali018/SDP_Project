
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lookup/colors.dart';
import 'package:lookup/common/error.dart';
import 'package:lookup/features/auth/controller/auth_controller.dart';
import 'package:lookup/firebase_options.dart';
// import 'package:lookup/responsive/responsive_layout.dart';
import 'package:lookup/router.dart';
import 'package:lookup/screen/mobile_screen_layout.dart';
// import 'package:lookup/screen/mobile_screen_layout.dart';
// import 'package:lookup/screen/web_screen_layout.dart';

import 'common/widgets/loader.dart';
import 'features/landing/screens/landing_screen.dart';


void main() async{
  // Make sure that flutter engin has been initialized.
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ProviderScope widget is provided by riverpod that keeps track or consist of the state of the App.
  runApp(
    const ProviderScope(
      child: MyApp(),
    ));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      // Don't show the debug at top right corner in debuger.
      debugShowCheckedModeBanner: false,
      title: 'LookUp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        )
      ),
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(), 
      //   webScreenLayout: WebScreenLayout()),

      // Here, we will create the named route.
      onGenerateRoute: (settings) => generateRoute(settings),
      /// It is future provider so we get the when in normal provider we don't have the when
      /// Whenever we get the data then when is called.
      home: ref.watch(userDataAuthProvider).when(
        data: (user) {
          if(user == null){
            return const LandingScreen();
          }
          return const MobileScreenLayout();
        }, 
        error: (err, trace){
          return ErrorScreen(error: err.toString());
        },
        loading: () => const Loader()
      ),

    );

  }
}
