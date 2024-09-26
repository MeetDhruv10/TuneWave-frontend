import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

import '../Views/Songs.dart';

class Playlist_Provider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      SongName: "Kesariya",
      ArtistName: "Arijit Singh",
      AlbumArtImagePath: "assets/images/bam.png",
      audiopath: "https://tunewave-artists-image.s3.ap-south-1.amazonaws.com/Songs/Kesriya-1727207101627.mp3", // Use S3 URL
    ),
    Song(
      SongName: "Khol De Par",
      ArtistName: "Arijit Singh",
      AlbumArtImagePath: "assets/images/Khol.png",
      audiopath: "https://tunewave-artists-image.s3.ap-south-1.amazonaws.com/Songs/Khol-de-par-1726568323719.mp3", // Use S3 URL
    ),
  ];

  int? _currentSongIndex;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _TotalDuration = Duration.zero;

  Playlist_Provider() {
    ListenToDuration();
  }

  bool _isPlaying = false;

  void Play() async {
    if (_currentSongIndex != null) {
      final String url = _playlist[_currentSongIndex!].audiopath;
      print("Streaming song from: $url");
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url)); // Change to UrlSource for streaming
      _isPlaying = true;
      notifyListeners();
    }
  }

  void Pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void Resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void Pause_Or_Resume() async {
    if (_isPlaying) {
      Pause();
    } else {
      Resume();
    }
    notifyListeners();
  }

  void Seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void NextSong() async {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        _currentSongIndex = _currentSongIndex! + 1;
      } else {
        _currentSongIndex = 0;
      }
      Play();
    }
  }

  void Previous() async {
    if (_currentSongIndex != null) {
      if (_currentDuration.inSeconds > 2) {
        Seek(Duration.zero);
      } else {
        if (_currentSongIndex! > 0) {
          _currentSongIndex = _currentSongIndex! - 1;
        } else {
          _currentSongIndex = _playlist.length - 1;
        }
        Play();
      }
    }
  }

  void ListenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _TotalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      NextSong();
    });
  }

  List<Song> get Playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get TotalDuration => _TotalDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      Play();
    }
    notifyListeners();
  }
}
