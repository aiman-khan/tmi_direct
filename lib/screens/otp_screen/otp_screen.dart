import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tmu_direct/screens/new_password/new_password.dart';
import 'package:tmu_direct/widgets/auth_widgets/auth_title.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
                            authtitle("OTP verification"),
                            SizedBox(height: 10,),
                            Text("An OTP will be sent to your email",style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                                color: Color(0xff898989)
                            ),),
                            SizedBox(height: 30,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Form(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: TextField(
                                        cursorColor: Theme.of(context).accentColor,
                                        onChanged: (value){
                                          if(value.length == 1){
                                            FocusScope.of(context).nextFocus();
                                          }
                                        },
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(1),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: TextField(
                                        cursorColor: Theme.of(context).accentColor,
                                        onChanged: (value){
                                          if(value.length == 1){
                                            FocusScope.of(context).nextFocus();
                                          }
                                        },
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(1),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: TextField(
                                        cursorColor: Theme.of(context).accentColor,
                                        onChanged: (value){
                                          if(value.length == 1){
                                            FocusScope.of(context).nextFocus();
                                          }
                                        },
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(1),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: TextField(
                                        cursorColor: Theme.of(context).accentColor,
                                        onChanged: (value){
                                          // if(value.length == 1){
                                          //   FocusScope.of(context).nextFocus();
                                          // }
                                        },
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(1),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 30,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("59s",style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Rubik",
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white
                                  ),),

                                  SizedBox(width: 5,),

                                  TextButton(
                                      onPressed: (){
                                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                                      },
                                      child: Text("Send OTP",style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).accentColor
                                      ),)
                                  )
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NewPassword()));
                                },
                                child: Text("Enter OTP",style: TextStyle(
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