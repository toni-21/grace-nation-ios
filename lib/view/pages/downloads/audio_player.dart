import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/providers/audio_provider.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/infinite_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AudioPlayerState();
  }
}

class _AudioPlayerState extends State<AudioPlayerWidget>
    with AutomaticKeepAliveClientMixin<AudioPlayerWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AudioProvider>(context, listen: false).playPlayList();
    });
    returnNowPlayingState();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void returnNowPlayingState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(audioClickKey, false);
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  String formatTrackDate(DateTime date) {
    final month = DateFormat.LLLL().format(date);
    return "$month ${date.day}, ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context, listen: false);
    super.build(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBarWidget(
          actionScreen: true,
          appBar: AppBar(),
          title: "Now Playing",
        ),
        body: StreamBuilder<PlaybackState>(
          stream: Provider.of<AppProvider>(context, listen: true)
              .audioHandler
              .playbackState,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            final audioHandler =
                Provider.of<AppProvider>(context, listen: true).audioHandler;

            final position = Provider.of<AudioProvider>(context, listen: true)
                .currentPostion;
            final duration = Provider.of<AudioProvider>(context, listen: true)
                .currentDuration;

            final isPlaying = snapshot.data?.playing ?? false;
            final processingState =
                snapshot.data?.processingState ?? AudioProcessingState.idle;

            return Padding(
              padding:
                  EdgeInsets.only(top: 30, bottom: 45, right: 30, left: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          height: 200,
                          width: 200,
                          margin: EdgeInsets.only(top: 16.4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image:
                                  AssetImage('assets/images/Illustrations.png'),
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: InfiniteAnimation(
                        durationInSeconds: 12,
                        isPlaying: isPlaying,
                        child: Container(
                          height: 232,
                          width: 232,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: babyBlue,
                              width: 5,
                            ),
                          ),
                          child: Stack(children: [
                            Positioned(
                              left: 52,
                              bottom: 0,
                              child: Icon(
                                Icons.circle,
                                size: 18,
                                color: babyBlue,
                              ),
                            )
                          ]),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: 25),
                  Text(
                    // 'How to flourish the way God has designed it kdjfnvkjnjmlkdnf',
                    audioProv.currentTrack.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      //  color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    //"October 1st, 2022",
                    formatTrackDate(audioProv.currentTrack.date),
                    style: TextStyle(
                        color: darkGray,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Row(

                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 5),
                          IconButton(
                            onPressed: () {
                              if (Provider.of<AudioProvider>(context,
                                          listen: false)
                                      .playbackMode ==
                                  PlaybackMode.normal) {
                                audioProv.setPlaybackMode(PlaybackMode.loop);
                              } else if (Provider.of<AudioProvider>(context,
                                          listen: false)
                                      .playbackMode ==
                                  PlaybackMode.loop) {
                                audioProv.setPlaybackMode(PlaybackMode.repeat);
                              } else {
                                audioProv.setPlaybackMode(PlaybackMode.normal);
                              }
                            },
                            icon: Provider.of<AudioProvider>(context)
                                        .playbackMode ==
                                    PlaybackMode.loop
                                ? Icon(
                                    Icons.repeat_one_rounded,
                                    color: babyBlue,
                                    size: 36,
                                  )
                                : Provider.of<AudioProvider>(context)
                                            .playbackMode ==
                                        PlaybackMode.repeat
                                    ? Icon(
                                        Icons.repeat_rounded,
                                        color: babyBlue,
                                        size: 36,
                                      )
                                    : Icon(
                                        Icons.repeat_rounded,
                                        color: darkGray.withOpacity(0.5),
                                        size: 36,
                                      ),
                            padding: EdgeInsets.zero,
                          ),
                          IconButton(
                            onPressed: () {
                              audioHandler.skipToPrevious();
                            },
                            icon: Icon(
                              Icons.skip_previous_rounded,
                              color: babyBlue,
                              size: 48,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          GestureDetector(
                            onTap: () async {
                              print("playing is ... $isPlaying");
                              if (isPlaying) {
                                setState(() {});
                                await audioHandler.pause();
                              } else {
                                await audioHandler.play();
                              }
                            },
                            child: CircleAvatar(
                              radius: 36,
                              backgroundColor: babyBlue,
                              child: Icon(
                                isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              audioHandler.skipToNext();
                            },
                            icon: Icon(
                              Icons.skip_next_rounded,
                              color: babyBlue,
                              size: 48,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          IconButton(
                            onPressed: () {
                              !audioProv.isShuffled
                                  ? audioProv.shuffle()
                                  : audioProv.unshuffle();
                            },
                            icon: SvgPicture.asset('assets/icons/shuffle.svg',
                                width: 33,
                                height: 33,
                                color: Provider.of<AudioProvider>(context)
                                        .isShuffled
                                    ? babyBlue
                                    : darkGray.withOpacity(0.5)),
                            padding: EdgeInsets.zero,
                          ),
                          SizedBox(width: 5),
                        ]),
                  ),
                  Slider(
                      activeColor: babyBlue,
                      value: position.inMilliseconds.toDouble(),
                      onChanged: (double value) async {
                        int pos = value.round();
                        await audioHandler.seek(Duration(milliseconds: pos));
                      },
                      min: 0.0,
                      max: duration.inMilliseconds.toDouble()),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatTime(position),
                            style: TextStyle(
                                color: darkGray,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            formatTime(duration - position),
                            style: TextStyle(
                                color: darkGray,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ))
                ],
              ),
            );
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
