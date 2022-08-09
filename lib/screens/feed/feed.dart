import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tmu_direct/screens/make_post/make_post.dart';
import 'package:tmu_direct/services/firestore_methods.dart';
import '../../temp.dart';
import 'package:intl/intl.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  FireStoreMethods _fireStoreMethods = FireStoreMethods();
  CollectionReference projectsReference =
      FirebaseFirestore.instance.collection('projects');
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: Image(
          width: 40,
          image: AssetImage('asset/image/logo.png'),
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: RichText(
          text: TextSpan(
              style: TextStyle(fontFamily: "RozhaOne", fontSize: 23),
              children: [
                TextSpan(
                    text: "TMU", style: TextStyle(color: Color(0xffF89009))),
                TextSpan(text: "DIRECT"),
              ]),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (_) => TempPage()));
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Color(0xff3D3D3D)),
                  shape: BoxShape.circle),
              child: Icon(
                Icons.feed,
                color: Color(0xff3D3D3D),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            child: Container(
              width: 45,
              height: 45,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor.withOpacity(0.7),
                  border: Border.all(width: 2, color: Color(0xff3D3D3D)),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("asset/image/avatar.jpg"),
                      fit: BoxFit.contain)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 45,
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    if (index < 1) {
                      return SizedBox(
                        width: 15,
                      );
                    }
                    return InkWell(
                      onTap: () {
                        print(_auth.currentUser);
                        print(_auth.currentUser!.displayName);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 15),
                        width: 120,
                        decoration: BoxDecoration(
                            color: Color(0xffF89009),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                          'Following',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: "Rubik"),
                        )),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color(0xff1C1F23),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MakePost()));
                      },
                      child: Row(
                        children: [
                          InkWell(
                            child: Container(
                              width: 45,
                              height: 45,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.7),
                                  border: Border.all(
                                      width: 2, color: Color(0xff3D3D3D)),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image:
                                          AssetImage("asset/image/avatar.jpg"),
                                      fit: BoxFit.contain)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.6,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 1, color: Color(0xff3A3B3C))),
                            child: Text(
                              "What do you think ?",
                              style: TextStyle(color: Color(0xff828282)),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(height: 4, color: Color(0xff3A3B3C)),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.video_camera_back,
                                size: 25,
                                color: Color(0xffF3425F),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Video",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: "Rubik"),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 25,
                                color: Color(0xff45BD62),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Image",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: "Rubik"),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final firestore;
final postId;
  CommentWidget({
    required this.firestore,
    required this.postId
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('posts')
                  .doc(postId)
                  .collection('comments')
                  .snapshots(),            builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return Expanded(
                  child: Center(
                      child:
                      CircularProgressIndicator()));
            } else {
              final comments = snapshot.data!.docs;
              List<Container> commentWidget = [];
              for (var comment in comments) {
                final commentsList = Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("asset/image/Dilshan1.png"))),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color(0xffF0F2F5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text: "${(comment.data() as dynamic)['text']}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Rubik",
                                          fontSize: 12)),
                                  maxLines: 4,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "6",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      InkWell(
                                        child: Icon(
                                          Icons.thumb_up,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text("1",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      InkWell(
                                        child: Icon(Icons.thumb_down,
                                            size: 16, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );

                commentWidget.add(commentsList);
              }
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 5),
                children: commentWidget.toList(),
              );
            }

            }
          ),
        )
    );
  }
}
