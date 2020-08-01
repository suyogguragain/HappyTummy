import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/PostScreenPage.dart';
import 'package:happy_tummy/src/widgets/PostWidget.dart';

class PostTile extends StatelessWidget {

  final Post post;

  PostTile(this.post);

  displayFullPost(context){
    print(post.ownerId);
    print(post.postId);
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreenPage(postId: post.postId,userId: post.ownerId,)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => displayFullPost(context),
      child: Image.network(post.url),
    );
  }
}
