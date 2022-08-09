import 'package:flutter/material.dart';
import 'package:tmu_direct/screens/login/login.dart';
import 'package:tmu_direct/screens/otp_screen/otp_screen.dart';
import 'package:tmu_direct/widgets/auth_widgets/auth_input_form.dart';
import 'package:tmu_direct/widgets/auth_widgets/auth_title.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController emailcontroller = TextEditingController();

  bool obsecureText = true;

  bool _value = false;

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
                            authtitle("Forgot Password"),
                            SizedBox(height: 10,),
                            Text("Enter the email you used to register",style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                                color: Color(0xff898989)
                            ),),
                            SizedBox(height: 20,),
                            customTextField("Email", TextInputType.emailAddress, emailcontroller, false, null),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Remember your password ?",style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: "Rubik",
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white
                                  ),),
                                  TextButton(
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                                      },
                                      child: Text("Sign in",style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).accentColor
                                      ),)
                                  )
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
                                minWidth: double.maxFinite,
                                color: Theme.of(context).accentColor,
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen()));
                                },
                                child: Text("Reset Password",style: TextStyle(
                                    fontFamily: "Rubik",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                ),),
                              ),
                            ),

                            SizedBox(height: 20,),
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