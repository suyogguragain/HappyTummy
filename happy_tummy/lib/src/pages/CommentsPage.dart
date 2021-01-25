import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/models/user_model.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:uuid/uuid.dart';

User current;

class CommentsPage extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;

  CommentsPage({this.postId, this.postOwnerId, this.postImageUrl});

  @override
  CommentsPageState createState() => CommentsPageState(
      postId: postId, postOwnerId: postOwnerId, postImageUrl: postImageUrl);
}

class CommentsPageState extends State<CommentsPage> {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;
  TextEditingController commenttextEditingController = TextEditingController();
  String commentId = Uuid().v4();

  CommentsPageState({this.postId, this.postOwnerId, this.postImageUrl});

  retrieveComments() {
    return StreamBuilder(
      stream: commentsReferences
          .document(postId)
          .collection('comments')
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<Comment> comments = [];
        dataSnapshot.data.documents.forEach((document) {
          comments.add(Comment.fromDocument(document));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  saveComment() {
    commentsReferences
        .document(postId)
        .collection("comments")
        .document(commentId)
        .setData({
      'username': currentUser.username,
      'comment': commenttextEditingController.text,
      'timestamp': DateTime.now(),
      'url': currentUser.url,
      'userId': currentUser.id,
      'postId': postId,
      'commentId': commentId,
    });

    bool isNotPostOwner = postOwnerId != currentUser.id;
    if (isNotPostOwner) {
      activityFeedReferences.document(postOwnerId).collection("feedItems").add({
        'type': 'comment',
        'commentData': commenttextEditingController.text,
        'postId': postId,
        'userId': currentUser.id,
        'username': currentUser.username,
        'userProfileImg': currentUser.url,
        'url': postImageUrl,
        'timestamp': timestamp,
        'commentId': commentId,
      });
    }
    commenttextEditingController.clear();
    setState(() {
      commentId = Uuid().v4();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: 'Comments'),
      body: Column(
        children: <Widget>[
          Expanded(child: retrieveComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commenttextEditingController,
              decoration: InputDecoration(
                labelText: 'Comment',
                labelStyle: TextStyle(
                    color: Colors.black54,
                    fontFamily: "Lobster",
                    fontSize: 25.0),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
              ),
              style: TextStyle(color: Colors.black),
            ),
            trailing: OutlineButton(
              onPressed: saveComment,
              borderSide: BorderSide.none,
              child: Text(
                "Publish",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "EastSeaDokdo",
                    fontSize: 30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatefulWidget {
  final String username;
  final String userId;
  final String url;
  final String comment;
  final Timestamp timestamp;
  final String postId;
  final String commentId;

  Comment(
      {this.username,
      this.userId,
      this.url,
      this.comment,
      this.timestamp,
      this.postId,
      this.commentId});

  factory Comment.fromDocument(DocumentSnapshot documentSnapshot) {
    return Comment(
      username: documentSnapshot['username'],
      userId: documentSnapshot['userId'],
      url: documentSnapshot['url'],
      comment: documentSnapshot['comment'],
      timestamp: documentSnapshot['timestamp'],
      postId: documentSnapshot['postId'],
      commentId: documentSnapshot['commentId'],
    );
  }

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  Stream taskStream;

  Widget taskList() {
    return StreamBuilder(
      stream: taskStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(top: 3),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(40.0, 10.0, 8.0, 8.0),
                    child: Stack(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  6.0, 2.0, 10.0, 2.0),
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  child: ClipRRect(
                                    child: Image.network(snapshot
                                        .data.documents[index].data["url"]),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            snapshot.data.documents[index]
                                                .data["username"],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Text(snapshot
                                                .data
                                                .documents[index]
                                                .data["comment"])),
                                      ],
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.62,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 4.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.38,
                                    child: Text(tAgo.format(snapshot
                                        .data.documents[index].data["timestamp"]
                                        .toDate())),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                })
            : Text('');
      },
    );
  }

  void initState() {
    getTasks().then((val) {
      taskStream = val;
      setState(() {});
    });

    super.initState();
  }

  getTasks() async {
    return await Firestore.instance
        .collection("comments")
        .document(widget.postId)
        .collection('reply')
        .document(widget.commentId)
        .collection("replies")
        .snapshots();
  }

  saveReplyCommentInfoToFireStore(
      String postid, String commentid, String replycomment) {
    Firestore.instance
        .collection('comments')
        .document(postid)
        .collection('reply')
        .document(commentid)
        .collection('replies')
        .add({
      'username': currentUser.username,
      'comment': replycomment,
      'timestamp': DateTime.now(),
      'url': currentUser.url,
      'userId': currentUser.id,
      'postId': widget.postId,
      'commentId': widget.commentId,
    });
  }

  createdAlertDialog(BuildContext context, String postid, String commentid) {
    TextEditingController replycomment = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Reply Comment",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            content: TextField(
              controller: replycomment,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'Reply Comment',
              ),
            ),
            actions: [
              MaterialButton(
                color: Colors.black54,
                textColor: Colors.white,
                onPressed: () {
                  saveReplyCommentInfoToFireStore(widget.postId,
                      widget.commentId, replycomment.text.toString());
                  print(currentUser.id);
                  print(currentUser.profileName);
                  print(currentUser.url);

                  Navigator.of(context).pop(replycomment.text.toString());
                  print(replycomment.text.toString());
                },
                child: Text(
                  "Reply",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                elevation: 5.0,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.0, top: 10, left: 15, right: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 8.0, 8.0),
              child: Stack(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6.0, 2.0, 10.0, 2.0),
                        child: Container(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                              child: Image.network(widget.url),
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      widget.username,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(widget.comment)),
                                ],
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.72,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.38,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(tAgo.format(widget.timestamp.toDate())),
                                  GestureDetector(
                                      onTap: () {
                                        print('leave comment of comment');
                                        print(currentUser.id);
                                        print(currentUser.profileName);
                                        print(currentUser.url);
                                        createdAlertDialog(context,
                                            widget.postId, widget.commentId);
                                      },
                                      child: Text('Reply',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700]))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            taskList(),
          ],
        ),
      ),
    );
  }
}
