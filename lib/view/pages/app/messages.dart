import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:grace_nation/core/models/download_info.dart';
import 'package:grace_nation/core/models/video.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/resources.dart';
import 'package:grace_nation/core/services/youtube_api.dart';
import 'package:grace_nation/router/custum_rect_tween.dart';
import 'package:grace_nation/router/hero_dialogue_route.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/media/message_preview_card.dart';

class MessagesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MessagesScreenState();
  }
}

class _MessagesScreenState extends State<MessagesScreen>
    with AutomaticKeepAliveClientMixin<MessagesScreen> {
  final ytApi = YoutubeApi.instance;
  List<TaskInfo>? _tasks;
  List<Video> videoList = [];
  final mainScrollController = ScrollController();
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? currentDownloadId;
  final ReceivePort _port = ReceivePort();

  final resources = ResourcesApi();

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      print(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );
      currentDownloadId = taskId;
      Provider.of<AppProvider>(context, listen: false).setDownloading(true);
      Provider.of<AppProvider>(context, listen: false)
          .setProgressString("${progress.toString()}%");

      if (progress == -1) {
        Provider.of<AppProvider>(context, listen: false)
            .setProgressString("Failed");
        resources.deleteDownload(taskId);
        currentDownloadId = null;
        Future.delayed(Duration(milliseconds: 1500), () {
          Provider.of<AppProvider>(context, listen: false)
              .setDownloading(false);
        });

        print("Download has finished and is saved at ");
      }

      if (status == DownloadTaskStatus.complete) {
        Provider.of<AppProvider>(context, listen: false)
            .setProgressString("Completed");
        currentDownloadId = null;
        Future.delayed(Duration(milliseconds: 1500), () {
          Provider.of<AppProvider>(context, listen: false)
              .setDownloading(false);
        });

        print("Download has finished and is saved at ");
      }

      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == taskId);
        setState(() {
          task
            ..status = status
            ..progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  _initChannel() async {
    final newVideoList = await ytApi.fetchVideos(freshList: true);
    if (mounted) {
      setState(() {
        videoList = newVideoList;
      });
      Provider.of<AppProvider>(context, listen: false)
          .selectVideoList(videoList, 5);
    }
  }

  @override
  void initState() {
    print(videoList.length.toString());

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback, step: 1);

    if (Provider.of<AppProvider>(context, listen: false).downloading) {
      setState(() {
        videoList =
            Provider.of<AppProvider>(context, listen: false).selectedVideoList;
      });
    } else {
      _initChannel();
    }
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  bool clicked = false;
  Widget messageWidget(BuildContext context, Video video) {
    final duration = video.duration == null
        ? ""
        : AppConfig().printDuration(video.duration!);

    return GestureDetector(
      onTap: () async {
        if (clicked) return;
        clicked = true;
        Video ytVideo = await ytApi.getVideoDetails(video: video);
        if (ytVideo.duration == null) {
          return;
        } else {
          // Navigator.of(context).push(HeroDialogRoute(
          //     dismissible: true,
          //     builder: (context) {
          //       return MessagePreviewCard(video: ytVideo);
          //     }));

          var response = await Navigator.of(context).push(
            HeroDialogRoute(
              dismissible: true,
              builder: (context) {
                return MessagePreviewCard(video: ytVideo);
              },
            ),
          );
          if (!mounted) return;
          clicked = false;
          if (response == null) {
            print("GOGOGOG");
          } else if (response['downloading'] == true) {
            String url = response['videoId'];
            String name = response['videoTitle'];
            print("wE ARE DOWNLOADING NOW!!");
            print(url);
            resources.downloadVideo(
              videoUrl: url,
              videoName: name,
              duration: video.duration!,
              videoThumbnail: video.thumbnailUrl,
              context: context,
            );
            //resources.downloadVideo(, name, video.duration, context);
          } else {
            print("NOTHING TO DOWNLOAD");
          }
        }
      },
      child: Hero(
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        tag: Text('heroPreview'),
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            // direction: Axis.vertical,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2.4,
                height: MediaQuery.of(context).size.height / 6.4,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  image: DecorationImage(
                      image: NetworkImage(
                        // 'assets/images/sermon_image1.png',
                        video.thumbnailUrl,
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 1),
              Flexible(
                child: Text(
                  video.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // '1h 14m',
                    // duration,
                    "${video.publishedAt.day} ${DateFormat.MMM().format(video.publishedAt)}, ${video.publishedAt.year}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: sermonTextAsh,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await YoutubeApi.instance.fetchVideos();
    List<Video> allVideos = videoList..addAll(moreVideos);
    setState(() {
      videoList = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool downloading =
        Provider.of<AppProvider>(context, listen: true).downloading;
    String progressString =
        Provider.of<AppProvider>(context, listen: true).progressString;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: videoList.isNotEmpty
            ? RefreshIndicator(
                color: Colors.white,
                backgroundColor: babyBlue,
                displacement: 75,
                semanticsLabel: "Pull down to refresh",
                onRefresh: () async {
                  // Replace this delay with the code to be executed during refresh
                  // and return asynchronous code
                  return Future<void>.delayed(const Duration(milliseconds: 600),
                      () {
                    _initChannel(); //_getPartnerships();
                  });
                },
                notificationPredicate: (ScrollNotification notification) {
                  return notification.depth == 0;
                },
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollDetails) {
                    if (!_isLoading &&
                        videoList.length != 1000 &&
                        scrollDetails.metrics.pixels ==
                            scrollDetails.metrics.maxScrollExtent) {
                      _loadMoreVideos();
                    }
                    return false;
                  },
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            top: 24, left: 24, right: 24, bottom: 24),
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        controller: mainScrollController,
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1.5,
                              child: (videoList.isEmpty)
                                  ? Container()
                                  : GridView.builder(
                                      controller: mainScrollController,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisExtent:
                                            MediaQuery.of(context).size.width >
                                                    375
                                                ? null
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4.2,
                                        crossAxisCount:
                                            MediaQuery.of(context).size.width >
                                                    375
                                                ? 2
                                                : 1,
                                        mainAxisSpacing: 0, //10,
                                        crossAxisSpacing: 0, //15,

                                        // width / height: fixed for *all* items
                                        childAspectRatio: 0.95, // 0.25,
                                      ),
                                      shrinkWrap: true,
                                      itemCount: videoList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Video video = videoList[index];
                                        return messageWidget(context, video);
                                      },
                                    ),
                            ),
                            Padding(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: babyBlue,
                                ),
                                padding: EdgeInsets.only())
                          ],
                        ),
                      ),
                      (downloading == true)
                          ? Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.black.withOpacity(0.4),
                              child: Center(
                                child: Container(
                                  height: 150.0,
                                  width: 200.0,
                                  child: Card(
                                    color: Theme.of(context).hoverColor,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        downloading
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 5, top: 3),
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Icon(
                                                Icons.done_rounded,
                                                color: babyBlue,
                                                size: 40,
                                              ),
                                        Text(
                                          "Downloading File: $progressString",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: downloading
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .color
                                                  : babyBlue),
                                        ),
                                        SizedBox(height: 5),
                                        InkWell(
                                          onTap: () {
                                            if (currentDownloadId == null) {
                                              Provider.of<AppProvider>(context,
                                                      listen: false)
                                                  .setProgressString(
                                                      "Canceled");

                                              Future.delayed(
                                                  Duration(milliseconds: 500),
                                                  () {
                                                Provider.of<AppProvider>(
                                                        context,
                                                        listen: false)
                                                    .setDownloading(false);
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.red,
                                                  duration:
                                                      Duration(seconds: 2),
                                                  content:
                                                      Text("Download Canceled"),
                                                ),
                                              );
                                              return;
                                            } else {
                                              Provider.of<AppProvider>(context,
                                                      listen: false)
                                                  .setProgressString(
                                                      "Canceled");
                                              resources.cancelDownload(
                                                  currentDownloadId!);
                                              currentDownloadId = null;
                                              Future.delayed(
                                                  Duration(milliseconds: 500),
                                                  () {
                                                Provider.of<AppProvider>(
                                                        context,
                                                        listen: false)
                                                    .setDownloading(false);
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.red,
                                                  duration:
                                                      Duration(seconds: 2),
                                                  content:
                                                      Text("Download Canceled"),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: 200,
                                            height: 36,
                                            color: darkBlue,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Cancel",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ))
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    babyBlue, // Red
                  ),
                ),
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
