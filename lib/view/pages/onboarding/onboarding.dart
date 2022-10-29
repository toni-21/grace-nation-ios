import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/app/app_screen.dart';
import 'package:grace_nation/view/pages/app/homepage.dart';
import 'package:grace_nation/view/pages/onboarding/page_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnboardingState();
  }
}

class _OnboardingState extends State<Onboarding> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      PageWidget(
        mainText: 'Welcome',
        subText:
            'I welcome you to Grace Nation (Liberation City) ~ Dr. Chris Okafor - Senior Pastor',
        image: 'assets/images/onboarding1.png',
        buttonText: 'Next',
        onTap: () {
          _pageController.animateToPage(1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn);
        },
      ),
      PageWidget(
        mainText: 'Audio & Video Messages',
        subText: 'Enjoy the word of God on the go with LiberationTV live',
        image: 'assets/images/onboarding2.png',
        buttonText: 'Next',
        onTap: () {
          _pageController.animateToPage(2,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn);
        },
      ),
      PageWidget(
        mainText: 'Giving & Partnership',
        buttonText: 'Get Started',
        subText:
            'Give offering, tithe, welfare, partnership and much more online',
        image: 'assets/images/onboarding3.png',
        onTap: () async {
          final SharedPreferences prefs = await _prefs;
          prefs.setBool('onboarded', true);
          context.goNamed(homeRouteName, params: {'tab': 'homepage'});
        },
      ),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: pages.length,
            itemBuilder: (BuildContext context, int index) {
              return pages[index];
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                pages.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    onTap: () {
                      _pageController.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    child: _currentPage == index
                        ? Container(
                            height: 8,
                            width: 23,
                            decoration: BoxDecoration(
                              color: highBabyBlue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(26),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 5,
                            backgroundColor: highBabyBlue.withOpacity(0.4)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
