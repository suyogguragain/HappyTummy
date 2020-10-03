import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/sections/components/constants.dart';
import 'package:happy_tummy/restaurant/sections/components/events_card.dart';
import 'package:happy_tummy/restaurant/sections/components/section_title.dart';
import 'package:happy_tummy/restaurant/ui/widget/tabs.dart';
import 'package:uuid/uuid.dart';

class FoodEventsSection extends StatefulWidget {
  final String restaurantProfileId;

  FoodEventsSection({this.restaurantProfileId});

  @override
  _FoodEventsSectionState createState() => _FoodEventsSectionState();
}

class _FoodEventsSectionState extends State<FoodEventsSection> {
  TextEditingController headingTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  bool uploading = false;
  String eventId = Uuid().v4();
  bool isHover = false;
  Stream taskStream;

  bool headingValidate = false;
  bool descValidate = false;

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    saveEventsToFireStore(
        heading: headingTextEditingController.text,
        desc: descriptionTextEditingController.text);

    headingTextEditingController.clear();
    descriptionTextEditingController.clear();

    setState(() {
      uploading = false;
      eventId = Uuid().v4();
    });
  }

  saveEventsToFireStore({String heading, String desc}) {
    eventsReference
        .document(widget.restaurantProfileId)
        .collection('userPosts')
        .document(eventId)
        .setData({
      'eventId': eventId,
      'ownerId': widget.restaurantProfileId,
      'timestamp': DateTime.now(),
      'description': desc,
      'heading': heading
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
                  return EventsCard(
                    snapshot.data.documents[index].data["description"],
                    snapshot.data.documents[index].data['eventId'],
                    snapshot.data.documents[index].data["heading"],
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
        .collection("events")
        .document(userId)
        .collection("userPosts")
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
                            "assets/images/event.png",
                            height: 40,
                            width: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Add New Events!",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: kDefaultPadding / 2),
                                Text(
                                  "Add food related events you want to organize.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
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
                            labelText: 'Heading',
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
                            hintText: 'Write details about your events',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                            errorText: descValidate
                                ? 'Please enter a Description'
                                : null),
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
                                Text("Add Events!"),
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
                title: "Recent Events",
                subTitle: "Food related events",
                color: Color(0xFFFFB100),
              ),
              SizedBox(height: kDefaultPadding),
              //display events
              taskList(),
              SizedBox(height: kDefaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
