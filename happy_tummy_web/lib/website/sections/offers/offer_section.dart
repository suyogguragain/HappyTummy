import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy_web/ui/widgets/tabs.dart';
import 'package:happy_tummy_web/website/components/section_title.dart';
import 'package:happy_tummy_web/website/constants.dart';
import 'package:happy_tummy_web/website/sections/offers/offercard.dart';
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
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: kDefaultPadding / 2),
                                Text(
                                  "Add offers you want to boost!",
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
                                Text("Add Offers!"),
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
                          labelText: 'Offer Headline',
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
                          hintText:
                              'Write details about your offers, location and validation date.',
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
                title: "Recent Offers",
                subTitle: "Food related offers at Restaurants",
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
