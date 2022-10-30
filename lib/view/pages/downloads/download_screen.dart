import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/models/auidio_track.dart';
import 'package:grace_nation/core/providers/audio_provider.dart';
import 'package:grace_nation/view/shared/widgets/confirmation_widget.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/downloads/audio_player.dart';
import 'package:grace_nation/view/pages/downloads/video_player_widget.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';

class DownloadScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DownloadScreenState();
  }
}

class _DownloadScreenState extends State<DownloadScreen> {
  List videoList = [];
  List videoPathList = [];
  List<String> audioDurationList = [];
  List<AudioTrack> audioList = [];
  List<File> thumbList = [];
  @override
  void initState() {
    _fetchVideoList();
    super.initState();
  }

  _fetchVideoList() async {
    var dir = await getApplicationDocumentsDirectory();
    final prefs = await SharedPreferences.getInstance();
    String videosPath = "${dir.path}/videos/";
    String thumbsPath = "${dir.path}/thumbnails/";
    List<String> newList = [];
    print("Fetching video List");
    var directory = Directory(videosPath);
    var thumbDirectory = Directory(thumbsPath);
    print(directory);

    var exists = await directory.exists();
    if (exists) {
      print("exits");

      await thumbDirectory
          .list(recursive: true, followLinks: false)
          .listen((FileSystemEntity entity) async {
        print("new thumb path is ${entity.path}");
        thumbList.add(entity as File);
      });

      directory
          .list(recursive: true, followLinks: false)
          .listen((FileSystemEntity entity) async {
        newList.add(entity.path);
        String t = (entity.path).split("/").last;
        String? d = prefs.getString('duration-$t');
        print('DURATION WE ARE TRYING TO GET IS .. duration-$t\n it is .. $d');
        audioDurationList.add(d ?? "");
        print(
            'OUR IMAGE FILE IS .. ${thumbDirectory.path}${t.split('.').first}.jpg');
        final newAudioTrack = AudioTrack(
            title: t,
            source: entity.path,
            image: File('${thumbDirectory.path}${t.split('.').first}.jpg'),
            date: File(entity.path).statSync().modified);

        audioList.add(newAudioTrack);
      });
    }
    setState(() {
      videoList = newList;
      print("audioList lenth is.. ${audioList.length}");
    });
    setState(() {});
  }

  Widget videoWidget(String videoPath, File image, [bool service = false]) {
    final videoFile = File(videoPath);
    String size = (videoFile.statSync().size * 0.000001).truncate().toString();
    String title = videoPath.split("/").last;

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  height: 80,
                  width: 118,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    //  borderRadius: BorderRadius.circular(7),
                    image: DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return VideoPlayerWidget(videoPath: videoPath);
                        }));
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: babyBlue,
                            width: 5,
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.play_arrow_outlined,
                          size: 26.3,
                          color: babyBlue,
                        ),
                      ),
                    ),
                  )),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text(
                        title,
                        style: TextStyle(
                            //   color: darkGray,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text(
                        ('${size}MB'),
                        style: TextStyle(
                            color: Color.fromRGBO(211, 212, 237, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Text(
                    //       ('${size}MB'),
                    //       style: TextStyle(
                    //           color: Color.fromRGBO(211, 212, 237, 1),
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //   ],
                    // ),
                    // Stack(
                    //   children: [
                    //     Container(
                    //       height: 2.4,
                    //       color: babyBlue,
                    //     ),
                    //     Container(
                    //       width: 150,
                    //       height: 2.4,
                    //       color: Colors.black,
                    //     )
                    //   ],
                    // )
                  ],
                ),
              ),
              Container(
                height: 80,
                width: 64,
                color: Color.fromARGB(255, 207, 56, 45),
                child: IconButton(
                    icon: Icon(Icons.close),
                    color: white,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmationWidget(
                                title: "Delete Video ?",
                                description:
                                    "This will delete both the audio and video format. Do you wish to continue?",
                                callback: () {
                                  deleteFile(
                                      videoPath: videoPath,
                                      imagePath: image.path);
                                },
                                actionText: "Delete",
                                exitText: "Cancel");
                          });
                    }),
              )
            ],
          ),
          //  Divider()
        ],
      ),
    );
  }

  Future deleteFile({required videoPath, required imagePath}) async {
    try {
      final imageFile = File(imagePath);
      await imageFile.delete();
      final videoFile = File(videoPath);
      await videoFile.delete();
      _fetchVideoList();
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  videoPage() {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: (videoList.isEmpty || audioDurationList.isEmpty)
            ? Container()
            : ListView.builder(
                padding: EdgeInsets.only(top: 24),
                shrinkWrap: true,
                //itemCount: items.length,
                itemCount: videoList.length,
                itemBuilder: (BuildContext context, int index) {
                  // final item = items[index];

                  //    _getThumbnails();
                  return videoWidget(videoList[index], thumbList[index]);
                },
              ));
  }

  Widget audioPage() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: (videoList.isEmpty ||
              audioDurationList.isEmpty ||
              audioList.isEmpty)
          ? Container()
          : ListView.builder(
              padding: EdgeInsets.only(
                top: 24,
              ),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: audioList.length,
              itemBuilder: (BuildContext context, int index) {
                final AudioTrack track = audioList[index];

//
                final filePath = videoList[index];
                final videoFile = File(filePath);
                final dateTime = videoFile.statSync().modified;
                final month = DateFormat.LLLL().format(dateTime);
                String date = "$month ${dateTime.day}, ${dateTime.year}";
                String duration = audioDurationList[index];
                String t = (filePath.split("/").last);
                String title = t.split(".").first;

                return InkWell(
                  onTap: () async {
                    print(
                        "length is ....${Provider.of<AudioProvider>(context, listen: false).playlist.length}");
                    await Provider.of<AudioProvider>(context, listen: false)
                        .selectCurrentIndex(index);
                    await Provider.of<AudioProvider>(context, listen: false)
                        .setPlaylist(audioList);
                    track.title = title;
                    await Provider.of<AudioProvider>(context, listen: false)
                        .setCurrentTrack(track);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AudioPlayerWidget()));
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    // decoration: BoxDecoration(
                    //   color: Colors.white.withOpacity(0.125),
                    //   borderRadius: BorderRadius.all(
                    //     Radius.circular(8),
                    //   ),
                    //   boxShadow: [],
                    // ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: FileImage(track.image!),
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  //    overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  // 'September 14, 2022',
                                  date,
                                  style: TextStyle(
                                      color: Color(0xFFACB8C2),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //   Spacer(),
                        Container(
                          height: 30,
                          width: 30,
                          //color: Color.fromARGB(255, 207, 56, 45),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 207, 56, 45),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.close),
                              color: white,
                              iconSize: 20,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ConfirmationWidget(
                                          title: "Delete Audio ?",
                                          description:
                                              "This will delete both the audio and video format. Do you wish to continue?",
                                          callback: () {
                                            deleteFile(
                                                videoPath: track.source,
                                                imagePath: track.image!.path);
                                          },
                                          actionText: "Delete",
                                          exitText: "Cancel");
                                    });
                              }),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {});
    });
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async {
          context.goNamed(homeRouteName, params: {'tab': 'homepage'});
          return false;
        },
        child: Scaffold(
          appBar: AppBarWidget(
            actionScreen: false,
            title: 'Downloads',
            appBar: AppBar(),
          ),
          resizeToAvoidBottomInset: false,
          drawer: AppDrawer(),
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.only(top: 12, left: 6, right: 6),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 0),
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      indicatorColor: babyBlue,
                      isScrollable: true,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 4, color: babyBlue),
                        insets: EdgeInsets.only(left: 0, right: 8, bottom: 4),
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 4,
                      labelColor: Theme.of(context).iconTheme.color,
                      unselectedLabelColor:
                          Theme.of(context).iconTheme.color!.withOpacity(0.25),
                      tabs: [
                        Tab(
                          child: Text(
                            'Audio',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Video',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          audioPage(),
                          videoPage(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
