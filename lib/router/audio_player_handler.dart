import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:grace_nation/core/providers/audio_provider.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioProvider audioProvider;

  @override
  AudioPlayerHandler(this.audioProvider) {
    playbackState.add(playbackState.value.copyWith(
      controls: [MediaControl.play],
      //processingState: AudioProcessingState.loading,
    ));

    final player = audioProvider.audioPlayer;

    player.onPlayerStateChanged.listen((state) async {
      if (state != PlayerState.completed) {
        playbackState.add(await _transformEvent());
      }
    });

    player.onPositionChanged.listen((pos) async {
      playbackState.add(await _transformEvent());
    });

    player.onPlayerComplete.listen((_) {
  
      if (audioProvider.playlist.isEmpty) {
        playbackState.add(
          PlaybackState(
            processingState: AudioProcessingState.completed,
          ),
        );
      }
    });

    audioProvider.playPlayList().then((value) => null).then((_) {
      // Broadcast that we've finished loading
      playbackState.add(playbackState.value
          .copyWith(processingState: AudioProcessingState.ready));
    });

    // player.play(DeviceFileSource( audioProvider.   )).then((_) {
    //   // Broadcast that we've finished loading
    //   playbackState.add(playbackState.value
    //       .copyWith(processingState: AudioProcessingState.ready));
    // });

    //_player.setUrl("https://exampledomain.com/song.mp3");
  }

  // @override
  // Future<void> play() => audioProvider.resume();

  @override
  Future<void> play() async {
    // playbackState.add(playbackState.value.copyWith(
    //   playing: true,
    //   controls: [MediaControl.pause],
    // ));

    audioProvider.audioPlayer.state == PlayerState.stopped
        ? await audioProvider.playPlayList()
        : 
        await audioProvider.resume();
  }

  @override
  Future<void> pause() async {
    // playbackState.add(playbackState.value.copyWith(
    //   playing: false,
    //   controls: [MediaControl.play],
    // ));
    await audioProvider.pause();
  }

  @override
  Future<void> seek(Duration position) => audioProvider.seekPosition(position);

  @override
  Future<void> stop() async {
    //await session?.setActive(true);
    await audioProvider.stop();
    playbackState.add(
      PlaybackState(
        processingState: AudioProcessingState.completed,
      ),
    );
  }

  @override
  Future<void> skipToNext() async {
    audioProvider.nextAudio();
    await super.skipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    audioProvider.prevAudio();
    await super.skipToPrevious();
  }

  Future<PlaybackState> _transformEvent() async {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        audioProvider.audioPlayer.state == PlayerState.playing
            ? MediaControl.pause
            : MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: {
        MediaAction.seek,
      },
      androidCompactActionIndices: const [0, 1, 2],
      playing: audioProvider.audioPlayer.state == PlayerState.playing,
      updatePosition: (await audioProvider.audioPlayer.getCurrentPosition()) ??
          Duration.zero,
      processingState: audioProvider.audioPlayer.state == PlayerState.paused
          ? AudioProcessingState.buffering
          : audioProvider.audioPlayer.state == PlayerState.playing
              ? AudioProcessingState.ready
              : AudioProcessingState.completed,
    );
  }
}
