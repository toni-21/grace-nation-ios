import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/models/testimonies.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/events/event_details.dart';
import 'package:grace_nation/view/pages/testimonies/add_testimony.dart';
import 'package:grace_nation/view/pages/testimonies/view_testimony.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_fab.dart';
import 'package:grace_nation/view/shared/widgets/navbar.dart';
import 'package:provider/provider.dart';

class TestimoniesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Testimony> testimonies =
        Provider.of<AppProvider>(context, listen: false).testimonies;
    return WillPopScope(
      onWillPop: () async {
        context.goNamed(homeRouteName, params: {'tab': 'homepage'});
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBarWidget(
          appBar: AppBar(),
          actionScreen: false,
          title: 'Testimonies',
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          padding: EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 20),
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: testimonies.length,
          itemBuilder: (BuildContext context, int index) {
            final testimony = testimonies[index];
            return InkWell(
              onTap: () {
                Provider.of<AppProvider>(context, listen: false)
                    .selectTestimony(testimony);
                context.goNamed(viewTestimonyRouteName);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).hoverColor.withOpacity(0.5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: babyBlue.withOpacity(0.025),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 7), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    testimony.imageId != ""
                        ? Container(
                            height: 136,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/sermon_image1.png'),
                                fit: BoxFit.fitWidth,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(left: 14, right: 14, bottom: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  // 'Breast Cancer healed!!! Glory to God!',
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
                            //'Sometimes there’s no reason to smile, but nn I’ll eiieiei eiie uupidfjbln ldibkdjb podjfbnpod fjdfj ',
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
                              Text(
                                'Read more',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: CustomFAB(onTap: () {
          context.goNamed(addTestimonyRouteName);
        }),
      ),
    );
  }
}
