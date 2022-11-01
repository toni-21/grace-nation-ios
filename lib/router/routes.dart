import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/providers/user_states.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/view/pages/about_us/about_us_screen.dart';
import 'package:grace_nation/view/pages/app/app_screen.dart';
import 'package:grace_nation/view/pages/events/event_details.dart';
import 'package:grace_nation/view/pages/events/events_screen.dart';
import 'package:grace_nation/view/pages/bible/bible_screen.dart';
import 'package:grace_nation/view/pages/branch/branch_locator.dart';
import 'package:grace_nation/view/pages/branch/branch_result.dart';
import 'package:grace_nation/view/pages/broadcast/broadcast_schedule.dart';
import 'package:grace_nation/view/pages/contact/contact_screen.dart';
import 'package:grace_nation/view/pages/downloads/audio_player.dart';
import 'package:grace_nation/view/pages/downloads/download_screen.dart';
import 'package:grace_nation/view/pages/giving/offline_giving.dart';
import 'package:grace_nation/view/pages/giving/online_giving.dart';
import 'package:grace_nation/view/pages/onboarding/onboarding.dart';
import 'package:grace_nation/view/pages/onboarding/splash_screen.dart';
import 'package:grace_nation/view/pages/partnership/create_partnership.dart';
import 'package:grace_nation/view/pages/partnership/faq.dart';
import 'package:grace_nation/view/pages/partnership/offline_partnership.dart';
import 'package:grace_nation/view/pages/partnership/online_partnership.dart';
import 'package:grace_nation/view/pages/partnership/partner_login.dart';
import 'package:grace_nation/view/pages/partnership/partner_registeration.dart';
import 'package:grace_nation/view/pages/partnership/partner_welcome.dart';
import 'package:grace_nation/view/pages/partnership/partnership_congrats.dart';
import 'package:grace_nation/view/pages/partnership/partnership_detail.dart';
import 'package:grace_nation/view/pages/partnership/partnership_page.dart';
import 'package:grace_nation/view/pages/partnership/profile.dart';
import 'package:grace_nation/view/pages/partnership/reset_password.dart';
import 'package:grace_nation/view/pages/partnership/security.dart';
import 'package:grace_nation/view/pages/partnership/set_new_password.dart';
import 'package:grace_nation/view/pages/partnership/verify_account.dart';
import 'package:grace_nation/view/pages/testimonies/add_testimony.dart';
import 'package:grace_nation/view/pages/testimonies/testimonies.dart';
import 'package:grace_nation/view/pages/testimonies/view_testimony.dart';
import 'package:grace_nation/view/shared/screens/error.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRouter {
  final LoginState loginState;
  final GlobalKey<NavigatorState> navigatorKey;
  MyRouter(this.loginState, this.navigatorKey);

  // 2
  late final router = GoRouter(
  
    // 3
    refreshListenable: loginState,
    // 4
    debugLogDiagnostics: true,
    // 5
    //  urlPathStrategy: UrlPathStrategy.path,
    navigatorKey: navigatorKey,
    // 6
    routes: [
      GoRoute(
        name: rootRouteName,
        path: '/',
        redirect: (BuildContext context, GoRouterState state) async {
          final prefs = await SharedPreferences.getInstance();
          final loginState = LoginState(prefs);
          if (loginState.onboarded == true) {
            if (loginState.audioClick == true) {
              return state.namedLocation(audioRouteName);
            } else {
              return state
                  .namedLocation(homeRouteName, params: {'tab': 'homepage'});
            }
          } else {
            return state.namedLocation(splashRouteName);
          }
        },
      ),
      GoRoute(
        name: splashRouteName,
        path: '/splash',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: SplashScreen(),
        ),
      ),
      GoRoute(
        name: onboardingRouteName,
        path: '/onboarding',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: Onboarding(),
        ),
      ),
      GoRoute(
          name: homeRouteName,
          path: '/home/:tab(homepage|messages|liberationTV|give)',
          pageBuilder: (context, state) {
            final tab = state.params['tab']!;
            return MaterialPage<void>(
              key: state.pageKey,
              child: AppScreen(
                tab: tab,
              ),
            );
          }),
      GoRoute(
        path: '/homepage',
        redirect: (BuildContext context, GoRouterState state) {
          return state
              .namedLocation(homeRouteName, params: {'tab': 'homepage'});
        },
      ),
      GoRoute(
          path: '/messages',
          redirect: (BuildContext context, GoRouterState state) {
            return state
                .namedLocation(homeRouteName, params: {'tab': 'messages'});
          }),
      GoRoute(
          path: '/liberationTV',
          redirect: (BuildContext context, GoRouterState state) {
            return state
                .namedLocation(homeRouteName, params: {'tab': 'liberationTV'});
          }),
      GoRoute(
        path: '/give',
        redirect: (BuildContext context, GoRouterState state) {
          return state.namedLocation(homeRouteName, params: {'tab': 'give'});
        },
      ),
      GoRoute(
        name: aboutRouteName,
        path: '/about',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: AboutUsScreen(),
        ),
      ),
      GoRoute(
        name: contactRouteName,
        path: '/contact',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: ContactScreen(),
        ),
      ),
      GoRoute(
        name: bibleRouteName,
        path: '/bible',
        pageBuilder: (context, state) =>
            MaterialPage<void>(key: state.pageKey, child: BibleScreen()),
      ),
      GoRoute(
        name: audioRouteName,
        // parentNavigatorKey: navigatorKey,
        path: '/audioPlayer',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: AudioPlayerWidget(),
        ),
      ),
      GoRoute(
        name: onlineGivingRouteName,
        path: '/onlineGiving',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: OnlineGiving(),
        ),
      ),
      GoRoute(
        name: offlineGivingRouteName,
        path: '/offlineGiving',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: OfflineGiving(),
        ),
      ),
      GoRoute(
          name: eventsRouteName,
          path: '/events',
          pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: EventsScreen(),
              ),
          routes: [
            GoRoute(
              name: eventDetailsRouteName,
              path: 'eventDetails',
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: EventDetails(),
              ),
            ),
          ]),
      GoRoute(
          name: testimoniesRouteName,
          path: '/testimonies',
          pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: TestimoniesScreen(),
              ),
          routes: [
            GoRoute(
              name: addTestimonyRouteName,
              path: 'addTestimony',
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: AddTestimony(),
              ),
            ),
            GoRoute(
              name: viewTestimonyRouteName,
              path: 'viewTestimony',
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: ViewTestimony(),
              ),
            ),
          ]),
      GoRoute(
          name: branchLocatorRouteName,
          path: '/branchLocator',
          pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: BranchLocatorScreen(),
              ),
          routes: [
            GoRoute(
              name: branchResultsRouteName,
              path: 'branchResults',
              pageBuilder: (context, state) =>
                  MaterialPage<void>(key: state.pageKey, child: BranchResult()),
            ),
          ]),
      GoRoute(
        name: broadcastScheduleRouteName,
        path: '/broadcastSchedule',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: BroadcastSchedule(),
        ),
      ),
      GoRoute(
        name: downloadsRouteName,
        path: '/downloads',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: DownloadScreen(),
        ),
      ),

      //PARTNERSHIP ROUTINGS
      GoRoute(
          name: partnerLoginRouteName,
          path: '/partnerLogin',
          pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: PartnerLogin(),
              ),
          redirect: (BuildContext context, GoRouterState state) async {
            final prefs = await SharedPreferences.getInstance();
            bool loginState = prefs.getBool(loggedInKey) ?? false;
            if (loginState == true) {
              return state.namedLocation(partnershipPageRouteName);
            } else {
              return null;
            }
          },
          routes: [
            GoRoute(
              name: verifyAccountRouteName,
              path: 'verifyAccount',
              pageBuilder: (context, state) => MaterialPage<void>(
                  key: state.pageKey, child: VerifyAccount()),
            ),
            GoRoute(
              name: setNewPasswordRouteName,
              path: 'setNewPassword',
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: SetNewPasssword(),
              ),
            ),
            GoRoute(
              name: resetPasswordRouteName,
              path: 'resetPassword',
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: ResetPasssword(),
              ),
            ),
            GoRoute(
                name: partnerWelcomeRouteName,
                path: 'partnerWelcome',
                pageBuilder: (context, state) => MaterialPage<void>(
                      key: state.pageKey,
                      child: PartnerWelcome(),
                    ),
                routes: [
                  GoRoute(
                    name: partnerRegistrationRouteName,
                    path: 'partnerRegistration',
                    pageBuilder: (context, state) => MaterialPage<void>(
                      key: state.pageKey,
                      child: PartnerRegistration(),
                    ),
                    routes: [
                      // GoRoute(
                      //   name: verifyAccountRouteName,
                      //   path: 'verifyAccount',
                      //   pageBuilder: (context, state) => MaterialPage<void>(
                      //       key: state.pageKey, child: VerifyAccount()),
                      // ),
                    ],
                  ),
                ]),
          ]),

      GoRoute(
          name: partnershipPageRouteName,
          path: '/partnershipPage',
          pageBuilder: (context, state) =>
              MaterialPage<void>(key: state.pageKey, child: PartnershipPage()),
          routes: [
            //PARAMETER PASSING
            GoRoute(
                name: partnershipDetailRouteName,
                path: 'partnershipDetail/:text',
                pageBuilder: (context, state) {
                  return MaterialPage<void>(
                      key: state.pageKey,
                      child: PartnershipDetail(text: state.params['text']!));
                }),
            GoRoute(
                name: profileRouteName,
                path: 'profile',
                pageBuilder: (context, state) => MaterialPage<void>(
                      key: state.pageKey,
                      child: Profile(),
                    ),
                routes: [
                  GoRoute(
                    name: securityRouteName,
                    path: 'security',
                    pageBuilder: (context, state) => MaterialPage<void>(
                        key: state.pageKey, child: Security()),
                  ),
                  GoRoute(
                    name: faqRouteName,
                    path: 'faq',
                    pageBuilder: (context, state) =>
                        MaterialPage<void>(key: state.pageKey, child: FAQ()),
                  ),
                ]),
            GoRoute(
                name: createPartnershipRouteName,
                path: 'createPartnership',
                pageBuilder: (context, state) => MaterialPage<void>(
                      key: state.pageKey,
                      child: CreatePartnership(),
                    ),
                routes: [
                  GoRoute(
                    name: onlinePartnershipRouteName,
                    path: 'onlinePartnership',
                    pageBuilder: (context, state) => MaterialPage<void>(
                      key: state.pageKey,
                      child: OnlinePartnership(),
                    ),
                    redirect:
                        (BuildContext context, GoRouterState state) async {
                      final prefs = await SharedPreferences.getInstance();
                      bool completedTransactionState =
                          prefs.getBool('completedTransaction') ?? false;
                      if (completedTransactionState == true) {
                        return state.namedLocation(congratsRouteName);
                      } else {
                        return null;
                      }
                    },
                  ),
                  GoRoute(
                    name: offlinePartnershipRouteName,
                    path: 'offlinePartnership',
                    pageBuilder: (context, state) => MaterialPage<void>(
                      key: state.pageKey,
                      child: OfflinePartnership(),
                    ),
                  ),
                  GoRoute(
                    name: congratsRouteName,
                    path: 'congrats',
                    pageBuilder: (context, state) => MaterialPage<void>(
                      key: state.pageKey,
                      child: PartnershipCongrats(),
                    ),
                  ),
                ]),
          ]),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),
    // TODO Add Redirect
  );
}
