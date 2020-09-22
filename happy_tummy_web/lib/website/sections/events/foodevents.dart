import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy_web/ui/widgets/tabs.dart';
import 'package:happy_tummy_web/website/components/section_title.dart';
import 'package:happy_tummy_web/website/constants.dart';
import 'package:happy_tummy_web/website/sections/events/components/events_card.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: kDefaultPadding * 6),
          width: double.infinity,
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
                  padding: EdgeInsets.all(kDefaultPadding * 2),
                  constraints: BoxConstraints(maxWidth: 1110),
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
                                  "Add New Events!",
                                  style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: kDefaultPadding / 2),
                                Text(
                                  "Add food related events you want to organize.",
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                )
                              ],
                            ),
                          ),
                          FlatButton(
                            padding: EdgeInsets.symmetric(
                              vertical: kDefaultPadding,
                              horizontal: kDefaultPadding * 2.5,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            color: Color(0xFFE8F0F9),
                            onPressed:
                                uploading ? null : () => controlUploadAndSave(),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 20,
                                ),
                                SizedBox(width: kDefaultPadding),
                                Text("Add Events!"),
                              ],
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 20),
                      // Title
                      TextField(
                        controller: headingTextEditingController,
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: Colors.black87),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Heading',
                        ),
                      ),
                      // Body text
                      TextField(
                        controller: descriptionTextEditingController,
                        maxLines: null,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.black87, height: 1.7),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Write details about your events',
                          border: InputBorder.none,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.grey.shade400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SectionTitle(
                title: "Recent Events",
                subTitle: "Food related events",
                color: Color(0xFFFFB100),
              ),
              SizedBox(height: kDefaultPadding * 1.5),
              //display events
              taskList(),
              SizedBox(height: kDefaultPadding * 5),
            ],
          ),
        ),
      ),
    );
  }
}
