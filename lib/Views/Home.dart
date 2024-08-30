import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunewave/Views/Songs.dart';
import '../Components/Bottomnavbar.dart';
import '../Components/Drawer.dart';
import '../Components/Playlist_Provider.dart';
import '../Components/recent.dart';
import 'Playlist.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  late Timer _timer;
  String greeting = '';

  @override
  void initState() {
    super.initState();
    updateGreeting();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      updateGreeting();
    });
  }

  void updateGreeting() {
    setState(() {
      greeting = getGreeting();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void goToSong(int index) {
    final playlistProvider =
        Provider.of<Playlist_Provider>(context, listen: false);
    playlistProvider.currentSongIndex = index;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Songs()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(
          child: Text(
            "$greeting",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.add_box, color: Colors.white),
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    MediaQuery.of(context).size.width - 150,
                    0.0,
                    0.0,
                    0.0,
                  ),
                  items: [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.add, color: Colors.red),
                        title: Text('Create a new Playlist'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Playlist(
                                    title: "")), // Change this to your page
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(width: 10),
          // Optional spacing between the greeting and the icon
        ],
      ),
      drawer: MyDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple,
              Colors.black,
              Colors.black,
            ],
            begin: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: recent(),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Songs()));
                  },
                ),
                SizedBox(height: 30),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.blue, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Your favorite artists",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Your Playlist",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                Consumer<Playlist_Provider>(
                  builder: (context, playlistProvider, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: playlistProvider.Playlist.length,
                      itemBuilder: (context, index) {
                        final song = playlistProvider.Playlist[index];
                        return ListTile(
                          leading: SizedBox(
                            width: 100.0, // Adjust width as needed
                            height: 300.0, // Adjust height as needed
                            child: Image.asset(
                              song.AlbumArtImagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            song.SongName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0, // Adjust text size as needed
                            ),
                          ),
                          subtitle: Text(
                            song.ArtistName,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18.0, // Adjust text size as needed
                            ),
                          ),
                          onTap: () => goToSong(index),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Bottomnavbar(currentIndex: 0),
    );
  }
}
