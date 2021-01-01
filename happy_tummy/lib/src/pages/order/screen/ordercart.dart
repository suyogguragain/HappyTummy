import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/pages/order/screen/checkout.dart';

class OrderCart extends StatefulWidget {
  final String restaurantid;

  OrderCart({this.restaurantid});

  @override
  _OrderCartState createState() => _OrderCartState();
}

class _OrderCartState extends State<OrderCart> {
  bool loading = false;
  int countPost = 0;
  Stream taskStream;

  deleteTask(String restaurantId, String cartId) {
    Firestore.instance
        .collection("foodcart")
        .document(currentUser.id)
        .collection('Cart')
        .document(restaurantId)
        .collection("foodlist")
        .document(cartId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });

    Firestore.instance
        .collection("order")
        .document(restaurantId)
        .collection('checkout')
        .document(currentUser.id)
        .collection("foodlist")
        .document(cartId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  saveCheckoutInfoToFireStore(String name, int price, int quantity, String url,
      String postid, String restaurantid) {
    Firestore.instance
        .collection('intermediate')
        .document(currentUser.id)
        .collection('Cart')
        .document(widget.restaurantid)
        .collection('foodlist')
        .document(postid)
        .setData({
      'cartId': postid,
      'ownerId': currentUser.id,
      'timestamp': DateTime.now(),
      'restaurantId': widget.restaurantid,
      'quantity': quantity,
      'name': name,
      'url': url,
      'price': price
    });
  }

  Widget taskList() {
    return StreamBuilder(
      stream: taskStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(top: 3),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
//                snapshot.data.documents[index].data["description"],
//                snapshot.data.documents[index].data['offerId'],
//                snapshot.data.documents[index].data["title"],
//                snapshot.data.documents[index].data["ownerId"],
                  return Column(
                    children: [
                      Container(
                        //width: 320,
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        margin: EdgeInsets.only(
                            top: 20, left: 10, right: 10, bottom: 5),
                        decoration: BoxDecoration(
                            color: Colors.teal[50],
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              width: MediaQuery.of(context).size.width / 3.2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                  image: NetworkImage(
                                    snapshot.data.documents[index].data["url"],
                                  ),
                                  fit: BoxFit.fill,
                                  height:
                                      MediaQuery.of(context).size.height / 7,
                                  width: MediaQuery.of(context).size.height / 5,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 20, 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 18),
                                    Text(
                                        snapshot
                                            .data.documents[index].data["name"],
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: 'PermantMarker',
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.0,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        snapshot.data.documents[index]
                                            .data["quantity"]
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'PermantMarker',
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.5,
                                            color: Colors.blue)),
                                    SizedBox(height: 10),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                        text: 'Rs.',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFFF4D479),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: snapshot
                                            .data.documents[index].data["price"]
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Color(0xFFF4D479),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ]))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 8,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      deleteTask(
                                          snapshot.data.documents[index]
                                              .data["restaurantId"],
                                          snapshot.data.documents[index]
                                              .data["cartId"]);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 8,
                        child: Row(
                          children: [
                            GestureDetector(

                              onTap: () {
//                                saveCheckoutInfoToFireStore(
//                                  snapshot.data.documents[index].data["name"],
//                                  snapshot.data.documents[index].data["price"],
//                                  snapshot
//                                      .data.documents[index].data["quantity"],
//                                  snapshot.data.documents[index].data["url"],
//                                  snapshot.data.documents[index].data["cartId"],
//                                  snapshot.data.documents[index]
//                                      .data["restaurantId"],
//                                );
                              },

                              child: Text('')
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })
            : Text(
                'suyog',
                style: TextStyle(fontSize: 50),
              );
      },
    );
  }

  @override
  void initState() {
    getTasks(widget.restaurantid).then((val) {
      taskStream = val;
      setState(() {});
    });

    super.initState();
  }

  getTasks(String userId) async {
    return await Firestore.instance
        .collection("foodcart")
        .document(currentUser.id)
        .collection('Cart')
        .document(userId)
        .collection("foodlist")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Cart",
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: taskList(),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "CheckOut",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        onPressed: () {
          print(countPost);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Checkout(
                currentuserid: currentUser.id,
                restaurantid: widget.restaurantid,
              ),
            ),
          );
        },
        icon: Icon(Icons.assignment_rounded),
        hoverColor: Colors.blue,
      ),
    );
  }
}
