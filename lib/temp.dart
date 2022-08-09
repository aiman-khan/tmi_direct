import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TempPage extends StatefulWidget {
  @override
  _TempPageState createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {
  final firestore = FirebaseFirestore.instance;
  CollectionReference projectsReference = FirebaseFirestore.instance.collection('projects');
  FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30.0),
              StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('posts').
                  snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("No posts added yet")),
                      );
                    }

                    else {
                      final posts = snapshot.data!.docs;
                      List<Container> projectWidgets = [];
                      for (var post in posts) {
                        final postOwner =
                        (post.data() as dynamic)['username'];
                        final postDescription =
                        (post.data() as dynamic)['description'];

                        final projectList = Container(
                            child: GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
                                child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.5),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            postOwner,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Text(
                                            postDescription,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                            ),
                                            textAlign: TextAlign.justify,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ));

                        projectWidgets.add(projectList);
                      }

                      return Expanded(
                          child: ListView(
                            padding: EdgeInsets.only(left: 5),
                            children: projectWidgets.toList(),
                          ));
                    }
                  }),

              // FutureBuilder<DocumentSnapshot> (
              //   future: projectsReference.doc(_auth.currentUser!.uid).get(),
              //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              //
              //     if (snapshot.hasError) {
              //       return Text("Something went wrong");
              //     }
              //
              //     if (snapshot.hasData && !snapshot.data!.exists) {
              //       return Text("Document does not exist");
              //     }
              //
              //     if (snapshot.connectionState == ConnectionState.done) {
              //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              //       return Padding(
              //         padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
              //         child: GestureDetector(
              //           onTap: () => navigateToDetail(snapshot.data!['tg']),
              //           child: Card(
              //               child: Padding(
              //                 padding: const EdgeInsets.all(8.5),
              //                 child: Column(
              //                   crossAxisAlignment:
              //                   CrossAxisAlignment.start,
              //                   children: <Widget>[
              //                     Text(
              //                       '${data['title']}',
              //                       style: GoogleFonts.aBeeZee(
              //                         fontSize: 18.0,
              //                       ),
              //                     ),
              //                     kSizedBox(),
              //                     Text(
              //                       '${data['description']}',
              //                       style: GoogleFonts.aBeeZee(
              //                         fontSize: 12.0,
              //                       ),
              //                       textAlign: TextAlign.justify,
              //                       maxLines: 2,
              //                     ),
              //                   ],
              //                 ),
              //               )),
              //         ),
              //       );
              //         // Text("Title: ${data['title']} ${data['description']}");
              //     }
              //     return Text("loading");
              //   },
              // )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Container(
              width: 60,
              height: 60,
              child: Icon(
                Icons.post_add_outlined,
                size: 40,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 7,
                      offset: Offset(4, 5),
                    ),
                  ]
              ),
            ),
            onPressed: () {
              setState(() {
              });
            },
          )),
    );
  }
}
