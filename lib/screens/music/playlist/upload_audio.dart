import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tmu_direct/main.dart';
import 'package:tmu_direct/screens/music/music.dart';
import 'package:tmu_direct/services/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../../../services/firestore_methods.dart';
import '../../../widgets/button_widget.dart';

class UploadAudio extends StatefulWidget {
  UploadAudio(
      {required this.title,
      required this.author_name,
      required this.playlist_name,
      required this.category});
  final title;
  final author_name;
  final playlist_name;
  final category;
  @override
  State<UploadAudio> createState() => _UploadAudioState();
}

class _UploadAudioState extends State<UploadAudio> {
  UploadTask? task;
  File? song;
  File? image;

  FireStoreMethods _fireStoreMethods = FireStoreMethods();

  addPlaylist(audio_url, playlist_name) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection("playlists");
    String musicId = const Uuid().v1();
    String playlistId = const Uuid().v1();

    return _collectionRef
        .add({
      "uploadedBy": _auth.currentUser!.displayName,
      "title": widget.title,
      "author_name": widget.author_name,
      "audio_url": audio_url,
      "likes": [],
      'musicId': musicId,
      'datePublished': DateTime.now(),
      "category": widget.category,
      "playlist_name": playlist_name
    }).then((value) => CircularProgress());
  }
  @override
  Widget build(BuildContext context) {
    final songName = song != null ? basename(song!.path) : 'No File Selected';
    final imageName = song != null ? basename(song!.path) : 'No File Selected';

    return Scaffold(
      backgroundColor: Color(0xff1F2123),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Upload Music"),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Got something new to share?",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            SizedBox(
              height: 21,
            ),
            ButtonWidget(
              text: 'Select File',
              icon: Icons.attach_file,
              onClicked: selectFile,
            ),
            SizedBox(
              height: 21,
            ),
            Text(
              songName,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 48),
            ButtonWidget(
              text: 'Upload File',
              icon: Icons.cloud_upload_outlined,
              onClicked: () {
                uploadFile(widget.author_name, widget.title, widget.category, widget.playlist_name);
              },
            ),
            SizedBox(height: 20),
            task != null ? buildUploadStatus(task!) : Container(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: ButtonWidget(
          text: 'Done',
          icon: Icons.attach_file,
          onClicked: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => song = File(path));
  }

  Future uploadFile(author_name, title, category, playlist_name) async {
    if (song == null) return;

    final fileName = basename(song!.path);
    final destination = 'files/$fileName';

    task = StorageMethods.uploadFile(destination, song!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    addPlaylist(urlDownload, playlist_name);

    await _fireStoreMethods.uploadMusicData(
        _auth.currentUser!.displayName, title, author_name, urlDownload, category);
    print('Download-Link: $urlDownload');
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => image = File(path));
  }

  Future uploadImage(author_name, title) async {
    if (image == null) return;

    final imageName = basename(image!.path);
    final destination = 'files/$imageName';

    task = StorageMethods.uploadFile(destination, song!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final imgUrl = await snapshot.ref.getDownloadURL();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    //  await _fireStoreMethods.uploadImage(imgUrl);
    print('Download-Link: $imgUrl');
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
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}

class CircularProgress extends StatefulWidget {
  const CircularProgress({Key? key}) : super(key: key);

  @override
  _CircularProgressState createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      CupertinoPageRoute(
          builder: (_) => Music());
    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>Music()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(height: 5,),
            Text(
              "Uploading...",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
