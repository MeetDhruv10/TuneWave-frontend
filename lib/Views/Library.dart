import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/Bottomnavbar.dart';
import '../Components/Playlist_Provider.dart';
import 'Playlist.dart';
import 'Songs.dart';

class Library extends StatefulWidget {
  const Library({super.key, required this.title, required this.playlist});

  final String title;
  final PlaylistModel playlist;

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final searchController = TextEditingController();
  int myIndex = 2;

  void goToSong(int index) {
    final playlistProvider = Provider.of<Playlist_Provider>(context, listen: false);
    playlistProvider.currentSongIndex = index;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Songs()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Library",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //PlaylistCard(playlist: widget.playlist), // Use the passed playlist
          Consumer<Playlist_Provider>(
            builder: (context, playlistProvider, child) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: playlistProvider.Playlist.length,
                itemBuilder: (context, index) {
                  final song = playlistProvider.Playlist[index];
                  return ListTile(
                    leading: Image.asset(song.AlbumArtImagePath),
                    title: Text(song.SongName, style: TextStyle(color: Colors.white)),
                    subtitle: Text(song.ArtistName, style: TextStyle(color: Colors.white70)),
                    onTap: () => goToSong(index),
                  );
                },
              );
            },
          ),
        ],
      ),
    bottomNavigationBar: Bottomnavbar(currentIndex:2),
    );
  }
}