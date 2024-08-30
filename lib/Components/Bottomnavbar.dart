import 'package:flutter/material.dart';
import '../Views/Home.dart';
import '../Views/Library.dart';
import '../Views/Playlist.dart';
import '../Views/Search.dart';

class Bottomnavbar extends StatefulWidget {
  final int currentIndex;
  const Bottomnavbar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(title: "Home page"),
        ),
      );
    }
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Search(title: "Search"),
        ),
      );
    }
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Library(
            title: "Library",
            playlist: PlaylistModel(name: "Default Playlist"),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: _onItemTapped,
      currentIndex: _currentIndex,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music_sharp),
          label: "Your library",
        ),
      ],
    );
  }
}
