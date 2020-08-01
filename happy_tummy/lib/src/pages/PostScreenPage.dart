import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';
import 'package:happy_tummy/src/widgets/PostWidget.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class PostScreenPage extends StatelessWidget {
  final String postId;
  final String userId;

  PostScreenPage({
    this.postId,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsReference.document(userId).collection("userPosts").document(postId).get(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }

        Post post = Post.fromDocument(dataSnapshot.data);

        return Center(
          child: Scaffold(
            appBar: header(context,strTitle: post.description),
            body: ListView(
              children: <Widget>[
                Container(
                  child: post//post,
                ),
                Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

}
