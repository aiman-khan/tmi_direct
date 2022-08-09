import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:tmu_direct/screens/category_song/category_song.dart';
import 'package:tmu_direct/screens/music/playlist/add_playlist.dart';
import 'package:tmu_direct/services/storage_methods.dart';

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<Music> {
  UploadTask? task;
  File? file;
  bool like = false;
  bool isPlaying = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void likeAndUnlike() {
    setState(() {
      like = !like;
    });
  }

  void playAndStop() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future getPlaylist() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("playlists").where('uploadedBy', isEqualTo: _auth.currentUser!.displayName)
        .get();
    return querySnapshot.docs;
  }

  Future getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("music")
        .orderBy("datePublished", descending: true)
        .get();
    return querySnapshot.docs;
  }

  Future getCategoryData(category) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("music")
        .orderBy("datePublished", descending: true)
        .where("category", isEqualTo: category)
        .get();
    return querySnapshot.docs;
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = StorageMethods.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Future<void> listExample() async {
    final storageRef = FirebaseStorage.instance.ref().child("files/");

    ListResult result = await FirebaseStorage.instance.ref().listAll();

    final listResult = await storageRef.listAll();
    for (var prefix in listResult.prefixes) {
      print('prefix: $prefix');
    }
    for (var item in listResult.items) {
      print('item: $item');
    }

    result.items.forEach((Reference ref) {
      print('Found file: $ref');
    });

    result.prefixes.forEach((Reference ref) {
      print('Found directory: $ref');
    });
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    AudioPlayer audio = AudioPlayer();
    bool isPlaying = false;
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('music').snapshots();
    int data = 0;
    return Scaffold(
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
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Color(0xff3D3D3D)),
                shape: BoxShape.circle),
            child: GestureDetector(
              onTap: listExample,
              child: Icon(
                Icons.music_note,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hot Music",
                    style: TextStyle(
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "See All",
                        style: TextStyle(
                            color: Color(0xffF89009),
                            fontFamily: "Rubik",
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 300,
              child: FutureBuilder<dynamic>(
                  initialData: [],
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width / 2,
                              margin: EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xff1C1F23)),
                              child: Column(
                                children: [
                                  Container(
                                    height: 180,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                'asset/image/song.png'))),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 80,
                                              child: Text(
                                                (snapshot.data
                                                        as dynamic)[index]
                                                    ['title'],
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontFamily: "Rubik",
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              (snapshot.data as dynamic)[index]
                                                  ['author_name'],
                                              style: TextStyle(
                                                  fontFamily: "Rubik",
                                                  fontSize: 10,
                                                  color: Color(0xff828282)),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons.thumb_up,
                                                      color: Color(0xffF85F55),
                                                      size: 20,
                                                    )),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.thumb_down,
                                                        color:
                                                            Color(0xff4F4F4F),
                                                        size: 20)),
                                              ],
                                            )
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            audio.play(DeviceFileSource(
                                              (snapshot.data as dynamic)[index]
                                                  ['audioUrl'],
                                            ));
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                                color: Color(0xff4F4F4F),
                                                shape: BoxShape.circle),
                                            child: (isPlaying) == true
                                                ? Icon(Icons.stop)
                                                : Icon(Icons.play_arrow),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            audio.stop();
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                                color: Color(0xff4F4F4F),
                                                shape: BoxShape.circle),
                                            child: Icon(Icons.stop),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "All Category",
                style: TextStyle(
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      if (data < 1) {
                        Fluttertoast.showToast(msg: 'No songs added yet');
                      } else {
                        Get.to(CategorySong(category: 'Hip Hop'));
                      }
                    },
                    child: FutureBuilder<dynamic>(
                        initialData: [],
                        future: getCategoryData("Hip Hop"),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            data = snapshot.data.length;
                            return Container(
                              width: MediaQuery.of(context).size.width / 2.4,
                              height: 100,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image:
                                          AssetImage("asset/image/song.jpg"),
                                      fit: BoxFit.cover)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Hip Hop",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Rubik",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '$data songs',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Rubik",
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            );
                          }
                        }),
                  ),
                  InkWell(
                    onTap: () {
                      if (data < 1) {
                        Fluttertoast.showToast(msg: 'No songs added yet');
                      } else {
                        Get.to(CategorySong(category: 'Rock'));
                      }
                    },
                    child: FutureBuilder<dynamic>(
                        initialData: [],
                        future: getCategoryData("Rock"),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            data = snapshot.data.length;
                            return Container(
                              width: MediaQuery.of(context).size.width / 2.4,
                              height: 100,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: AssetImage("asset/image/rock.jpg"),
                                      fit: BoxFit.cover)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rock",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Rubik",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "$data songs",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Rubik",
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      if (data < 1) {
                        Get.to(CategorySong(category: 'Gospel'));
                      } else {
                        Fluttertoast.showToast(msg: 'No songs added yet');
                      }
                    },
                    child: FutureBuilder<dynamic>(
                        initialData: [],
                        future: getCategoryData("Gospel"),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: RefreshProgressIndicator(),
                            );
                          } else {
                            data = snapshot.data.length;
                            return Container(
                              width: MediaQuery.of(context).size.width / 2.4,
                              height: 100,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image:
                                          AssetImage("asset/image/gospel.jpg"),
                                      fit: BoxFit.cover)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gospel",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Rubik",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "$data songs",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Rubik",
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            );
                          }
                        }),
                  ),
                  InkWell(
                    onTap: () {
                      if (data < 1) {
                        Fluttertoast.showToast(msg: 'No songs added yet');
                      } else {
                        Get.to(CategorySong(category: 'Ragge'));
                      }
                    },
                    child: FutureBuilder<dynamic>(
                        initialData: [],
                        future: getCategoryData("Gospel"),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: RefreshProgressIndicator(),
                            );
                          } else {
                            data = snapshot.data.length;
                            return Container(
                              width: MediaQuery.of(context).size.width / 2.4,
                              height: 100,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image:
                                          AssetImage("asset/image/raggae.jpg"),
                                      fit: BoxFit.cover)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ragge",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Rubik",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${data != null ? data : '0'} songs",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Rubik",
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Play List",
                style: TextStyle(
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Colors.white),
              ),
            ),
            ListTile(
              leading: Container(
                width: 45,
                height: 45,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor.withOpacity(0.7),
                    border: Border.all(width: 2, color: Color(0xff3D3D3D)),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('asset/image/user.webp'),
                        fit: BoxFit.contain)),
              ),


              title: Text(
                "playlist name",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              subtitle: Text(
                "author name",
                style: TextStyle(
                    color: Colors.white, fontFamily: "Rubik", fontSize: 10),
              ),
            ),
            ListTile(
              leading: Container(
                width: 45,
                height: 45,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Color(0xff4F4F4F),
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                    onTap: () {
                      Get.to(AddPlaylist());
                    },
                    child: Icon(
                      Icons.add,
                      size: 40,
                    )),
              ),
              title: Text(
                "Add PlayList",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
