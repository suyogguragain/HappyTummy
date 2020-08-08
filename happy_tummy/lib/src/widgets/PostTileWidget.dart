import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () => displayFullPost(context),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(post.url),
                radius: 55.0,
              ),//Image.network(post.url),
            ),
            Column(
              children: <Widget>[
                Text(post.location,style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Lobster',
                  color: Colors.black54,
                  wordSpacing: 1.2,
                ),),
                Text(post.description,style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                  fontFamily: 'Lobster',
                ),),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
