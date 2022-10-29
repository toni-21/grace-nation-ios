import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/sliding_appbar.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  const VideoPlayerWidget({Key? key, required this.videoPath})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerState();
  }
}

class _VideoPlayerState extends State<VideoPlayerWidget>
    with SingleTickerProviderStateMixin {
  bool _visible = true;
  // ignore: prefer_final_fields
  bool _fullScreen = false;
  late final AnimationController _animController;
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _visible = false);
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  void setPreferredOrientation({required bool fullScreen}) {
    fullScreen
        ? SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ])
        : SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitDown,
            DeviceOrientation.portraitUp,
          ]);
  }

  @override
  Widget build(BuildContext context) {
    String videoName = widget.videoPath.split("/").last;
    print(videoName);
    setPreferredOrientation(fullScreen: _fullScreen);
    return GestureDetector(
        onTap: () {
          print('TAPPED!!');
          if (_visible) return;
          setState(() => _visible = true);
          Future.delayed(Duration(seconds: 3), () {
            if (mounted) {
              setState(() => _visible = false);
            }
          });
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: SlidingAppBar(
            controller: _animController,
            visible: _visible,
            child: AppBar(
              title: Text(videoName),
              backgroundColor: Theme.of(context).primaryColor,
              automaticallyImplyLeading: false,
              leading: IconButton(
                padding: EdgeInsets.only(left: 15),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
          body: Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        VideoPlayer(
                          _controller,
                        ),
                        ClosedCaption(text: null),
                        // Here you can also add Overlay capacities
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height / 9,
                              width: MediaQuery.of(context).size.width / 3,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.play_arrow_rounded,
                                size: 54,
                                color: _controller.value.isPlaying
                                    ? Colors.transparent
                                    : babyBlue,
                              ),
                            ),
                          ),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: VideoProgressIndicator(
                                  _controller,
                                  allowScrubbing: true,
                                  padding: EdgeInsets.only(
                                      bottom: 5, left: 3, right: 3, top: 3),
                                  colors: VideoProgressColors(
                                      playedColor: babyBlue),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _fullScreen = !_fullScreen;
                                  });
                                },
                                child: Icon(
                                  Icons.fullscreen,
                                  color: babyBlue,
                                ),
                              ),
                            ])
                      ],
                    ),
                  )
                : Container(
                    height: 250,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ),
        ));
  }
}
