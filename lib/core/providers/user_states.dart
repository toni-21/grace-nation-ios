import 'package:flutter/material.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState extends ChangeNotifier {
  final SharedPreferences prefs;
  bool _onboarded = false;
  bool _audioClick = false;

  LoginState(this.prefs) {
    onboarded = prefs.getBool(onboardedKey) ?? false;
    audioClick = prefs.getBool(audioClickKey) ?? false;
  }

  bool get onboarded => _onboarded;
  bool get audioClick => _audioClick;
  set onboarded(bool value) {
    _onboarded = value;
    prefs.setBool(onboardedKey, value);
    notifyListeners();
  }

  set audioClick(bool value) {
    _audioClick = value;
    prefs.setBool(audioClickKey, value);
    notifyListeners();
  }

  void checkLoggedIn() {
    // final prefs = await SharedPreferences.getInstance();
    onboarded = prefs.getBool(onboardedKey) ?? false;
  }
}
