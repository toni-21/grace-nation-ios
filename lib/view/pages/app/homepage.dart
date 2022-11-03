import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/models/bible_verse.dart';
import 'package:grace_nation/core/models/event.dart';
import 'package:grace_nation/core/models/testimonies.dart';
import 'package:grace_nation/core/models/video.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/bible.dart';
import 'package:grace_nation/core/services/events.dart';
import 'package:grace_nation/core/services/resources.dart';
import 'package:grace_nation/core/services/testimonies.dart';
import 'package:grace_nation/core/services/youtube_api.dart';
import 'package:grace_nation/router/custum_rect_tween.dart';
import 'package:grace_nation/router/hero_dialogue_route.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/media/message_preview_card.dart';
import 'package:grace_nation/view/pages/testimonies/view_testimony.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late var _listProvider;
  GlobalKey _key = GlobalKey();
  final bibleApi = BibleApi();
  final testiApi = TestimoniesApi();
  final eventApi = EventsApi();
  final resources = ResourcesApi();
  final mainScrollController = ScrollController();
  int _currentCarouselIndex = 0;
  final ytApi = YoutubeApi.instance;

  @override
  void didChangeDependencies() {
    _listProvider = Provider.of<AppProvider>(context, listen: false);
    Provider.of<AppProvider>(context, listen: false).setPreferences();
    Provider.of<AppProvider>(context, listen: false).setNotificationList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _key,
          color: Colors.white,
          backgroundColor: babyBlue,
          displacement: 75,
          semanticsLabel: "Pull down to refresh",
          onRefresh: () async {
            // Replace this delay with the code to be executed during refresh
            // and return asynchronous code

            if (mounted) {
              _key = GlobalKey();
              setState(() {});
            }

            return Future<void>.delayed(Duration(milliseconds: 2500));
          },
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 0;
          },
          child: FutureBuilder(
            future: Future.wait(
              [
                bibleApi.dailyVerse(),
                testiApi.getTestimonies(),
                eventApi.getEvents(),
              ],
            ),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting //||
                  //!snapshot.hasData
                  ) {
                debugPrint("ConnectionState.waiting");
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: babyBlue,
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  body: SingleChildScrollView(
                    controller: mainScrollController,
                    physics: BouncingScrollPhysics(),
                    //padding: EdgeInsets.only(top: 10, left: 24),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Center(
                        child: Text('An error has occured'),
                      ),
                    ),
                  ),
                );
              }

              BibleVerse bibleVerse = snapshot.data![0];
              List<Testimony> testiList = snapshot.data![1];
              List<Event> eventList = snapshot.data![2];

              // Provider.of<AppProvider>(context, listen: false)
              //           .selectChannel(_channel!);
              //       Video video = _channel!.videos![index]

              Future.delayed(Duration(milliseconds: 500), () {
                _listProvider.setTestimoniesList(testiList);
                _listProvider.setEventsList(eventList);
              });
              final List<Widget> messageList = List.generate(5, (index) {
                Video? video = Provider.of<AppProvider>(context, listen: true)
                        .selectedVideoList
                        .isEmpty
                    ? null
                    : Provider.of<AppProvider>(context, listen: true)
                        .selectedVideoList[index];

                return GestureDetector(
                  onTap: () async {
                    Provider.of<AppProvider>(context, listen: false).goToTab(1);
                    context.go('/messages');
                    Video ytVideo = await ytApi.getVideoDetails(video: video!);
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
                            context: context,
                            videoThumbnail: video.thumbnailUrl);
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
                    child: Container(
                      margin: EdgeInsets.only(right: 12),
                      width: 160,
                      //    height: 166,
                      child: Wrap(
                        direction: Axis.vertical,
                        children: [
                          Container(
                            width: 160,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              image: video == null
                                  ? null
                                  : DecorationImage(
                                      image: NetworkImage(
                                        video.thumbnailUrl,
                                      ),
                                      fit: BoxFit.fitWidth),
                            ),
                            // child: Image.asset(
                            //   'assets/images/sermon_image1.png',
                            // ),
                          ),
                          SizedBox(height: 1),
                          SizedBox(
                            width: 160,
                            child: Text(
                              video == null ? '' : video.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                // color: sermonTextBlack,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            'Dr. Chris Okafor',
                            style: TextStyle(
                              color: sermonTextAsh,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });

              return SingleChildScrollView(
                controller: mainScrollController,
                physics: BouncingScrollPhysics(),
                //padding: EdgeInsets.only(top: 10, left: 24),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 175,
                      padding: EdgeInsets.only(left: 24, top: 12),
                      child: CarouselSlider(
                        options: CarouselOptions(
                            autoPlay: true,
                            enableInfiniteScroll: true,
                            height: 380,
                            disableCenter: true,
                            padEnds: false,
                            //380px,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1000),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            pauseAutoPlayOnTouch: true,
                            // aspectRatio: 6 / 16,
                            viewportFraction: 0.5,
                            enlargeCenterPage: false,
                            onPageChanged: (int index, reason) {
                              _currentCarouselIndex = index;
                            }),
                        items: messageList,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${bibleVerse.bookname}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  ' ${bibleVerse.chapter}:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${bibleVerse.verse}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${bibleVerse.text}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        )),
                    SizedBox(height: 12),
                    Text(
                      "The Word for Today - ${DateFormat.yMMMd().format(DateTime.now())}",
                      style: TextStyle(
                        color: sermonTextAsh,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 27),

                    //LIBERATION TV BOX
                    GestureDetector(
                      onTap: () {
                        Provider.of<AppProvider>(context, listen: false)
                            .goToTab(2);
                        context.go('/liberationTV');
                      },
                      child: Align(
                          alignment: Alignment.center,
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: 360,
                              height:
                                  //MediaQuery.of(context).size.height / 6,
                                  144,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 15),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <Color>[
                                    Color.fromRGBO(0, 143, 172, 1),
                                    Color.fromRGBO(0, 169, 203, 1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/home_card_background.png'),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.bottomRight),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: Column(
                                      //  direction: Axis.vertical,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 15),
                                        Text(
                                          '24/7  Live  Streaming  Station',
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Liberation TV',
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 27.5,
                                            height: 0.85,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        // SizedBox(height: 3),
                                        Text(
                                          'Connect with God on the go!',
                                          style: TextStyle(
                                            color: white.withOpacity(0.7),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 7.5,
                                              right: 7.5),
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(244, 27, 59, 1),
                                            border: Border.all(
                                                color: Colors.red,
                                                style: BorderStyle.solid,
                                                width: 1.2),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2),
                                              topRight: Radius.circular(2),
                                              bottomLeft: Radius.circular(2),
                                              bottomRight: Radius.circular(6),
                                            ),
                                          ),
                                          child: Text(
                                            'Watch Now',
                                            style: TextStyle(
                                                color:
                                                    white, //    Color.fromRGBO(244, 27, 59, 1),
                                                fontSize: 8,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Icon(
                                              Icons.play_circle_fill,
                                              size: 30,
                                              color: white.withOpacity(0.95),
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 24, bottom: 13, left: 24, right: 24),
                      child: Row(children: [
                        Text(
                          'Upcoming Events',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            context.goNamed(eventsRouteName);
                          },
                          child: Text(
                            'View More',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ]),
                    ),

                    //UPCOMING EVENTS
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 24),
                        clipBehavior: Clip.none,
                        itemCount: eventList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Event event = eventList[index];
                          final DateFormat dateFormate =
                              DateFormat('yyy-MM-dd');
                          final startdateTime =
                              dateFormate.parse(event.startDate!);
                          final enddateTime = dateFormate.parse(event.endDate!);
                          String suffixStart =
                              AppConfig().formatDate(startdateTime, true);
                          String suffixEnd =
                              AppConfig().formatDate(enddateTime);
                          final String timeText =
                              ('$suffixStart - $suffixEnd, ${enddateTime.year}');
                          return GestureDetector(
                            onTap: () {
                              Provider.of<AppProvider>(context, listen: false)
                                  .selectEvent(event);
                              context.goNamed(eventDetailsRouteName);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 13),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hoverColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                boxShadow: kElevationToShadow[2],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 67,
                                    width: 51,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(10),
                                        image: event.coverImage != null
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    event.coverImage!.url!),
                                                fit: BoxFit.fitHeight,
                                              )
                                            : null),
                                  ),
                                  SizedBox(width: 7),
                                  Wrap(
                                    // alignment: W,
                                    //Column
                                    direction: Axis.vertical,
                                    children: [
                                      Text(
                                        // 'Special Program with Pastor',
                                        event.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(children: [
                                        ImageIcon(
                                            AssetImage(
                                                'assets/icons/calendar.png'),
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color),
                                        SizedBox(width: 6),
                                        Text(
                                          // '25th - 26th Feb, 2022',
                                          timeText,
                                          style: TextStyle(
                                            color: sermonTextAsh,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        ImageIcon(
                                            AssetImage(
                                                'assets/icons/clock.png'),
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color),
                                        SizedBox(width: 6),
                                        Text(
                                          '7PM',
                                          style: TextStyle(
                                            color: sermonTextAsh,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 24, bottom: 13, left: 24, right: 24),
                      child: Row(children: [
                        Text(
                          'Testimonies',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            context.goNamed(testimoniesRouteName);
                          },
                          child: Text(
                            'View More',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ]),
                    ),

                    //TESTIMONIES
                    ListView.builder(
                      padding: EdgeInsets.only(left: 24, right: 24),
                      shrinkWrap: true,
                      itemCount: testiList.length,
                      controller: mainScrollController,
                      itemBuilder: (BuildContext context, int index) {
                        Testimony testimony = testiList[index];
                        return Container(
                          // height: 98,
                          width: 328,
                          padding: EdgeInsets.all(7),
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hoverColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: babyBlue.withOpacity(0.075),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset:
                                    Offset(0, 7), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  ImageIcon(
                                    AssetImage('assets/icons/user-tag.png'),
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    //'Mrs. Oyiyechi Johnson Amechi',
                                    testimony.testifier,
                                    // 'ldnf',
                                    style: TextStyle(
                                      color: sermonTextAsh,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      //      'Breast Cancer healed!!! Glory to God!',
                                      testimony.title,
                                      style: TextStyle(
                                        color: babyBlue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                // 'Sometimes there’s no reason to smile, but nn I’ll eueuue ieieiie ieiieiei eiie uu ...',
                                testimony.description,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: darkGray,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Provider.of<AppProvider>(context,
                                                listen: false)
                                            .selectTestimony(testimony);

                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ViewTestimony()));
                                      },
                                      child: Text(
                                        'Read more',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
