import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thewallsocials/components/drawer.dart';
import 'package:thewallsocials/components/mytextfield.dart';
import 'package:thewallsocials/components/wall_post.dart';
import 'package:thewallsocials/helper/helper_methods.dart';
import 'package:thewallsocials/screens/profile_page.dart';
import 'package:thewallsocials/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void signOut() async {
    await Provider.of<AuthService>(context, listen: false).signOut();
  }

  Future<void> postMessage() async {
    if(textController.text.isNotEmpty){
      //store in firebase
      await FirebaseFirestore.instance.collection("user Posts").add({
        "UserEmail" : currentUser.email!,
        "Message" : textController.text,
        "Timestamp" : Timestamp.now(),
        "Likes": [],
      });

      setState(() {
        textController.clear();
      });
    }
  }

  void goToProfilePage(){
    //pop drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(context, MaterialPageRoute(builder: (cnotext)=> ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("The Lilos"),
          actions: [
            IconButton(onPressed: signOut, icon: Icon(Icons.logout))
          ],
          backgroundColor: Colors.grey[900],
          elevation: 0,
        ),
        drawer: MyDrawer(
          onSignOut: signOut,
          onProfileTap: goToProfilePage,
        ),
        body: Column(
          children: [
            //The wall
            Flexible(child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("user Posts").orderBy(
                  "Timestamp", descending: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final posts = snapshot.data!.docs;

                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];

                        return WallPost(
                            message: post["Message"],
                            user: post["UserEmail"],
                            time: formatData(post["Timestamp"]),
                            postId: post.id,
                            likes: List<String>.from(post['Likes'] ?? []),
                        );
                      }
                  );
                }
                else if(snapshot.hasError){
                  return Center(
                    child: Text("Error:- ${snapshot.error}"),
                  );
                }
                else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )),

            //Post messages
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(child: MyTextField(
                    hintText: "Write something on the wall...",
                    obscureText: false,
                    controller: textController,
                  )),
                  IconButton(
                      onPressed: postMessage, icon: Icon(Icons.arrow_circle_up))
                ],
              ),
            ),

            //logged in as
            Text("Logged in as " + currentUser.email!)
          ],
        ),
      ),
    );
  }
}
