import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem{
  final String postId;
  final String ownerId;
  final String url;
  final String category;
  final String desc;
  final String name;
  final String price;


  FoodItem({
    this.postId,
    this.ownerId,
    this.url,
    this.category,
    this.desc,
    this.name,
    this.price,
  });

  factory FoodItem.fromDocument(DocumentSnapshot documentSnapshot){
    return FoodItem(
      postId: documentSnapshot['postId'],
      ownerId: documentSnapshot['ownerId'],
      url: documentSnapshot['url'],
      category: documentSnapshot['category'],
      name: documentSnapshot['name'],
      desc: documentSnapshot['description'],
      price: documentSnapshot['price'],
    );
  }
}