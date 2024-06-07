import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttermyappp/res/components/waiting_screen.dart';
import 'package:fluttermyappp/conts/conts.dart';
import 'package:fluttermyappp/firebase_options.dart';
import 'package:dcdg/dcdg.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build (BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily:AppFonts.nunito),
      debugShowCheckedModeBanner: false,
      home:  const WaitingScreen(),
    );
  }
}