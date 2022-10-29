import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/user.dart';
import 'package:grace_nation/core/services/authentication.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final authApi = AuthApi();
  User? _authenticatedUser;
  bool _isLoading = false;
  List<String> supportTypes = [];

  User get user {
    return _authenticatedUser!;
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<String> verify({
    required int otp,
    required String email,
  }) async {
    _isLoading = true;
    notifyListeners();
    String message = await authApi.verifyAccount(
      email: email, //_authenticatedUser ?? "",
      otp: otp,
    );
    _isLoading = false;
    notifyListeners();
    return message;
  }

  Future<String> login({
    required String emailId,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> response = await authApi.login(
      emailId: emailId,
      password: password,
    );
    if (response['message'] == 'success') {
      _authenticatedUser = User.fromJson(response['data']);
      print(
          'LOGGED USER IS ${_authenticatedUser!.firstName} and token is ${_authenticatedUser!.accessToken}');
      prefs.setString('firstName', _authenticatedUser!.firstName);
      prefs.setString('lastName', _authenticatedUser!.lastName);
      prefs.setString('email', _authenticatedUser!.email);
      prefs.setInt('id', _authenticatedUser!.id!);
      prefs.setString('uuid', _authenticatedUser!.uuid!);
      prefs.setString('phone', _authenticatedUser!.phone!);
      prefs.setString('avatar', _authenticatedUser!.avatar ?? "");
      prefs.setString('memberId', _authenticatedUser!.memberId ?? "");
      prefs.setString('accessToken', _authenticatedUser!.accessToken);
      prefs.setBool('loggedIn', true);
    } else {}
    _isLoading = false;
    notifyListeners();
    return response['message'];
  }

  void setAuth() async {
    final prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool(loggedInKey) ?? false;
    if (loggedIn) {
      _authenticatedUser = User(
        firstName: prefs.getString('firstName') ?? '',
        lastName: prefs.getString('lastName') ?? '',
        email: prefs.getString('email') ?? '',
        phone: prefs.getString('phone') ?? '',
        memberId: prefs.getString('memberId') ?? '',
        avatar: prefs.getString('avatar') ?? '',
        uuid: prefs.getString('uuid') ?? '',
        id: prefs.getInt('id'),
        accessToken: prefs.getString('accessToken') ?? '',
      );
      print("USER VALUES SET..${_authenticatedUser!.accessToken}");
      notifyListeners();
    } else {
      print('USER VALUES NOT FOUND');
    }
  }

  void preserveAvatar(String path) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('avatar', path);
    notifyListeners();
  }

  Future<String> signUp({
    required String email,
    required String password,
    required String phoneNumber,
    required String passwordConfirmation,
    required bool alreadyAMember,
    required String firstName,
    required String lastName,
  }) async {
    _isLoading = true;
    notifyListeners();
    String message = await authApi.signUp(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        alreadyAMember: alreadyAMember,
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName);
    if (message == 'success') {
    } else {}
    _isLoading = false;
    notifyListeners();
    return message;
  }

  Future<String> signout() async {
    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    String response = await authApi.signout();
    if (response == 'success') {
      prefs.remove('firstName');
      prefs.remove('lastName');
      prefs.remove('email');
      prefs.remove('phone');
      prefs.remove('accessToken');

      //NON USER VALUES
      prefs.remove('loggedIn');
    } else {}
    _isLoading = false;
    notifyListeners();
    return response;
  }

  Future<String> getUSerDetails() async {
    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> response = await authApi.getUserDetails();
    if (response['message'] == 'success') {
      _authenticatedUser =
          User.fromUserJson(response['data'], response['token']);
      print(
          'LOGGED USER IS ${_authenticatedUser!.firstName} and token is ${_authenticatedUser!.accessToken}');
      prefs.setString('firstName', _authenticatedUser!.firstName);
      prefs.setString('lastName', _authenticatedUser!.lastName);
      prefs.setString('email', _authenticatedUser!.email);
      prefs.setInt('id', _authenticatedUser!.id!);
      prefs.setString('uuid', _authenticatedUser!.uuid!);
      prefs.setString('phone', _authenticatedUser!.phone!);
      prefs.setString('avatar', _authenticatedUser!.avatar ?? "");
      prefs.setString('memberId', _authenticatedUser!.memberId!);
      prefs.setString('accessToken', _authenticatedUser!.accessToken);
      prefs.setBool('loggedIn', true);
    } else {}
    _isLoading = false;
    notifyListeners();
    return response['message'];
  }

  void toggleIsLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
