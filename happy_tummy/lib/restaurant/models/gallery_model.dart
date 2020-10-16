import 'package:cloud_firestore/cloud_firestore.dart';

class Gallery{
  final String postId;
  final String ownerId;
  final String url;

  Gallery({
    this.postId,
    this.ownerId,
    this.url,
  });

  factory Gallery.fromDocument(DocumentSnapshot documentSnapshot){
    return Gallery(
      postId: documentSnapshot['postId'],
      ownerId: documentSnapshot['ownerId'],
      url: documentSnapshot['url'],
    );
  }
}