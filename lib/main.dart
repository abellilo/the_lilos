
import 'package:flutter/material.dart';
import 'package:thewallsocials/firebase_options.dart';
import 'package:thewallsocials/screens/login_or_register_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thewallsocials/services/auth_gate/auth_gate.dart';
import 'package:thewallsocials/services/auth_services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=> AuthService())
    ],
      child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthGate(),
    );
  }
}

