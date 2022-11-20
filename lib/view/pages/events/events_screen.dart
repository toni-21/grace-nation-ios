import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/models/event.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/events.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventsScreenState();
  }
}

class _EventsScreenState extends State<EventsScreen> {
  final mainScrollController = ScrollController();
  final eventsApi = EventsApi();
  Widget eventWidget(Event event, BuildContext context) {
    final DateFormat dateFormate = DateFormat('yyy-MM-dd');
    final startdateTime = dateFormate.parse(event.startDate!);
    final enddateTime = dateFormate.parse(event.endDate!);
    final month = DateFormat("MMM").format(enddateTime);
    // String suffixStart = AppConfig().formatDate(startdateTime, true);
    // String suffixEnd = AppConfig().formatDate(enddateTime);
    final String timeText =
        ('${startdateTime.day} - ${enddateTime.day} $month, ${enddateTime.year}');
    return GestureDetector(
      onTap: () {
        Provider.of<AppProvider>(context, listen: false).selectEvent(event);
        context.goNamed(eventDetailsRouteName);
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark.withOpacity(0.036),
              borderRadius: BorderRadius.circular(10),
              image: event.coverImage != null
                  ? DecorationImage(
                      image: NetworkImage(event.coverImage!.url!),
                      fit: BoxFit.fill,
                    )
                  : null),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 7.5, right: 7.5, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(children: [
                        Text(
                          event.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: white,
                            fontSize: 13.6,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              timeText,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: white,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "More",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                    ]),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Event> events =
        Provider.of<AppProvider>(context, listen: false).events;
    return WillPopScope(
        onWillPop: () async {
          context.goNamed(homeRouteName, params: {'tab': 'homepage'});
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBarWidget(
            title: "Upcoming Events",
            actionScreen: false,
            appBar: AppBar(),
          ),
          drawer: AppDrawer(),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: mainScrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //  SizedBox(height: 24),
                  events.isEmpty
                      ? Container()
                      : RefreshIndicator(
                          color: Colors.white,
                          backgroundColor: babyBlue,
                          displacement: 75,
                          semanticsLabel: "Pull down to refresh",
                          onRefresh: () async {
                            return Future<void>.delayed(
                                const Duration(milliseconds: 600), () async {
                              var newEvents = await eventsApi.getEvents();
                              setState(() {
                                Provider.of<AppProvider>(context, listen: false)
                                    .setEventsList(newEvents);
                              });
                            });
                          },
                          notificationPredicate:
                              (ScrollNotification notification) {
                            return notification.depth == 0;
                          },
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 24),
                            physics: AlwaysScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 15,
                              childAspectRatio: 0.95,
                            ),
                            shrinkWrap: true,
                            itemCount: events.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Event event = events[index];
                              return eventWidget(event, context);
                            },
                          ),
                        )
                ],
              ),
            ),
          ),
        ));
  }
}
