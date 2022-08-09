import 'package:flutter/material.dart';
import 'package:tmu_direct/screens/feed/feed.dart';
import 'package:tmu_direct/screens/live/live.dart';
import 'package:tmu_direct/screens/music/music.dart';
import 'package:tmu_direct/screens/podcast/podcast.dart';
import 'package:tmu_direct/screens/profile/profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int currentIndex = 0;

  final screens = [
    Feed(),
    Music(),
    Podcast(),
    Live(),
    Profile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Color(0xff737488),
        selectedLabelStyle: TextStyle(
          fontFamily: "Rubik",
          fontSize: 14,
          fontWeight: FontWeight.w300
        ),

        unselectedLabelStyle: TextStyle(
            fontFamily: "Rubik",
            fontSize: 12,
            fontWeight: FontWeight.w300
        ),
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.feed,size: 30),
              label: "Feed",
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.music_note,size: 30,),
              label: "Music"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.headset_rounded,size: 30),
              label: "Podcast"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.podcasts,size: 30),
              label: "Live"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.person,size: 30),
              label: "Profile"
          ),
        ],
      ),
    );
  }
}
