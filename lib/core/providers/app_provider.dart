import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:audio_service/audio_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:grace_nation/core/models/download_info.dart';
import 'package:grace_nation/core/models/event.dart';
import 'package:grace_nation/core/models/giving_model.dart';
import 'package:grace_nation/core/models/notes_model.dart';
import 'package:grace_nation/core/models/notification.dart';
import 'package:grace_nation/core/models/partnership.dart';
import 'package:grace_nation/core/models/payment_model.dart';
import 'package:grace_nation/core/models/preferences.dart';
import 'package:grace_nation/core/models/testimonies.dart';
import 'package:grace_nation/core/models/video.dart';
import 'package:grace_nation/core/services/notes_db_worker.dart';
import 'package:grace_nation/core/services/preferences.dart';
import 'package:grace_nation/core/services/resources.dart';
import 'package:grace_nation/core/services/testimonies.dart';
import 'package:grace_nation/core/services/notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTab {
  static const int home = 0;
  static const int messages = 1;
  static const int liveTV = 2;
  static const int give = 3;
}

class ApDrawer {
  static const int home = 0;
  static const int messages = 1;
  static const int liveTV = 2;
  static const int give = 3;
}

class AppProvider extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final prefApi = PreferencesApi();
  final notApi = NotificationsApi();
  //final AudioPlayer _audioPlayer = AudioPlayer();
  AudioHandler? _audioHandler;
  int _selectedTab = 0;
  PaymentInit? _payInit;
  GivingInit? _givingPayInit;
  int? _givingTypeId;
  int _selectedDrawer = 0;
  bool _enableNotifications = true;
  bool _isLoading = false;
  bool _downloading = false;
  String? _progressString;
  Partnership? _selectedPartnership;
  Testimony? _selectedTestimony;
  Event? _selectedEvent;
  Video? _selectedVideo;
  List<Video> _selectedVideoList = [];
  Map<String, dynamic>? _branchSearch;
  Note? _selectedNote;
  int _noteStackIndex = 0;
  TextEditingController? titleEditingController;
  TextEditingController? contentEditingController;
  Preferences? _preferences;
  List<Notifications> _notificationList = [];

  AudioHandler get audioHandler {
    return _audioHandler!;
  }

  void setAudioHandler(AudioHandler a) {
    print("HANDLER HAS BEEN SET");
    _audioHandler = a;
  }

  List? _noteList;

  List<Testimony>? _testimonies;

  List<Event>? _events;

  int get getSelectedTab => _selectedTab;

  int get getSelectedDrawer => _selectedDrawer;

  String get progressString => _progressString ?? "";

  bool get downloading {
    return _downloading;
  }

  bool get enableNotifications => _enableNotifications;

  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }

  void goToDrawer(index) {
    _selectedDrawer = index;
    notifyListeners();
  }

  List<Testimony> get testimonies {
    return _testimonies!;
  }

  Testimony get selectedTestimony {
    return _selectedTestimony!;
  }

  Event get selectedEvent {
    return _selectedEvent!;
  }

  List<Event> get events {
    return _events!;
  }

  Partnership get selectedPartnership {
    return _selectedPartnership!;
  }

  PaymentInit get paymentInit {
    return _payInit!;
  }

  GivingInit get givingInit {
    return _givingPayInit!;
  }

  int get givingTypeId {
    return _givingTypeId!;
  }

  Map<String, dynamic> get branchSearch {
    return _branchSearch!;
  }

  Video get selectedVideo {
    return _selectedVideo!;
  }

  List<Video> get selectedVideoList {
    return _selectedVideoList;
  }

  List get noteList {
    return _noteList ?? [];
  }

  Note get selectedNote {
    return _selectedNote ?? Note();
  }

  int get noteStackIndex {
    return _noteStackIndex;
  }

  Preferences get preferences {
    return _preferences!;
  }

  List<Notifications> get notificationList {
    return _notificationList;
  }

  String get player => '''
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            html,
            body {
                margin: 0;
                padding: 0;
                background-color: #000000;
                height: 100%;
                width: 100%;
            }
        </style>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
    </head>
    <body>
    ${_preferences!.embedCode}
    </body>
    </html>
  ''';

  void setNotifications(bool n) async {
    _enableNotifications = n;
    notifyListeners();
  }

  void loadNoteList() async {
    _noteList = await NotesDBWorker.db.getAll();
    notifyListeners();
  }

  Future<void> setPreferences() async {
    _preferences = await prefApi.getPreferences();
    notifyListeners();
  }

  Future<void> setNotificationList() async {
    _notificationList = await notApi.getNotifications();
    notifyListeners();
  }

  Future<Preferences> getPreferences() async {
    _preferences = await prefApi.getPreferences();
    notifyListeners();
    return _preferences!;
  }

  void selectNoteBeingEdited(Note n) async {
    _selectedNote = n; //await NotesDBWorker.db.get(id);
    titleEditingController = TextEditingController(text: n.title ?? "");
    contentEditingController = TextEditingController(text: n.content ?? "");
    notifyListeners();
  }

  void setNoteStackIndex(int inStackIndex) {
    _noteStackIndex = inStackIndex;
    notifyListeners();
  }

  void selectPartnership(Partnership p) {
    _selectedPartnership = p;
    notifyListeners();
  }

  void initPayment(PaymentInit pay) {
    _payInit = pay;
    notifyListeners();
  }

  void givingInitPayment(GivingInit gi) {
    _givingPayInit = gi;
    notifyListeners();
  }

  void setGivingTypeId(int g) {
    _givingTypeId = g;
    notifyListeners();
  }

  void setTestimoniesList(List<Testimony> t) {
    _testimonies = t;
    notifyListeners();
  }

  void selectTestimony(Testimony t) {
    _selectedTestimony = t;
    notifyListeners();
  }

  void setEventsList(List<Event> e) {
    _events = e;
    notifyListeners();
  }

  void selectEvent(Event e) {
    _selectedEvent = e;
    notifyListeners();
  }

  void setbranchValues(
      {required int countryId, required int stateId, String? area}) {
    _branchSearch = {
      'countryId': countryId,
      'stateId': stateId,
      'area': area,
    };
    notifyListeners();
  }

  void selectVideo(Video v) {
    _selectedVideo = v;
    notifyListeners();
  }

  void selectVideoList(List<Video> l, int limit) {
    _selectedVideoList = l.getRange(0, limit + 1).toList();
    _selectedVideoList = l;
    notifyListeners();
  }

  void beginPaymentState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('completedTransaction', false);
    notifyListeners();
  }

  void endPaymentState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('completedTransaction', true);
    notifyListeners();
  }

  void nullifyPaymentState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('completedTransaction');
    notifyListeners();
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<String> addTestimony({
    required String title,
    required String description,
    required String testifier,
    required String email,
    PlatformFile? image,
    PlatformFile? video,
  }) async {
    _isLoading = true;
    notifyListeners();
    final tesApi = TestimoniesApi();
    String message = await tesApi.newTestimony(
        title: title,
        description: description,
        testifier: testifier,
        email: email,
        image: image,
        video: video);
    if (message == 'success') {
    } else {}
    _isLoading = false;
    notifyListeners();
    return message;
  }

  setDownloading(bool d) {
    _downloading = d;
    notifyListeners();
  }

  setProgressString(String p) {
    _progressString = p;
    notifyListeners();
  }

  //Notification Handlers
  fetchNewTestimonyNotifications(List<Testimony> _testimonies) async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < _testimonies.length; i++) {
      final testimony = _testimonies[i];
      bool exists = prefs.containsKey(testimony.uuid);

      String timeText = testimony.createdAt;
      final DateFormat dateFormate = DateFormat('MM/dd/yyyy hh:mm a');
      final newdate = dateFormate.parse(timeText);
      final Duration timeDuration = now.difference(newdate);
      int daysDifference = timeDuration.inDays;

      if (!exists && daysDifference <= 7) {
        final newTestimonyNotification = Notifications(
            id: testimony.uuid,
            message: testimony.title,
            type: 'testimony',
            createdAt: testimony.createdAt,
            object: testimony);
        print("TESTIMONY .. ${testimony.title} is a new one!!");
        final String nullNotification = Notifications().toString();

        Notifications? n = _notificationList.firstWhere(
            (item) =>
                item.id == newTestimonyNotification.id &&
                item.message == newTestimonyNotification.message &&
                item.createdAt == newTestimonyNotification.createdAt,
            orElse: () => Notifications());
        if (n.toString() == nullNotification) {
          _notificationList.add(newTestimonyNotification);
          print(
              "NOTIFICATION HAS BEEN ADDED THAT ID IS .. ${newTestimonyNotification.id}");
          notifyListeners();
        }
      } else {}
    }
    notifyListeners();
  }

  cacheTestimony(Testimony t) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("${t.uuid}", "saved");
    _notificationList.removeWhere((item) =>
        item.id == t.uuid &&
        item.message == t.title &&
        item.createdAt == t.createdAt);
    // Notifications? n = notificationList.firstWhere(
    //     (item) =>
    //         item.id == t.uuid &&
    //         item.message == t.title &&
    //         item.createdAt == t.createdAt,
    //     orElse: () => Notifications());
    //n.readAt = DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now());
    //notificationList.remove(Notifications(id: t.uuid));

    notifyListeners();
  }

  fetchNewEventNotifications(List<Event> _events) async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < _events.length; i++) {
      final event = _events[i];
      bool exists = prefs.containsKey(event.uuid);

      String timeText = event.createdAt!;
      final DateFormat dateFormate = DateFormat('MM/dd/yyyy hh:mm a');
      final newdate = dateFormate.parse(timeText);
      final Duration timeDuration = now.difference(newdate);
      int daysDifference = timeDuration.inDays;

      if (!exists && daysDifference <= 31) {
        final newEventNotification = Notifications(
            id: event.uuid,
            message: event.title,
            type: 'event',
            createdAt: event.createdAt,
            object: event);
        print("EVENT .. ${event.title} is a new one!!");
        final String nullNotification = Notifications().toString();

        Notifications? n = _notificationList.firstWhere(
            (item) =>
                item.id == newEventNotification.id &&
                item.message == newEventNotification.message &&
                item.createdAt == newEventNotification.createdAt,
            orElse: () => Notifications());
        if (n.toString() == nullNotification) {
          _notificationList.add(newEventNotification);
          print(
              "NOTIFICATION HAS BEEN ADDED THAT ID IS .. ${newEventNotification.id}");
          notifyListeners();
        }
      } else {}
    }
    notifyListeners();
  }

  cacheEvent(Event e) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("${e.uuid}", "saved");
    _notificationList.removeWhere((item) =>
        item.id == e.uuid &&
        item.message == e.title &&
        item.createdAt == e.createdAt);
    // Notifications? n = notificationList.firstWhere(
    //     (item) =>
    //         item.id == t.uuid &&
    //         item.message == t.title &&
    //         item.createdAt == t.createdAt,
    //     orElse: () => Notifications());
    //n.readAt = DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now());
    //notificationList.remove(Notifications(id: t.uuid));

    notifyListeners();
  }

  clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < _notificationList.length; i++) {
      final n = _notificationList[i];
      prefs.setString("${n.id}", "saved");
    }
    _notificationList = [];
    notifyListeners();
  }
}
