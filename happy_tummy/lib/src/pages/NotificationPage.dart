import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/PostScreenPage.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/pages/profile_page.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
import 'package:timeago/timeago.dart' as tAgo;

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,strTitle: "Notifications"),
      body: Container(
        child: FutureBuilder(
          future: retrieveNotifications(),
          builder: (context, dataSnapshot){
            if(!dataSnapshot.hasData){
              return circularProgress();
            }
            return ListView(
              children: dataSnapshot.data,
            );
          },
        ),
      ),
    );
  }

  retrieveNotifications() async {
    QuerySnapshot querySnapshot = await activityFeedReferences.document(currentUser.id)
        .collection("feedItems").orderBy("timestamp",descending: true )
        .limit(60).getDocuments();

    List<NoticationsItem> notificationsItems = [];

    querySnapshot.documents.forEach((document) {
      notificationsItems.add(NoticationsItem.fromDocument(document));
    });

    return notificationsItems;

  }

}

String notificationItemText;
Widget mediaPreview;

class NoticationsItem extends StatelessWidget {

  final String username;
  final String type;
  final String commentData;
  final String postId;
  final String userId;
  final String userProfileImg;
  final String url;
  final Timestamp timestamp;

  NoticationsItem({this.username, this.type, this.commentData, this.postId,this.url,this.userId,this.userProfileImg,this.timestamp,});

  factory NoticationsItem.fromDocument(DocumentSnapshot documentSnapshot){
    return NoticationsItem(
      username: documentSnapshot['username'],
      type: documentSnapshot['type'],
      commentData: documentSnapshot['commentData'],
      postId: documentSnapshot['postId'],
      userId: documentSnapshot['userId'],
      url: documentSnapshot['url'],
      userProfileImg: documentSnapshot['userProfileImg'],
      timestamp: documentSnapshot['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {

    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white70,
        child: ListTile(
          title: GestureDetector(
            onTap: ()=> displayUserProfile(context, userprofileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(fontSize: 14.0, color: Colors.black),
                children: [
                  TextSpan(text: username, style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Lobster")),
                  TextSpan(text: " $notificationItemText",style:TextStyle(fontWeight: FontWeight.bold,fontFamily: "Lobster") ),
                ],
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          subtitle: Text(tAgo.format(timestamp.toDate()),overflow: TextOverflow.ellipsis,),
          trailing: mediaPreview,
        ),
      ),
    );
  }


  configureMediaPreview(context){
    if(type == "comment" || type == "like"){
      mediaPreview = GestureDetector(
        onTap: () => displayOwnPost(context, userprofileId: currentUser.id),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
              aspectRatio: 16/9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(fit:BoxFit.cover, image: CachedNetworkImageProvider(url)),
                ),
              ),
          ),
        ),
      );
    }
    else{
      mediaPreview = Text('');
    }

    if(type == "like"){
      notificationItemText ="liked your post.";
    }
    else if(type == "comment"){
      notificationItemText ="replied: $commentData";
    }
    else if(type == "follow"){
      notificationItemText ="started following you.";
    }
    else {
      notificationItemText ="Error,Unknown type = $type .";
    }

  }

  displayOwnPost(BuildContext context, {String userprofileId}){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage(userProfileId: currentUser.id,)));
  }


  displayUserProfile(BuildContext context, {String userprofileId}){
    Navigator.push( context, MaterialPageRoute(builder: (context) => ProfilePage(userProfileId: userprofileId)));
  }



}

