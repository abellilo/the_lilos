import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;
  final firebasefirestore = FirebaseFirestore.instance;

  //register user
  Future<UserCredential> registerUser(String email, String password) async {
    try {
      //create user
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      firebasefirestore.collection("users").doc(userCredential.user!.email).set({
        "username": email.split("@")[0],
        'bio' : 'Empty bio..'
      });
      return userCredential;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign in user
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    }
    on FirebaseException catch(e){
      throw Exception(e.code);
    }
  }


  //sign out
  Future<void> signOut()async{
    await firebaseAuth.signOut();
  }
}
