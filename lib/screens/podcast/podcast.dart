import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Podcast extends StatefulWidget {
  const Podcast({Key? key}) : super(key: key);

  @override
  _PodcastState createState() => _PodcastState();
}

class _PodcastState extends State<Podcast> {
  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(
                  fontFamily: "RozhaOne",
                  fontSize: 23
              ),
              children: [
                TextSpan(
                    text: "TMU",
                    style: TextStyle(
                        color: Color(0xffF89009)
                    )
                ),
                TextSpan(
                    text: "DIRECT"
                ),
              ]
          ),
        ),

        actions: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: Color(0xff3D3D3D)
                ),
                shape: BoxShape.circle
            ),

            child: Icon(Icons.headset_rounded,color: Color(0xff3D3D3D),),
          ),
          SizedBox(width: 10,),
          // StreamBuilder(
          //     stream: FirebaseFirestore.instance.collection("users-picture").
          //     doc(FirebaseAuth.instance.currentUser!.email).collection("images").
          //     doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
          //     builder: (BuildContext context, AsyncSnapshot snapshot){
          //       var data = snapshot.data;
          //       if(data==null){
          //         return InkWell(
          //           child: Container(
          //             width: 45,
          //             height: 45,
          //             padding: EdgeInsets.all(2),
          //             decoration: BoxDecoration(
          //               color: Theme.of(context).accentColor.withOpacity(0.7),
          //               border: Border.all(width: 2, color: Color(0xff3D3D3D)),
          //               shape: BoxShape.circle,
          //             ),
          //             child: Icon(Icons.person,size: 50,),
          //           ),
          //         );
          //       }else{
          //         return InkWell(
          //           child: Container(
          //             width: 45,
          //             height: 45,
          //             padding: EdgeInsets.all(2),
          //             decoration: BoxDecoration(
          //                 color: Theme.of(context).accentColor.withOpacity(0.7),
          //                 border: Border.all(width: 2, color: Color(0xff3D3D3D)),
          //                 shape: BoxShape.circle,
          //                 image: DecorationImage(
          //                     image: NetworkImage(data["downloadUrl"]),
          //                     fit: BoxFit.contain)),
          //           ),
          //         );
          //       }
          //     }
          // ),
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
          SizedBox(width: 10,),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Categories",style: TextStyle(
                  fontFamily: "Rubik",
                  fontSize: 18,
                  color: Colors.white
              ),),
            ),
            SizedBox(height: 20,),
            Container(
              height: 45,
              child: FutureBuilder<dynamic>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if (index < 1) {
                              return SizedBox(
                                width: 15,
                              );
                            }
                            return InkWell(
                              child: Container(
                                margin: EdgeInsets.only(right: 15),
                                width: 120,
                                decoration: BoxDecoration(
                                    color: Color(0xffF89009),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                    child: Text(
                                      'Business',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: "Rubik"),
                                    )),
                              ),
                            );
                          });
                    }
                  }),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 210,
                      childAspectRatio: 3 / 5.2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15
                  ),
                  itemBuilder: (context,index){
                    return Container(
                      width: MediaQuery.of(context).size.width/2,
                      //margin: EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xff1C1F23)
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('asset/image/song.png')
                                )
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Ney",style: TextStyle(
                                        fontFamily: "Rubik",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white
                                    ),),
                                    SizedBox(height: 10,),
                                    Text("Hazan Mevsimi",style: TextStyle(
                                        fontFamily: "Rubik",
                                        fontSize: 10,
                                        color: Color(0xff828282)
                                    ),),
                                    SizedBox(height: 10,),

                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: (){},
                                            icon: Icon(Icons.thumb_up,color: Color(0xffF85F55),size: 20,
                                            )
                                        ),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.thumb_down,color: Color(0xff4F4F4F),size: 20)),
                                      ],
                                    )
                                  ],
                                ),
                                InkWell(
                                  onTap: (){},
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: Color(0xff4F4F4F),
                                        shape: BoxShape.circle
                                    ),

                                    child: Icon(Icons.play_arrow),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("music")
        .orderBy("datePublished", descending: true)
        .get();
    return querySnapshot.docs;
  }}
