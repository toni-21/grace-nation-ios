import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/event.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Event event =
        Provider.of<AppProvider>(context, listen: false).selectedEvent;
    final DateFormat dateFormate = DateFormat('yyyy-MM-dd');
    List<DateTime> dateList = [];
    final startdateTime = dateFormate.parse(event.startDate!);
    final enddateTime = dateFormate.parse(event.endDate!);
    int dayDifference = startdateTime.difference(enddateTime).inDays;
    for (int i = 0; i <= dayDifference.abs(); i++) {
      final DateTime day = startdateTime.add(Duration(days: i));
      dateList.add(day);
    }
    print('listlegthis... ${event.endDate}');
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBarWidget(
          appBar: AppBar(),
          actionScreen: true,
          title: "Event Details",
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark.withOpacity(0.05),
                    image: event.coverImage != null
                        ? DecorationImage(
                            image: NetworkImage(event.coverImage!.url!),
                            fit: BoxFit.fitHeight,
                          )
                        : null),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 12),
                    Text(
                      // 'SPECIAL PROPHETIC FEAST',
                      event.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        // padding: EdgeInsets.only(left: 24, top: 10),
                        shrinkWrap: true,
                        itemCount: dateList.length,
                        itemBuilder: (BuildContext context, int index) {
                          String suffixDate =
                              AppConfig().formatDate(dateList[index]);
                          final String timeText =
                              ('$suffixDate, ${startdateTime.year}');
                          return Container(
                              margin: EdgeInsets.only(right: 12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 143, 172, 1)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(4),
                                        topLeft: Radius.circular(4),
                                      ),
                                    ),
                                    child: Text(
                                      timeText,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 169, 203, 1)),
                                    child: Text(
                                      '7PM',
                                      style:
                                          TextStyle(color: white, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ));
                        },
                      ),
                    ),
                    Text(
                      // _loremIpsumParagraph,
                      event.description,
                      style: TextStyle(
                        //   color: Theme.of(context).//Colors.black54,
                        height: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
