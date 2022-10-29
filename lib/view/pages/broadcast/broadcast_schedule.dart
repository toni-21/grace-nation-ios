import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/services/broadcast.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/branch/branch_result.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:grace_nation/view/shared/widgets/navbar.dart';

class BroadcastSchedule extends StatelessWidget {
  final broadcastApi = BroadcastApi();
  @override
  Widget build(BuildContext context) {
    final mainScrollController = ScrollController();
    return WillPopScope(
      onWillPop: () async {
        context.goNamed(homeRouteName, params: {'tab': 'homepage'});
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBarWidget(
          actionScreen: false,
          appBar: AppBar(),
          title: 'Broadcast Schedule',
        ),
        drawer: AppDrawer(),
        body: FutureBuilder<Map<String, dynamic>>(
          future: broadcastApi.getBroadcast(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                body: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Center(
                      child: Text('An error has occured'),
                    )),
              );
            }

            Map<String, dynamic> response = snapshot.data;
            List broadcasts = response['data'] ?? [];

            return SingleChildScrollView(
              controller: mainScrollController,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Liberation TV Broadcast',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ))
                    ],
                  ),
                  SizedBox(height: 24),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: broadcasts.length,
                      controller: mainScrollController,
                      itemBuilder: (BuildContext context, int index) {
                        final broadcast = broadcasts[index];
                        String channel = broadcast['channel'];
                        String day = broadcast['schedules'][0]['day'];
                        String startTime =
                            broadcast['schedules'][0]['start_time'];
                        String frequency =
                            broadcast['schedules'][0]['frequency'];
                        return Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hoverColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      //'DSTV Channel 197',
                                      channel,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      // '10:00pm GMT +1',
                                      '$startTime GMT +1',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.75),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      //    SizedBox(height: 16),
                                      Text(
                                        //'Mon - Fri',
                                        day,
                                        style: TextStyle(
                                          color: babyBlue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      Text(
                                        // '10:00pm GMT +1',
                                        frequency,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark
                                              .withOpacity(0.75),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        );
                      })
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
