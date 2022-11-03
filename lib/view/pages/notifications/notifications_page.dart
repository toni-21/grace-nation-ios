import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/notification.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/notifications.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/notifications/notification_congrats.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationsPageState();
  }
}

class _NotificationsPageState extends State<NotificationsPage> {
  Widget achievment(Notifications notification) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return NotificationsCongrats();
        }));
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).hoverColor,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: babyBlue.withOpacity(0.03),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 7), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Partnership Goal Achieved! 🎉',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '15:23',
                  style: TextStyle(
                    color: darkGray,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Kingdom Advancement Partnership',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget newTestimony(Notifications notification) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: babyBlue.withOpacity(0.03),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 7), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Testimony!!!',
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '15:23',
                style: TextStyle(
                  color: darkGray,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Breast Cancer healed!',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            'Sometimes there’s no reason to smile, but nn I’ll eueuue ieieiie ieiieiei eiie uu ;soooodvmv;mdnslvkbndslvjndfljbnfbjldfbvldjn...',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                child: Text(
                  'Read more',
                  style: TextStyle(
                    fontSize: 14,
                    color: babyBlue,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget reminder(Notifications notifications) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: babyBlue.withOpacity(0.03),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 7), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Partnership Payment Reminder',
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '15:23',
                style: TextStyle(
                  color: darkGray,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Kingdom Advance Payment Due',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Notifications> notificationList =
        Provider.of<AppProvider>(context, listen: true).notificationList;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBarWidget(
        actionScreen: true,
        appBar: AppBar(),
        title: 'Notifications',
      ),
      body: notificationList.isEmpty
          ? Center(
              child: Text(
                'No Notifications Available',
                style: TextStyle(
                  color: redPayment,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: 22,
                horizontal: 24,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          ' X Clear All Notifications',
                          style: TextStyle(
                            color: redPayment,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: notificationList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Notifications notification = notificationList[index];

                          if (notification.type == 'achievment') {
                            return achievment(notification);
                          } else if (notification.type == 'reminder') {
                            return reminder(notification);
                          } else if (notification.type == 'testimony') {
                            return newTestimony(notification);
                          } else {
                            return reminder(notification);
                          }
                        }),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
