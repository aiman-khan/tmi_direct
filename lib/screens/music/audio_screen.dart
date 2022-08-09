import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tmu_direct/screens/music/songs_list.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  Future getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("music").get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
          initialData: [],
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SongsList(
                                  audioTitle: snapshot.data[index]['title'],
                                  authorName: snapshot.data[index]['author_name'],
                                  songUrl: snapshot.data[index]['audioUrl']))),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(9),
                          child: Text(
                            snapshot.data[index]['title'],
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
