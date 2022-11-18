import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/models/branch.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/branch_locator.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BranchResult extends StatelessWidget {
  List list = [1, 2];
  final locatorApi = BranchLocator();

  _launchUrl(String url) async {
    final uri = Uri.parse('https://www.google.com/maps/search/$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      print('Launching url went wrong');
      return;
    }
  }

  Widget branchWidget(Branch branch, BuildContext context) {
    return GestureDetector(
        onTap: () {
          _launchUrl(branch.address);
        },
        child: Stack(clipBehavior: Clip.none, children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  // height: 98,

                  width: 328,
                  padding:
                      EdgeInsets.only(left: 15, right: 10, bottom: 10, top: 10),
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
                        offset: Offset(0, 7), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              //'Name of Branch, anne anenn ena ne nen ane nanne nan nen ne nen a ne na  ane e n',
                              branch.name,
                              style: TextStyle(
                                //   color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          ImageIcon(
                            AssetImage('assets/icons/locator-tick.png'),
                            // color: Colors.black,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              //'12, Oyinkan Abayomi Drive, more address space Ojodu, Lagos, Ikeja, UEY Drive, Lagos. Nigeria. ',
                              branch.address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                // color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ImageIcon(
                            AssetImage('assets/icons/locator-calling.png'),
                            // color: Colors.black,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              //'0802 123 4579',
                              branch.phone,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                //   color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          // branch.country.id == 160
                          //     ? Image.asset(
                          //         'assets/images/location-sudan.png')
                          //     : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: -1,
            left: 0,
            child: Container(
              width: 10,
              height: 33,
              color: babyBlue,
            ),
          ),
          Positioned(
            top: 25,
            right: 18,
            child: InkWell(
              child: Icon(
                Icons.location_on_sharp,
                size: 30,
                color: babyBlue,
              ),
            ),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> searchValues =
        Provider.of<AppProvider>(context, listen: false).branchSearch;
    return Scaffold(
      appBar: AppBarWidget(
        appBar: AppBar(),
        actionScreen: true,
        title: 'Search Result',
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: FutureBuilder(
            future: locatorApi.getBranches(
              countryId: searchValues['countryId'],
              stateId: searchValues['stateId'],
              area: searchValues['area'],
            ),
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
                  body: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Center(
                        child: Text('An error has occured'),
                      )),
                );
              }

              final List<Branch> branchList = snapshot.data!;

              return branchList.isEmpty
                  ? Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/locator-destination.png',
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                  left: 45,
                                  right: 45,
                                  top: 50,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Provider.of<AppProvider>(context,
                                                  listen: false)
                                              .goToTab(2);
                                          context.go('/liberationTV');
                                        },
                                        child: Text(
                                          'We currently do not have a branch in the current location, you can still connect with Grace Nation online via the online live services on LiberationTV or via our social media pages. ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                      ),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: 24,
                          bottom: 24,
                        ),
                        itemCount: branchList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final Branch branch = branchList[index];
                          return branchWidget(branch, context);
                        },
                      ),
                    );
            }),
      ),
    );
  }
}
