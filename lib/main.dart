import 'package:chat_app_with_firebase/provider/auth.dart';
import 'package:chat_app_with_firebase/provider/chat.dart';
import 'package:chat_app_with_firebase/provider/user.dart';
import 'package:chat_app_with_firebase/views/auth/login_screen.dart';
import 'package:chat_app_with_firebase/views/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

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
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthNotifier()),
        ChangeNotifierProvider(create: (context) => UserNotifier()),
        ChangeNotifierProvider(create: (context) => ChatNotifier()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        home: SplashScreen(),
      ),
    );
  }
}
