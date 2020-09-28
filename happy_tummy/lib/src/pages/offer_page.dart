import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';

class OfferPage extends StatefulWidget {
  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  Future _data;
  Future getoffers() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection('offers').document('LNmy1AGQ3DdTQd4uizV91o84F6P2').collection('restarurantOffers').getDocuments();

    return qn.documents;
  }

  Future<List<DocumentSnapshot>> getProduceID() async{
    var data = await Firestore.instance.collection('offers').getDocuments();
    var productId = data.documents;
    print(productId);
    return productId;


  }


//  navigateToDetail(DocumentSnapshot restaurantoffer){
//    Navigator.push(context, MaterialPageRoute(builder: (context) => OfferDetails(offer: restaurantoffer,)));
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = getoffers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,strTitle: "Offers"),
      body: Container(
        child: FutureBuilder(
            future: _data,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Center(
                  child: Text("Loading"),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        onLongPress: ()=> getProduceID(),
                        title: Text(snapshot.data[index].data['description']), onTap: (){
                          //print("offers");
                         // navigateToDetail(snapshot.data[index]);
                        },
                      );
                    });
              }
            }),

//        child: Center(
//          child: ListView(
//            physics: NeverScrollableScrollPhysics(),
//            shrinkWrap: true,
//            children: <Widget>[
//              Icon(Icons.local_offer,color: Colors.lightBlueAccent,size: 150.0,),
//              Text(
//                'No Offers Available',
//                textAlign: TextAlign.center,
//                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500,fontSize: 22.0,fontFamily:'Lobster',),
//              ),
//            ],
//          ),
//        ),
      ),
    );
  }
}


