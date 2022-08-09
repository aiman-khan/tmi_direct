import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tmu_direct/screens/add_profile/add_profile.dart';
import 'package:tmu_direct/screens/login/login.dart';
import 'package:tmu_direct/services/auth.dart';
import 'package:tmu_direct/widgets/auth_widgets/auth_input_form.dart';
import 'package:tmu_direct/widgets/auth_widgets/auth_title.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;

  bool obsecureText = true;
bool showSpinner = false;
  bool _value = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  register()async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
      );
      var authCredential = userCredential.user;

      print(authCredential!.uid);
      if(authCredential.uid.isNotEmpty){
        Navigator.push(context, CupertinoPageRoute(builder: (_)=>AddProfile()));
        Fluttertoast.showToast(msg: "Registration complete");
      }
      else{
        Fluttertoast.showToast(msg: "Something went wrong");
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      showSpinner = true;
    });

    // signup user using our authmethodds
    String res = await Auth().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
    );
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        showSpinner = false;
      });
      // navigate to the home screen
      Navigator.push(context, CupertinoPageRoute(builder: (_)=>AddProfile()));
      Fluttertoast.showToast(msg: "Registration complete");
    } else {
      setState(() {
        showSpinner = false;
      });
      // show the error
      Fluttertoast.showToast(msg: res);
    }
  }
  selectImage() async {
    try {
      var photo = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      File imageFile = File(photo!.path);
      Uint8List imageRaw = await imageFile.readAsBytes();
      return imageRaw;
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F2123),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('asset/image/backgroundlayertwo.png')
              )
            ),

            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 80,),
                  ClipPath(
                    clipper:WaveClipper(),
                    child: Container(
                      //height: MediaQuery.of(context).size.height/1.1,
                      width: double.infinity,
                      color: Color(0xff27292D),

                      child: ClipPath(
                        clipper: WaveClippertwo(),
                        child: Container(
                          //height: MediaQuery.of(context).size.height/1.1,
                          width: double.infinity,
                          color: Theme.of(context).primaryColor,

                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 50,),
                                Image(image: AssetImage("asset/image/logo.png",),width: 150,height: 150,),
                                SizedBox(height: 20,),
                                authtitle("Create new account"),
                                SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                        width: double.maxFinite,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Color(0xff1E1E1E),
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        child: TextField(
                                          controller: _emailController,
                                          keyboardType: TextInputType.emailAddress,

                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Rubik"
                                          ),
                                          cursorColor: Color(0xffF89009),
                                          decoration: InputDecoration(
                                              hintText: "Email",
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Color(0xff828282),
                                                  fontFamily: "Rubik"
                                              ),
                                              border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                        width: double.maxFinite,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Color(0xff1E1E1E),
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        child: TextField(
                                          controller: _passwordController,
                                          keyboardType: TextInputType.text,

                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Rubik"
                                          ),
                                          obscureText: obsecureText,
                                          cursorColor: Color(0xffF89009),
                                          decoration: InputDecoration(
                                            hintText: "Password",
                                            hintStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Color(0xff828282),
                                                fontFamily: "Rubik"
                                            ),
                                            border: InputBorder.none,
                                            suffixIcon: IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    obsecureText = !obsecureText;
                                                  });
                                                },
                                                icon: Icon(obsecureText ?Icons.visibility:Icons.visibility_off,color: Theme.of(context).accentColor,)
                                            )
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 20,),


                                ListTile(
                                  horizontalTitleGap: 0,
                                  leading: Checkbox(
                                    value: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = !_value;
                                      });
                                    },
                                  ),

                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("By creating an account, you agree to the Miruum",style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: "Rubik",
                                        color: Colors.white
                                      ),),
                                      TextButton(onPressed: (){}, child: Text('Terms & Condition and Privacy Policy',style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: "Rubik",
                                          color: Theme.of(context).accentColor
                                      ),))
                                    ],
                                  ),
                                ),

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
                                      if(_value == true){
                                        signUpUser();
                                      }else{
                                        Fluttertoast.showToast(msg: "Agree to the terms and conditions first");
                                      }
                                    },
                                    child: Text("Sign up",style: TextStyle(
                                      fontFamily: "Rubik",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                    ),),
                                  ),
                                ),

                                SizedBox(height: 20,),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width/2.5,
                                        child: Divider(
                                          height: 2,
                                          color: Colors.white,
                                        ),
                                      ),

                                      Text("Or",style: TextStyle(
                                        color: Colors.white
                                      ),),

                                      Container(
                                        width: MediaQuery.of(context).size.width/2.5,
                                        child: Divider(
                                          height: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 20,),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: FlatButton(
                                    height: 50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    color: Colors.white,
                                    onPressed: (){},
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image(
                                            image: AssetImage("asset/image/google.png"),
                                          width: 25,
                                          height: 25,
                                        ),
                                        SizedBox(width: 10,),
                                        Text("Sign up with Google",style: TextStyle(
                                            fontFamily: "Rubik",
                                            fontSize: 16,
                                        ),)
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20,),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Aready have an account?",style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Rubik",
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white
                                    ),),

                                    TextButton(
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                                        },
                                        child: Text("Sign in",style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).accentColor
                                    ),))
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
        ),
      ),
    );
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