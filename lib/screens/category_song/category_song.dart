import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategorySong extends StatefulWidget {
  final category;
  CategorySong({required this.category});
  @override
  _CategorySongState createState() => _CategorySongState();
}

class _CategorySongState extends State<CategorySong> {
  final firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future getCategoryData(category) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("music")
        .orderBy("datePublished", descending: true)
        .where("category", isEqualTo: category)
        .get();
    return querySnapshot.docs;
  }

  removeSong(DocumentSnapshot audio) {
    FirebaseFirestore.instance.collection("music").doc(audio.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  image: DecorationImage(
                      image: AssetImage("asset/image/hiphop.jpg"))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle),
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "${widget.category}",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w500,
                    fontSize: 22),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder<dynamic>(
                    initialData: [],
                    future: getCategoryData("${widget.category}"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: RefreshProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        var data = snapshot.data.length;
                        return Text(
                          "$data songs",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Rubik",
                              fontSize: 18),
                        );
                      } else {
                        return Text('empty');
                      }
                    })),
            StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('music')
                    .where('category', isEqualTo: '${widget.category}')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: Colors.deepOrange,
                          )),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("No songs added yet")),
                    );
                  } else {
                    final posts = snapshot.data!.docs;

                    List<Container> audioWidget = [];
                    for (var audio in posts) {
                      final title = (audio.data() as dynamic)['title'];
                      final author = (audio.data() as dynamic)['author_name'];
                      final audio_url = (audio.data() as dynamic)['audioUrl'];

                      final audioList = Container(
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.7),
                                image: DecorationImage(
                                    image: AssetImage('asset/image/song.png'),
                                    fit: BoxFit.cover)),
                          ),
                          title: Text(
                            "$title",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          subtitle: Text(
                            "$author",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Rubik",
                                fontSize: 10),
                          ),
                          trailing: PopupMenuButton<int>(
                            icon: Icon(
                              Icons.adaptive.more,
                              color: Colors.white,
                            ),
                            itemBuilder: (context) => [
                              // PopupMenuItem 1
                              PopupMenuItem(
                                value: 1,
                                // row with 2 children
                                child: Row(
                                  children: [
                                    Icon(Icons.play_arrow),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Play")
                                  ],
                                ),
                              ),
                              // PopupMenuItem 2
                              PopupMenuItem(
                                value: 2,
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Remove")
                                  ],
                                ),
                              ),
                            ],
                            offset: Offset(0, 100),
                            color: Colors.white,
                            elevation: 2,
                            // on selected we show the dialog box
                            onSelected: (value) {
                              if (value == 1) {
                                AudioPlayer audioplayer = AudioPlayer();
                                audioplayer.play(DeviceFileSource(audio_url));
                              } else if (value == 2) {
                                removeSong(audio);
                              }
                            },
                          ),
                        ),
                      );

                      audioWidget.add(audioList);
                    }

                    return ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 5),
                      children: audioWidget.toList(),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
