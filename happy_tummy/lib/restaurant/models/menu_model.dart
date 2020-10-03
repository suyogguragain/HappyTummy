import 'package:cloud_firestore/cloud_firestore.dart';

class Menu{
  final String postId;
  final String ownerId;
  final String url;

  Menu({
    this.postId,
    this.ownerId,
    this.url,
  });

  factory Menu.fromDocument(DocumentSnapshot documentSnapshot){
    return Menu(
      postId: documentSnapshot['postId'],
      ownerId: documentSnapshot['ownerId'],
      url: documentSnapshot['url'],
    );
  }
}