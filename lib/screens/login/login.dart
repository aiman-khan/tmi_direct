import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tmu_direct/screens/dashboard/dashboard.dart';
import 'package:tmu_direct/screens/forgot_password/forgot_password.dart';
import 'package:tmu_direct/screens/registration/register.dart';
import 'package:tmu_direct/screens/ss.dart';
import 'package:tmu_direct/widgets/auth_widgets/auth_input_form.dart';
import 'package:tmu_direct/widgets/auth_widgets/auth_title.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  bool showSpinner = false;

  bool obsecureText = true;

  logIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailcontroller.text, password: _passwordcontroller.text);

      var authCredential = userCredential.user;
      print(authCredential!.uid);
      if (authCredential.uid.isNotEmpty) {

        setState(() {
          showSpinner = false;
        });
        print('Signing you in.');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Temp()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {

        setState(() {
          showSpinner = false;
        });
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {

        setState(() {
          showSpinner = false;
        });
        print('Wrong password provided for that user.');
      }
    } catch (e) {

      setState(() {
        showSpinner = false;
      });
      print("$e some error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F2123),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          color: Theme.of(context).accentColor,
        ),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('asset/image/backgroundlayertwo.png'))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  ClipPath(
                    clipper: WaveClipper(),
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
                                authtitle("Welcome to Tmudirect"),
                                SizedBox(
                                  height: 20,
                                ),
                                customTextField(
                                    "Email",
                                    TextInputType.emailAddress,
                                    _emailcontroller,
                                    false,
                                    null),
                                customTextField(
                                    "Password",
                                    TextInputType.text,
                                    _passwordcontroller,
                                    obsecureText,
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obsecureText = !obsecureText;
                                          });
                                        },
                                        icon: Icon(
                                          obsecureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context).accentColor,
                                        ))),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ForgotPassword()));
                                          },
                                          child: Text(
                                            "Forgot Password",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ))
                                    ],
                                  ),
                                ),
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
                                      setState(() {
                                        showSpinner = true;
                                      });
                                      logIn();
                                    },
                                    child: Text(
                                      "Sign in",
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
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width /
                                            2.5,
                                        child: Divider(
                                          height: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "Or",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width /
                                            2.5,
                                        child: const Divider(
                                          height: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                                    color: Colors.white,
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Image(
                                          image: AssetImage(
                                              "asset/image/google.png"),
                                          width: 25,
                                          height: 25,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Sign in with Google",
                                          style: TextStyle(
                                            fontFamily: "Rubik",
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don’t Have an Account ?",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Register()));
                                        },
                                        child: Text(
                                          "Sign up",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Theme.of(context).accentColor),
                                        ))
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
