import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thewallsocials/components/comment.dart';
import 'package:thewallsocials/components/comment_button.dart';
import 'package:thewallsocials/components/delete_button.dart';
import 'package:thewallsocials/components/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  WallPost(
      {super.key,
      required this.message,
      required this.user,
      required this.time,
      required this.likes,
      required this.postId});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final firebasefirestore = FirebaseFirestore.instance;
  bool isLiked = false;

  final commentTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection("user Posts").doc(widget.postId);

    if (isLiked) {
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  //add comment
  Future<void> addComment(String commentText) async {
    await firebasefirestore
        .collection("user Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });

    Navigator.pop(context);

    commentTextController.clear();
  }

  Future<void> deletePost() async {
    //show dialogue before deleting
    showDialog(
        context: context,
        builder: (cxt) {
          return AlertDialog(
            title: const Text("Delete Post"),
            content: const Text("Are you sure you want to delete this post?"),
            actions: [
              //delete button
              TextButton(
                  onPressed: () async {
                    //delete the comments first
                    final commentDoc = await firebasefirestore
                        .collection("user Posts")
                        .doc(widget.postId)
                        .collection("Comments")
                        .get();

                    for (var doc in commentDoc.docs) {
                      await firebasefirestore
                          .collection("user Posts")
                          .doc(widget.postId)
                          .collection("Comments")
                          .doc(doc.id)
                          .delete();
                    }

                    //then delete the post
                     await firebasefirestore
                        .collection("user Posts")
                        .doc(widget.postId)
                        .delete()
                        .then((value) => print("post deleted"))
                        .catchError((error) => print("Failed to delete ${error}"));

                    //dismiss dialogue box
                    Navigator.pop(cxt);
                  },
                  child: Text("Delete")),

              //cancel button
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"))
            ],
          );
        });
  }

  //show dialogue post
  void showCommentDialogue() {
    showDialog(
        context: context,
        builder: (cxt) {
          return AlertDialog(
            title: Text("Add Comment"),
            content: TextField(
              controller: commentTextController,
              decoration: InputDecoration(hintText: "write a comment..."),
            ),
            actions: [
              //save button
              TextButton(
                  onPressed: () => addComment(commentTextController.text),
                  child: Text("Post")),

              //cancel button
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                    commentTextController.clear();
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //group of text (message + email)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.message),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.user + " + " + widget.time,
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ),

              //delete button
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost)
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //liked button
              Column(
                children: [
                  //liked button
                  LikeButton(onTap: toggleLike, isLiked: isLiked),

                  const SizedBox(
                    height: 5,
                  ),

                  //liked count
                  Text(
                    "${widget.likes.length}",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),

              const SizedBox(
                width: 10,
              ),

              //Comment button
              Column(
                children: [
                  //comment button
                  CommentButton(onTap: showCommentDialogue),

                  const SizedBox(
                    height: 5,
                  ),

                  //liked count
                  Text(
                    "${widget.likes.length}",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          //show comments
          StreamBuilder(
              stream: firebasefirestore
                  .collection("user Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .orderBy("CommentTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      return MyComment(
                          user: doc['CommentBy'],
                          text: doc['CommentText'],
                          time: formatData(doc['CommentTime']));
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error ${snapshot.error}"),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }
}
