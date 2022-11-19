import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/testimonies.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewTestimony extends StatelessWidget {
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    Testimony testimony =
        Provider.of<AppProvider>(context, listen: false).selectedTestimony;
    String timeText = testimony.createdAt;
    print(timeText);
    final DateFormat dateFormate = DateFormat('MM/dd/yyyy hh:mm a');
    final newdate = dateFormate.parse(timeText);
    final Duration timeDuration = DateTime.now().difference(newdate);
    final String timeAgo = ('${timeDuration.inDays} days ago');
    print(timeAgo);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false)
          .cacheTestimony(testimony);
    });

    return Scaffold(
        appBar: AppBarWidget(
          appBar: AppBar(),
          actionScreen: true,
          title: "View Testimony",
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              testimony.imageId != ""
                  ? Container(
                      height: 500,
                      width: double.infinity,
                      color: Colors.black,
                      child: Image.asset(
                        'assets/images/sermon_image1.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 12),
                    Text(
                      //  'Living Beyond Breast Cancer and Free from Sin and Shame.',

                      testimony.title,
                      style: TextStyle(
                        color: babyBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageIcon(
                          AssetImage('assets/icons/user-tag.png'),
                          // color: Colors.black,
                        ),
                        SizedBox(width: 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // 'Mrs. Oyiyechi Johnson Amechi',
                              testimony.testifier,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              //'2m ago',
                              timeAgo,
                              style: TextStyle(
                                color: darkGray,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      //  _loremIpsumParagraph,
                      testimony.description,
                      style: TextStyle(
                        // color: Colors.black54,
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
