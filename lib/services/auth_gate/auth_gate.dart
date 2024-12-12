import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewallsocials/screens/homepage.dart';
import 'package:thewallsocials/screens/login_or_register_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;

    return StreamBuilder(
        stream: firebaseAuth.authStateChanges(),
        builder: (context, snapshots){
          if(snapshots.hasError){
            return CircularProgressIndicator();
          }

          if(snapshots.hasData){
            return HomePage();
          }
          else{
            return LoginOrRegister();
          }
        }
    );
  }
}
