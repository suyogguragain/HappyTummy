import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/models/user_model.dart';
import 'package:happy_tummy/src/pages/CommentsPage.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/pages/profile_page.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final dynamic likes;
  final String username;
  final String description;
  final String location;
  final String url;

  Post({
    this.postId,
    this.ownerId,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url,
  });

  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    return Post(
      postId: documentSnapshot['postId'],
      ownerId: documentSnapshot['ownerId'],
      likes: documentSnapshot['likes'],
      username: documentSnapshot['username'],
      description: documentSnapshot['description'],
      location: documentSnapshot['location'],
      url: documentSnapshot['url'],
    );
  }

  int getTotalNumberOfLikes(likes) {
    if (likes == null) {
      return 0;
    }

    int counter = 0;
    likes.values.forEach((eachValue) {
      if (eachValue == true) {
        counter = counter + 1;
      }
    });
    return counter;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        likes: this.likes,
        username: this.username,
        description: this.description,
        location: this.location,
        url: this.url,
        likeCount: getTotalNumberOfLikes(this.likes),
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  final likes;
  final String username;
  final String description;
  final String location;
  final String url;
  int likeCount;
  bool isLiked;
  bool showHeart = false;
  final String currentOnlineUserId = currentUser.id;

  _PostState({
    this.postId,
    this.ownerId,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url,
    this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    isLiked = likes[currentOnlineUserId] == true;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          createPostHead(),
          createPostPicture(),
          createPostFooter()
        ],
      ),
    );
  }

  createPostHead() {
    return FutureBuilder(
      future: usersReference.document(ownerId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(dataSnapshot.data);
        bool isPostOwner = currentOnlineUserId == ownerId;

        return Container( width: 390,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
            color: Colors.white,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user.url),
              backgroundColor: Colors.grey,
            ),
            title: GestureDetector(
              onTap: () => displayUserProfile(context, userprofileId: user.id),
              child: Text(
                user.username,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Text(
              location,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            trailing: isPostOwner
                ? IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    onPressed: () => controlPostDelete(context),
                  )
                : Text(''),
          ),
        );
      },
    );
  }

  controlPostDelete(BuildContext mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "What do you want?",
              style: TextStyle(color: Colors.black, fontSize: 25.0),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Delete",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  removeUserPost();
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  removeUserPost() async {
    postsReference
        .document(ownerId)
        .collection("userPosts")
        .document(postId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    storageReference.child("post_$postId.jpg").delete();

    QuerySnapshot querySnapshot = await activityFeedReferences
        .document(ownerId)
        .collection("feedItems")
        .where("postId", isEqualTo: postId)
        .getDocuments();

    querySnapshot.documents.forEach((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    QuerySnapshot commentquerySnapshot = await commentsReferences
        .document(postId)
        .collection("comments")
        .getDocuments();

    commentquerySnapshot.documents.forEach((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }

  displayUserProfile(BuildContext context, {String userprofileId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(userProfileId: userprofileId)));
  }

  removeLike() {
    bool isNotPostOwner = currentOnlineUserId != ownerId;

    if (isNotPostOwner) {
      activityFeedReferences
          .document(ownerId)
          .collection('feedItems')
          .document(postId)
          .get()
          .then((document) {
        if (document.exists) {
          document.reference.delete();
        }
      });
    }
  }

  addLike() {
    bool isNotPostOwner = currentOnlineUserId != ownerId;

    if (isNotPostOwner) {
      activityFeedReferences
          .document(ownerId)
          .collection('feedItems')
          .document(postId)
          .setData({
        'type': 'like',
        'username': currentUser.username,
        'userId': currentUser.id,
        'timestamp': DateTime.now(),
        'url': url,
        'postId': postId,
        'userProfileImg': currentUser.url,
      });
    }
  }

  controlUserLikePost() {
    bool _liked = likes[currentOnlineUserId] == true;

    if (_liked) {
      postsReference
          .document(ownerId)
          .collection("userPosts")
          .document(postId)
          .updateData({'likes.$currentOnlineUserId': false});

      removeLike();

      setState(() {
        likeCount = likeCount - 1;
        isLiked = false;
        likes[currentOnlineUserId] = false;
      });
    } else if (!_liked) {
      postsReference
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$currentOnlineUserId': true});

      addLike();

      setState(() {
        likeCount = likeCount + 1;
        isLiked = true;
        likes[currentOnlineUserId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 800), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  displayComments(BuildContext context,
      {String postId, String ownerId, String url}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentsPage(
          postId: postId, postOwnerId: ownerId, postImageUrl: url);
    }));
  }

  createPostPicture() {
    return GestureDetector(
      onDoubleTap: () => controlUserLikePost,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: 300,
            width: 390,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.scaleDown,
              ),
            ),
            //child: Image.network(url),
          ),
          showHeart
              ? Icon(
                  Icons.favorite,
                  size: 240.0,
                  color: Colors.redAccent,
                )
              : Text(''),
        ],
      ),
    );
  }

//
  createPostFooter() {
    return Container(
      width: 390,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 40.0, left: 20.0),
              ),
              GestureDetector(
                onTap: () => controlUserLikePost(),
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 28.0,
                  color: Colors.pink,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 20.0,
                ),
              ),
              GestureDetector(
                onTap: () => displayComments(context,
                    postId: postId, ownerId: ownerId, url: url),
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 28.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  '$likeCount likes',
                  style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  '$username',
                  style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }
}
