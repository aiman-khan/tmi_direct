import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SongsList extends StatefulWidget {
  String audioTitle, authorName, songUrl;
  SongsList(
      {required this.audioTitle,
      required this.authorName,
      required this.songUrl});

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  @override
  Widget build(BuildContext context) {
    AudioPlayer audio = AudioPlayer();

    return Scaffold(
      appBar: AppBar(
        title: Text('Play'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 33,
              ),
              Text(
                "Title",
                style: TextStyle(
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              Text(widget.audioTitle),
              Text(
                "Author Name",
                style: TextStyle(
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              Text(widget.authorName),
              Card(
                  child: Image(
                image: AssetImage('asset/image/logo.png'),
              )),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                  ),
                  Expanded(
                      child: FlatButton(
                    onPressed: () {
                      audio.play(DeviceFileSource(widget.songUrl));

                    },
                    child: Icon(Icons.play_arrow, size: 30,),
                  )),
                  Expanded(
                      child: FlatButton(
                        onPressed: () {
                      audio.stop();
                        },
                        child: Icon(Icons.stop, size: 30,),
                      )),
                  SizedBox(
                    width: 100,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
