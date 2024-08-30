import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import '../Views/Songs.dart';


class Playlist_Provider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
        SongName: "Kesariya",
        ArtistName: "Arijit Singh",
        AlbumArtImagePath: "assets/images/bam.png",
        audiopath: "audio/kesariya.mp3"),
    Song(
        SongName: "Ehehhe",
        ArtistName: "Lol Singh",
        AlbumArtImagePath: "assets/images/logo.png",
        audiopath: "audio/khol.mp3"),
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
    final String path = _playlist[_currentSongIndex!].audiopath;
    print("Playing song from: $path");
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  void Pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
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
    } else {
      _currentSongIndex = 0;
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
    } else {
      _currentSongIndex = _playlist.length - 1;
      Play();
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
