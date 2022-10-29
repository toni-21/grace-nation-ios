import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grace_nation/core/models/video.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/resources.dart';
import 'package:grace_nation/router/custum_rect_tween.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/media/video_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const urlString =
    "https://rr1---sn-ab5l6nkd.googlevideo.com/videoplayback?expire=1666119856&ei=UKROY7TXJs-7gwP11an4Dg&ip=165.227.196.134&id=o-ALbkF27ihCNt_jbE8WijlKSgraJxWC5KfOVbL0boF-sO&itag=18&source=youtube&requiressl=yes&mh=XN&mm=31%2C29&mn=sn-ab5l6nkd%2Csn-ab5sznze&ms=au%2Crdu&mv=m&mvi=1&pl=20&initcwndbps=545000&vprv=1&mime=video%2Fmp4&cnr=14&ratebypass=yes&dur=312.494&lmt=1659079469965726&mt=1666098069&fvip=4&fexp=24001373%2C24007246&c=ANDROID&txp=6318224&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Ccnr%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRAIgK3wEKDVZEkMZmBb-Sr-Na-ZhP6INOXA0zznxjgcgW_ACIH-Xd6QLWjsix7Gpkc_tBrFs4rKVwsFa1t5h2xJZizpN&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIhAPGD_VmTFgkYzL4JYmZMsLDJs9hsKM0mloPIhaLHnZffAiBjX5e6Eqj-PNnoRLI4ehREbK3hGxqVn8HlwId1aQrclA%3D%3D";
const samplePath =
    "/data/user/0/com.example.grace_nation/app_flutter/How God rescued me";

class MessagePreviewCard extends StatefulWidget {
  final Video video;

  const MessagePreviewCard({Key? key, required this.video}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MessagePreviewCardState();
  }
}

class _MessagePreviewCardState extends State<MessagePreviewCard> {
  final resources = ResourcesApi();
  bool downloading = false;
  String progressString = "";

 

  @override
  Widget build(BuildContext context) {
    Video video = widget.video;
    final month = DateFormat.MMM().format(video.publishedAt);

    // String date = "$month ${dateTime.day}, ${dateTime.year}";
    // String duration = audioDurationList[index];
    return Center(
      child: Hero(
        tag: Text('heroPreview'),
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child:
            // child: (downloading == true || progressString != "")
            //     ? Container(
            //         height: 120.0,
            //         width: 200.0,
            //         child: Card(
            //           color: Theme.of(context).hoverColor,
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: <Widget>[
            //               downloading
            //                   ? Padding(
            //                       padding: EdgeInsets.only(bottom: 7.5, top: 3),
            //                       child: CircularProgressIndicator(),
            //                     )
            //                   : Icon(
            //                       Icons.done_rounded,
            //                       color: babyBlue,
            //                       size: 40,
            //                     ),
            //               Text(
            //                 "Downloading File: $progressString",
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(
            //                     color: downloading
            //                         ? Theme.of(context).textTheme.bodySmall!.color
            //                         : babyBlue),
            //               )
            //             ],
            //           ),
            //         ),
            //       )
            //  :
            Material(
          color: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 33, vertical: 12),
                  child: Column(
                    children: [
                      SizedBox(),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                                image: NetworkImage(video.thumbnailUrl),
                                fit: BoxFit.cover)),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VideoScreen(id: video.id),
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: babyBlue,
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 64,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).hoverColor,
                          boxShadow: kElevationToShadow[2],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        padding: EdgeInsets.only(
                            top: 7, bottom: 10, right: 10, left: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.title,

                              // 'Dealing with the Enemy within your life',
                              textAlign: TextAlign.left,
                              // overflow:
                              //     TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 5,
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            direction: Axis.horizontal,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        // '2022',
                                                        video.publishedAt.year
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: darkGray,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        // '01 Oct.',
                                                        "${video.publishedAt.day} $month.",
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: darkGray,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        video.views.toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: darkGray,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Views',
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: darkGray,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        // '2hr:44m',
                                                        AppConfig()
                                                            .numberDuration(
                                                                video
                                                                    .duration!),
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: darkGray,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Duration',
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: darkGray,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    flex: 3,
                                    child: InkWell(
                                      splashColor: babyBlue,
                                      onTap: () async {
                                        // Provider.of<AppProvider>(context,
                                        //         listen: false)
                                        //     .setDownloading(true);
                                        Map<String, dynamic> map = {
                                          'downloading': true,
                                          // 'callback': _downloadVideo(
                                          //     video.id, video.title)
                                          'videoId': video.id,
                                          'videoTitle': video.title,
                                        };
                                        Navigator.pop(context, map);
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/download.svg',
                                                alignment:
                                                    Alignment.bottomCenter,
                                                height: 20,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              SizedBox(width: 25),
                                            ],
                                          ),
                                          Text(
                                            'Download',
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 0,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    alignment: Alignment.center,
                    child: IconButton(
                      splashRadius: 3,
                      splashColor: Colors.transparent,
                      padding: EdgeInsets.all(0),
                      alignment: Alignment.center,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 22,
                        color: white,
                      ),
                    ),
                  ),

                  // IconButton(onPressed: () {}, icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
