import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tunewave/Components/Box.dart';
import 'package:tunewave/Views/Home.dart';
import '../Components/Playlist_Provider.dart';

class Songs extends StatelessWidget {
  const Songs({super.key});

  String formatTime(Duration duration) {
    String twoDigitSeconds =
    duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "${duration.inMinutes}:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return Consumer<Playlist_Provider>(
      builder: (BuildContext context, Playlist_Provider value, Widget? child) {
        final playlist = value.Playlist;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (value.currentSongIndex != null &&
              pageController.hasClients &&
              pageController.page != value.currentSongIndex!.toDouble()) {
            pageController.jumpToPage(value.currentSongIndex!);
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Songs",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Home(title: "")));
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: playlist.length,
                    onPageChanged: (index) {
                      value.currentSongIndex = index;
                    },
                    itemBuilder: (context, index) {
                      final currentSong = playlist[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          neo_box(
                            child: Image.asset(
                              currentSong.AlbumArtImagePath,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentSong.SongName,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Text(
                                      currentSong.ArtistName,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Center(
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: playlist.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.green,
                      dotColor: Colors.white,
                      dotHeight: 8.0,
                      dotWidth: 8.0,
                    ),
                    onDotClicked: (index) {
                      pageController.animateToPage(index,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                      value.currentSongIndex = index;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            formatTime(value.currentDuration),
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.shuffle,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.repeat,
                            color: Colors.white,
                          ),
                          Text(
                            formatTime(value.TotalDuration),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                  ),
                  child: Slider(
                    min: 0,
                    max: value.TotalDuration.inSeconds.toDouble(),
                    value: value.currentDuration.inSeconds.toDouble(),
                    activeColor: Colors.green,
                    onChanged: (double double) {},
                    onChangeEnd: (double double) {
                      value.Seek(Duration(seconds: double.toInt()));
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: value.Previous,
                        child: neo_box(
                          child: Icon(
                            Icons.skip_previous,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: value.Pause_Or_Resume,
                        child: neo_box(
                          child: Icon(
                            value.isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: value.NextSong,
                        child: neo_box(
                          child: Icon(
                            Icons.skip_next,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Song {
  final String SongName;
  final String ArtistName;
  final String AlbumArtImagePath;
  final String audiopath;

  Song({
    required this.SongName,
    required this.ArtistName,
    required this.AlbumArtImagePath,
    required this.audiopath,
  });
}