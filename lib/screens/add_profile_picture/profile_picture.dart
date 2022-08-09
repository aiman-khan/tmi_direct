import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tmu_direct/screens/dashboard/dashboard.dart';
import 'package:tmu_direct/widgets/auth_widgets/auth_title.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({Key? key}) : super(key: key);


  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();



  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }


  // upload image to firbase storage
  Future uploadImage() async{

    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'Profilepics';

    //final postID = DateTime.now().microsecondsSinceEpoch.toString();

    Reference ref = firebase_storage.FirebaseStorage.instance.
    ref(destination).
    child("${_auth.currentUser?.email}/images").
    child(fileName);
    print(ref);

    ref.putFile(_photo!);

    String downloadUrl = await ref.getDownloadURL();

    // uploading cloud firestore database
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore.collection("users-picture")
        .doc(_auth.currentUser?.email).
    collection("images").doc(_auth.currentUser?.uid).
    set({"downloadUrl": downloadUrl});
  }


  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F2123),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('asset/image/backgroundlayertwo.png')
              )
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //SizedBox(height: 80,),
              ClipPath(
                clipper:WaveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height/1.1,
                  width: double.infinity,
                  color: Color(0xff27292D),

                  child: ClipPath(
                    clipper: WaveClippertwo(),
                    child: Container(
                      height: MediaQuery.of(context).size.height/1.1,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,

                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 50,),
                            Image(image: AssetImage("asset/image/logo.png",),width: 150,height: 150,),
                            SizedBox(height: 20,),
                            authtitle("Add Profile Picture"),
                            SizedBox(height: 30,),

                            GestureDetector(
                              onTap: (){
                                _showPicker(context);
                              },
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).accentColor.withOpacity(0.4),
                                radius: 80,
                                child: _photo != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    _photo!,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ) : Icon(Icons.camera_alt,size: 100,color: Theme.of(context).accentColor,),
                              ),
                            ),

                            SizedBox(height: 30,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: FlatButton(
                                height: 50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                minWidth: double.maxFinite,
                                color: Theme.of(context).accentColor,
                                onPressed: (){
                                  if(_photo != null){
                                    uploadImage();
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context)=>Dashboard()));
                                  }
                                },
                                child: Text("Add Profile Picture",style: TextStyle(
                                    fontFamily: "Rubik",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                ),),
                              ),
                            ),

                            SizedBox(height: 20,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Wants to add later?",style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Rubik",
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white
                                ),),

                                TextButton(
                                    onPressed: (){

                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context)=>Dashboard()));
                                    },
                                    child: Text("SKIP",style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).accentColor
                                    ),)
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void _showPicker(context) {
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: 70,
        padding: EdgeInsets.all(10),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: (){
                imgFromCamera();
                Navigator.of(context).pop();
              },
              child: Column(
                children: [
                  Icon(Icons.camera_alt,color: Theme.of(context).accentColor,),
                  Text("Camera",style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w500
                  ),)
                ],
              ),
            ),

            InkWell(
              onTap: (){
                imgFromGallery();
                Navigator.of(context).pop();
              },
              child: Column(
                children: [
                  Icon(Icons.photo,color: Theme.of(context).accentColor),
                  Text("Gallery",style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w500
                  ))
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}


class WaveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    debugPrint(size.width.toString());

    var path = new Path();
    path.lineTo(0, 100); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, 110);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), -30);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, 30);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);//end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}


class WaveClippertwo extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    debugPrint(size.width.toString());

    var path = new Path();
    path.lineTo(0, 100); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, 110);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), 0);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, 70);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);//end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}