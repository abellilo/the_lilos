import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewallsocials/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //firebase firestore instance
  final firebasefirestore = FirebaseFirestore.instance;

  //edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(context: context, builder: (cxt){
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("Edit "+field, style: const TextStyle(
          color: Colors.white
        ),),
        content: TextField(
          autofocus: true,
          style: TextStyle(
            color: Colors.white
          ),
          decoration: InputDecoration(
            hintText: "Enter new "+field,
            hintStyle: TextStyle(
              color: Colors.grey
            )
          ),
          onChanged: (value){
            newValue = value;
          },
        ),
        actions: [
          //save button
          TextButton(onPressed: ()=> Navigator.of(context).pop(newValue), child: Text("Save", style: TextStyle(
            color: Colors.white
          ),)),

          //cancel button
          TextButton(onPressed: ()=> Navigator.pop(context), child: Text("Cancel", style: TextStyle(
            color: Colors.white
          ),)),
        ],
      );
    });

    //update firestore
    if(newValue.trim().length > 0){
      firebasefirestore.collection("users").doc(currentUser.email!).update({
        field : newValue
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),

          //profile pic
          Icon(
            Icons.person,
            size: 72,
          ),

          const SizedBox(
            height: 10,
          ),

          //current user
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),

          const SizedBox(
            height: 50,
          ),

          //user details
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "Details",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),

          StreamBuilder(
              stream: firebasefirestore.collection("users").doc(currentUser.email!).snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      //username
                      MyTextBox(
                        text: data['username'],
                        sectionName: "username",
                        onPressed: () => editField('username'),
                      ),

                      //bio
                      MyTextBox(
                        text: data['bio'],
                        sectionName: "bio",
                        onPressed: () => editField('bio'),
                      ),
                    ],
                  );
                }
                else if(snapshot.hasError){
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }
                else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),

          const SizedBox(height: 50,),

          //user post
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "My Posts",
              style: TextStyle(color: Colors.grey[600]),
            ),
          )
        ],
      ),
    );
  }
}
