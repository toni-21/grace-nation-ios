import 'package:flutter/material.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState extends ChangeNotifier {
  final SharedPreferences prefs;
  bool _onboarded = false;

  LoginState(this.prefs) {
    onboarded = prefs.getBool(onboardedKey) ?? false;
    //onboarded = prefs.getBool(onboardedKey) ?? false;
  }

  bool get onboarded => _onboarded;
  set onboarded(bool value) {
    _onboarded = value;
    prefs.setBool(onboardedKey, value);
    notifyListeners();
  }

  void checkLoggedIn() {
    // final prefs = await SharedPreferences.getInstance();
    onboarded = prefs.getBool(onboardedKey) ?? false;
  }
}
