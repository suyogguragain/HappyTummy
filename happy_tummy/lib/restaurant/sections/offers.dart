import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/sections/components/constants.dart';
import 'package:happy_tummy/restaurant/sections/components/offercard.dart';
import 'package:happy_tummy/restaurant/sections/components/section_title.dart';
import 'package:happy_tummy/restaurant/ui/widget/tabs.dart';
import 'package:uuid/uuid.dart';

class OffersSection extends StatefulWidget {
  final String restaurantProfileId;

  OffersSection({this.restaurantProfileId});

  @override
  _OffersSectionState createState() => _OffersSectionState();
}

class _OffersSectionState extends State<OffersSection> {
  TextEditingController headingTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  bool uploading = false;
  String offerId = Uuid().v4();
  bool isHover = false;
  Stream taskStream;
  bool headingValidate = false;
  bool descValidate = false;

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    saveEventsToFireStore(
        title: headingTextEditingController.text,
        desc: descriptionTextEditingController.text);

    headingTextEditingController.clear();
    descriptionTextEditingController.clear();

    setState(() {
      uploading = false;
      offerId = Uuid().v4();
    });
  }

  saveEventsToFireStore({String title, String desc}) {
    offersReference
        .document(widget.restaurantProfileId)
        .collection('restarurantOffers')
        .document(offerId)
        .setData({
      'offerId': offerId,
      'ownerId': widget.restaurantProfileId,
      'timestamp': DateTime.now(),
      'description': desc,
      'title': title
    });
  }

  Widget taskList() {
    return StreamBuilder(
      stream: taskStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(top: 16),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return OfferCard(
                    snapshot.data.documents[index].data["description"],
                    snapshot.data.documents[index].data['offerId'],
                    snapshot.data.documents[index].data["title"],
                    snapshot.data.documents[index].data["ownerId"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getTasks(widget.restaurantProfileId).then((val) {
      taskStream = val;
      setState(() {});
    });

    super.initState();
  }

  getTasks(String userId) async {
    return await Firestore.instance
        .collection("offers")
        .document(userId)
        .collection("restarurantOffers")
        .snapshots();
  }

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        headingValidate = true;
        descValidate = true;
      });
      return false;
    }
    setState(() {
      headingValidate = false;
      descValidate = false;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: kDefaultPadding * 5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFF7E8FF).withOpacity(0.3),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/recent_work_bg.png"),
            ),
          ),
          child: Column(
            children: [
              Transform.translate(
                offset: Offset(0, -80),
                //addevent top section
                child: Container(
                  padding: EdgeInsets.all(kDefaultPadding),
                  constraints: BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [kDefaultShadow],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/offer.png",
                            height: 80,
                            width: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding),
                            child: SizedBox(
                              height: 80,
                              child: VerticalDivider(),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Add Offers!",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: kDefaultPadding / 2),
                                Text(
                                  "Add offers you want to boost!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Title
                      TextField(
                        controller: headingTextEditingController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Offer Headline',
                            errorText: headingValidate
                                ? 'Please enter a Heading'
                                : null),
                      ),
                      // Body text
                      TextField(
                        controller: descriptionTextEditingController,
                        maxLines: null,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText:
                              'Write details about your offers, location and validation date.',
                          border: InputBorder.none,
                          errorText: descValidate
                              ? 'Please enter a Description'
                              : null,
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, right: 160),
                        child: Container(
                          width: 200,
                          padding: EdgeInsets.only(right: 39),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60)),
                            color: Color(0xFFE8F0F9),
                            onPressed: uploading
                                ? null
                                : () {
                                    print("click");
                                    validateTextField(
                                        headingTextEditingController.text);
                                    validateTextField(
                                        descriptionTextEditingController.text);

                                    if (headingValidate == true &&
                                        descValidate == true) {
                                      final snackBar = SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'Error !',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        action: SnackBarAction(
                                          label: 'Ok',
                                          onPressed: () {
                                            // Some code to undo the change.
                                          },
                                        ),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      controlUploadAndSave();
                                      final snackBar = SnackBar(
                                        backgroundColor: Colors.blue,
                                        content: Text(
                                          'Succesfully added !',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        action: SnackBarAction(
                                          label: 'Ok',
                                          onPressed: () {
                                            // Some code to undo the change.
                                          },
                                        ),
                                      );

                                      // Find the Scaffold in the widget tree and use
                                      // it to show a SnackBar.
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 15,
                                ),
                                SizedBox(width: 6),
                                Text("Add Offers!"),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SectionTitle(
                title: "Recent Offers",
                subTitle: "Food related offers at Restaurants",
                color: Color(0xFFFFB100),
              ),
              //display events
              taskList(),
            ],
          ),
        ),
      ),
    );
  }
}
