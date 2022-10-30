import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:audio_service/audio_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:grace_nation/core/models/download_info.dart';
import 'package:grace_nation/core/models/event.dart';
import 'package:grace_nation/core/models/notes_model.dart';
import 'package:grace_nation/core/models/partnership.dart';
import 'package:grace_nation/core/models/payment_model.dart';
import 'package:grace_nation/core/models/preferences.dart';
import 'package:grace_nation/core/models/testimonies.dart';
import 'package:grace_nation/core/models/video.dart';
import 'package:grace_nation/core/services/notes_db_worker.dart';
import 'package:grace_nation/core/services/preferences.dart';
import 'package:grace_nation/core/services/resources.dart';
import 'package:grace_nation/core/services/testimonies.dart';
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
  //final AudioPlayer _audioPlayer = AudioPlayer();
  AudioHandler? _audioHandler;
  int _selectedTab = 0;
  PaymentInit? _payInit;
  String? _givingType;
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

  String get givingType {
    return _givingType!;
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

  void setGivingType(String g) {
    _givingType = g;
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

  //DOWNLOAD VALUES
  String? currentDownloadId;
  List<TaskInfo>? _tasks;
  final ReceivePort _port = ReceivePort();

  final resources = ResourcesApi();
  void bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      unbindBackgroundIsolate();
      bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      print(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );
      currentDownloadId = taskId;
      setDownloading(true);
      setProgressString("${progress.toString()}%");

      if (progress == -1) {
        setProgressString("Failed");
        resources.deleteDownload(taskId);
        currentDownloadId = null;
        Future.delayed(Duration(milliseconds: 1500), () {
          setDownloading(false);
        });

        print("Download has finished and is saved at ");
      }

      if (status == DownloadTaskStatus.complete) {
        setProgressString("Completed");
        currentDownloadId = null;
        Future.delayed(Duration(milliseconds: 1500), () {
          setDownloading(false);
        });

        print("Download has finished and is saved at ");
      }

      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == taskId);

        task
          ..status = status
          ..progress = progress;
        notifyListeners();
      }
    });
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }
}
