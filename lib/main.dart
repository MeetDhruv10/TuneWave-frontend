import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tunewave/LSO/LoginPage.dart';
import 'package:tunewave/LSO/Signup.dart';
import 'package:tunewave/Views/Home.dart';
import 'Components/Playlist_Provider.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Playlist_Provider()), // Provide the Playlist_Provider
      ],
      child: MaterialApp(
        home: AnimatedSplashScreen(
          splash: Image(
            image: AssetImage('assets/images/logoyashwi.png'),
          ),
          nextScreen: LoginPage(), // Change this to LoginPage if you want to start with a login screen
          duration: 2000,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: Colors.black,
        ),
        title: 'TuneWave',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
