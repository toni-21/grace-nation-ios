import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/auidio_track.dart';

enum PlaybackStatus {
  playing,
  loading,
  idle,
}

enum PlaybackMode {
  loop,
  repeat,
  normal,
}

class AudioProvider extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();

  //Player values
  PlaybackMode playbackMode = PlaybackMode.normal;
  PlaybackStatus status = PlaybackStatus.idle;
  bool _isPlaying = false;
  bool isLoaded = false;
  bool _isShuffled = false;
  Duration _currentDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  //PLalist values
  List<AudioTrack> playlist = [];
  List<AudioTrack>? _tempTracks;
  int currentPlaylistIndex = 0;
  int playingIndex = -1;
  AudioTrack? _currentTrack;

  //Stream Subscriptions
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateChangeSubscription;
  StreamSubscription? _playerCompleteSubscription;

  bool get isLoop => playbackMode == PlaybackMode.loop;
  bool get isRepeat => playbackMode == PlaybackMode.repeat;
  bool get isNormal => playbackMode == PlaybackMode.normal;
  bool get isShuffled => _isShuffled;
  bool get isPlaying => _isPlaying;

  Duration get currentDuration => _currentDuration;
  Duration get currentPostion => _currentPosition;

  AudioProvider() {
    print("Initializing player!!!");
    _playerStateChangeSubscription =
        audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _playerCompleteSubscription = audioPlayer.onPlayerComplete.listen((event) {
      _currentPosition = Duration.zero;
      audioPlayer.state = PlayerState.stopped;
      if (playbackMode == PlaybackMode.loop) {
        playPlayList();
      } else {
        if (playbackMode == PlaybackMode.repeat) {
          if (currentPlaylistIndex == playlist.length - 1) {
            currentPlaylistIndex = 0;

            playPlayList();
          } else {
            nextAudio();
          }
        } else {
          if (currentPlaylistIndex == playlist.length - 1) {
            print('provider side completed');
            stop();
            return;
          } else {
            nextAudio();
          }
        }

        notifyListeners();
      }
    });

    _durationSubscription = audioPlayer.onDurationChanged.listen((newDuration) {
      _currentDuration = newDuration;
    });

    _positionSubscription = audioPlayer.onPositionChanged.listen((newPosition) {
      _currentPosition = newPosition;
    });
  }

  AudioTrack get currentTrack {
    return _currentTrack!;
  }

  void disposePlayer() {
    stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    audioPlayer.dispose();
    notifyListeners();
  }

  void addToPlaylist(AudioTrack track) {
    playlist.add(track);
    print("The file ${track.title} was added to the playlist");
    notifyListeners();
  }

  Future<void> setPlaylist(List<AudioTrack> p) async {
    playlist = p;
    notifyListeners();
  }

  Future<void> setCurrentTrack(AudioTrack a) async {
    _currentTrack = a;
    notifyListeners();
  }

  Future<void> selectCurrentIndex(int i) async {
    currentPlaylistIndex = i;
    notifyListeners();
  }

  Future<void> playPlayList() async {
    print("Trying to play!!");
    if (currentPlaylistIndex < 0 ||
        currentPlaylistIndex > playlist.length - 1 ||
        playlist.isEmpty) {
      print("something went wrong");
      print("playlistlegnth ..${playlist.length}");
      print("curremtindex ..$currentPlaylistIndex");
      return;
    }

    status = PlaybackStatus.loading;
    _currentTrack = playlist[currentPlaylistIndex];
    print("playlistlegnth ..${playlist.length}");
    print("curremtindex ..$currentPlaylistIndex");
    print("currentTrack is... ..${currentTrack.title}");
    notifyListeners();
    if (playingIndex != currentPlaylistIndex) {
      // if (_isPlaying) await stop();

      await audioPlayer.play(DeviceFileSource(
        playlist[currentPlaylistIndex].source,
      ));
    } else {
      playingIndex = currentPlaylistIndex;
    }
    _isPlaying = true;
    status = PlaybackStatus.playing;
    notifyListeners();
  }

  Future<void> stop({bool temp = false}) async {
    await audioPlayer.stop();
    await audioPlayer.release();
    _isPlaying = false;
    playbackMode = PlaybackMode.normal;
    status = PlaybackStatus.idle;
    audioPlayer.state = PlayerState.stopped;
    _currentDuration = Duration.zero;
    _currentPosition = Duration.zero;
    notifyListeners();
  }

  Future<void> resume() async {
    if (playlist.isEmpty) return;
    await audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> pause() async {
    if (playlist.isEmpty) return;
    await audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void setPlaybackMode(PlaybackMode mode) {
    playbackMode = mode;
    notifyListeners();
  }

  Future<void> seekPosition(Duration position) async {
    await audioPlayer.seek(position);
    _currentPosition = position;
    notifyListeners();
  }

  Future<void> nextAudio() async {
    //stop();
    if (currentPlaylistIndex >= playlist.length - 1) return;
    currentPlaylistIndex = currentPlaylistIndex + 1;
    notifyListeners();
    playPlayList();
  }

  Future<void> prevAudio() async {
    //stop();
    if (currentPlaylistIndex == 0) return;
    currentPlaylistIndex = currentPlaylistIndex - 1;
    notifyListeners();
    playPlayList();
  }

  // void cyclePlaybackMode() {
  //   switch (playbackMode) {
  //     case PlaybackMode.normal:
  //       playbackMode = PlaybackMode.shuffle;
  //       playlist.shuffle();
  //       break;
  //     case PlaybackMode.shuffle:
  //       playbackMode = PlaybackMode.repeat;
  //       playlist.sort();
  //       break;
  //     case PlaybackMode.repeat:
  //       playbackMode = PlaybackMode.normal;
  //       break;
  //   }
  //   notifyListeners();
  // }

  bool shuffle() {
    // won't shuffle if already shuffled
    if (_tempTracks == null) {
      _tempTracks = [...playlist];
      print("playlist copied");

      playlist.shuffle();
      print("shuffled playlist is ${playlist.toString()}");
      _isShuffled = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool unshuffle() {
    // without _tempTracks unshuffling can't be done
    if (_tempTracks != null) {
      playlist = [..._tempTracks!];
      _tempTracks = null;
      print("playlist destroyed");
      _isShuffled = false;
      print("current playlist is ${playlist.toString()}");
      notifyListeners();
      return true;
    }
    return false;
  }
}
