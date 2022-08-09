import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tmu_direct/services/response.dart';
import '../../services/firestore_methods.dart';

class MakePost extends StatefulWidget {
  const MakePost({Key? key}) : super(key: key);

  @override
  _MakePostState createState() => _MakePostState();
}

class _MakePostState extends State<MakePost> {
  Response _response = Response();
  TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void uploadPost(String uid, String username, String profImage) async {
    String first_name = "";
    String last_name = "";

    setState(() {
      isLoading = true;
    });
    // start the loading
    try {

      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        uid,
        _auth.currentUser!.displayName,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'Posted!');
      } else {
        Fluttertoast.showToast(msg: res);

      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Make A Post",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FlatButton(
                color: Theme.of(context).accentColor,
                height: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(5)),
                onPressed: () {
                  if (_descriptionController.text.isNotEmpty) {
                    uploadPost(_auth.currentUser!.uid, "", "" );
                    _response.successAlertDialog(context,
                        desc: 'Your post has been uploaded.',
                        title: 'Success');
                  }
                },
                child: Text(
                  "POST",
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              style: TextStyle(color: Colors.white, fontFamily: "Rubik"),
              maxLength: 1000,
              maxLines: 50,
              controller: _descriptionController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                filled: true,
                border: InputBorder.none,
                hintText: "What is in your mind ?",
                hintStyle: TextStyle(
                    color: Color(0xff828282),
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
          ),
          // Expanded(
          //   flex: 1,
          //     child: Container(
          //       child: Stack(
          //         children:[
          //           AssetImage("",fit: BoxFit.contain,),
          //           Positioned(
          //             top: 10,
          //               right: 10,
          //               child: GestureDetector(
          //                 onTap: (){
          //
          //                 },
          //                 child: Container(
          //                   width: 40,
          //                   height: 40,
          //                   padding: EdgeInsets.all(10),
          //                   decoration: BoxDecoration(
          //                     shape: BoxShape.circle,
          //                     color: Colors.black.withOpacity(0.7)
          //                   ),
          //                   child: Icon(Icons.close,color: Colors.white,size: 20,),
          //                 ),
          //               )
          //           )
          //         ]
          //       ),
          //     )
          // ),

          Container(
            height: 70,
            padding: EdgeInsets.all(10),
            color: Color(0xff1C1F23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Icon(Icons.photo, color: Theme.of(context).accentColor),
                      Text("Image",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                InkWell(
                  child: Column(
                    children: [
                      Icon(
                        Icons.video_camera_back,
                        color: Theme.of(context).accentColor,
                      ),
                      Text(
                        "Video",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
