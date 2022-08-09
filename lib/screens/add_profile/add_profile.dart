import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tmu_direct/screens/add_profile_picture/profile_picture.dart';
import 'package:tmu_direct/services/auth.dart';
import 'package:tmu_direct/widgets/auth_widgets/auth_input_form.dart';
import 'package:tmu_direct/widgets/auth_widgets/auth_title.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({Key? key}) : super(key: key);

  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool obscureText = true;

  sendUserdataDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users_data");
    String displayName =  firstnameController.text + " " +  lastnameController.text;

    await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);

    print("name $displayName");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "first_name": firstnameController.text,
          "last_name": lastnameController.text,
          "bio": "",
          "followers": [],
          "following": []
        })
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePicture())))
        .catchError((error) => print("something is wrong. $error"));
  }

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
                  image: AssetImage('asset/image/backgroundlayertwo.png'))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //SizedBox(height: 80,),
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.1,
                  width: double.infinity,
                  color: Color(0xff27292D),
                  child: ClipPath(
                    clipper: WaveClippertwo(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.1,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Image(
                              image: AssetImage(
                                "asset/image/logo.png",
                              ),
                              width: 150,
                              height: 150,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            authtitle("Add Profile Details"),
                            SizedBox(
                              height: 20,
                            ),
                            customTextField("Firstname", TextInputType.text,
                                firstnameController, false, null),
                            customTextField("Lastname", TextInputType.text,
                                lastnameController, false, null),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: FlatButton(
                                height: 50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                minWidth: double.maxFinite,
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  // Auth().addUserDatatoDb(
                                  //     email: _auth.currentUser?.email,
                                  //    first_name: firstnameController.text,
                                  //     last_name: lastnameController.text, bio: '',
                                  //     file: );
                                  sendUserdataDB();

                                },
                                child: Text(
                                  "Add Profile",
                                  style: TextStyle(
                                      fontFamily: "Rubik",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
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
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());

    var path = new Path();
    path.lineTo(0, 100); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, 110);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), -30);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, 30);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(
        0, size.height); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}

class WaveClippertwo extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());

    var path = new Path();
    path.lineTo(0, 100); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, 110);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), 0);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, 70);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(
        0, size.height); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}
