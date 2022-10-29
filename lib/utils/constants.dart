import 'package:intl/intl.dart';

const String aboutRouteName = 'about';
const String contactRouteName = 'contact';
const String bibleRouteName = 'bible';
const String audioRouteName = 'audioPlayer';
const String homeRouteName = 'home';
const String eventsRouteName = 'events';
const String eventDetailsRouteName = 'eventDetails';
const String testimoniesRouteName = 'testimonies';
const String addTestimonyRouteName = 'addestimony';
const String viewTestimonyRouteName = 'viewTestimony';
const String branchLocatorRouteName = 'branchLocator';
const String broadcastScheduleRouteName = 'broadcastSchedule';
const String branchResultsRouteName = 'branchResults';
const String downloadsRouteName = 'downloads';
const String loggedInKey = 'loggedIn';
const String rootRouteName = 'root';
const String onboardingRouteName = 'onboarding';
const String splashRouteName = 'splash';
const String partnerLoginRouteName = 'partnerLogin';
const String partnerWelcomeRouteName = 'partnerWelcome';
const String partnerRegistrationRouteName = 'partnerRegistration';
const String verifyAccountRouteName = 'verifyAccount';
const String resetPasswordRouteName = 'resetPassword';
const String setNewPasswordRouteName = 'setNewPassword';
const String partnershipPageRouteName = 'partnershipPage';
const String createPartnershipRouteName = 'createPartnership';
const String onlinePartnershipRouteName = 'onlinePartnership';
const String offlinePartnershipRouteName = 'offlinePartnership';
const String partnershipDetailRouteName = 'partnershipDetail';
const String profileRouteName = 'profile';
const String securityRouteName = 'security';
const String faqRouteName = 'faq';
const String congratsRouteName = 'congrats';
const String onlineGivingRouteName = 'onlineGiving';
const String offlineGivingRouteName = 'offlineGiving';
const String onboardedKey = 'onboarded';

const xPadding = 24.0;

class AppConfig {
  static const youtubeAPIKEY = "AIzaSyCBHMm4Ajj9qhx-yTx8nqfYlafhRRYaSvw";
  static const channelId = "UCePZkMO8KURFX34jvJwXhzQ";
  static const okaforPlaylistlId = "UUePZkMO8KURFX34jvJwXhzQ";

  static const host = "https://staging-api.gracenationoffice.com/api/v1";
  static const signup = "$host/auth/signup/partner";
  static const login = "$host/auth/signin";
  static const signout = "$host/auth/signout";
  static const user = "$host/auth/user";
  static const userInfo = "$host/auth/public-info?user=";
  static const verifyAccount = "$host/auth/verify/account/partner";
  static const resendCode = "$host/auth/request/otp/partner";
  static const resetPasswordRequest = "$host/auth/password-reset-request";
  static const resetPassword = "$host/auth/password-reset";
  static const partnerships = "$host/partnerships";
  static const supportTypes = "$host/partnerships/support-types";
  static const initializePayment = "$host/partnerships/initialize-payment";

  static const testimonies = "$host/testimonies";
  static const events = "$host/events";
  static const broadcast = "$host/broadcasts";
  static const prayerRequest = "$host/members/decision-card";

  static const countries = "$host/resources/countries";
  static const preferences = "$host/resources/preferences";
  static const states = "$host/resources/states";
  static const branches = "$host/resources/branches";

  static const notifications = "$host/notifications";

  String formatDate(DateTime date, [bool first = false]) {
    var suffix = "th";
    var digit = DateTime.now().day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    return first
        ? DateFormat("d'$suffix'").format(date)
        : DateFormat("d'$suffix' MMM").format(date);
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    String hourString = duration.inHours == 0
        ? ''
        : ('${int.parse(twoDigits(duration.inHours))}h ');
    String minuteString = int.parse(twoDigitMinutes) == 0
        ? ''
        : ('${int.parse(twoDigitMinutes)}m ');
    return "$hourString$minuteString${int.parse(twoDigitSeconds)}s";
  }

  String numberDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    String hourString =
        duration.inHours == 0 ? '' : ('${twoDigits(duration.inHours)}:');
    String minuteString =
        int.parse(twoDigitMinutes) == 0 ? '' : ('$twoDigitMinutes:');
    return "$hourString$minuteString$twoDigitSeconds";
  }
}
