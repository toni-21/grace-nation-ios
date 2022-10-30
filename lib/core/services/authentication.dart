import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  Future<String> signUp(
      {required String email,
      required String phoneNumber,
      required String password,
      required String passwordConfirmation,
      required bool alreadyAMember,
      required String firstName,
      required String lastName}) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
      // "Access-Control-Allow-Origin": "*",
    };
    String defaultCountryCode = "+234";
    if (phoneNumber.startsWith("0")) {
      phoneNumber = phoneNumber.replaceFirst("0", defaultCountryCode);
      print(phoneNumber);
    } else {
      phoneNumber = defaultCountryCode + phoneNumber;
    }

    Map<String, dynamic> body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone": phoneNumber,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "already_a_member": alreadyAMember
    };
    try {
      debugPrint(' trying this request... $body');
      debugPrint(' endpoint is ${AppConfig.signup}');
      final response = await http.post(
        Uri.parse(AppConfig.signup),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      String? message = decodedResponse["message"].toString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("SIGNUP SUCCESSFUL");
        return "success";
      } else {
        debugPrint("SIGNUP FAILED");
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<Map<String, dynamic>> login({
    required String emailId,
    required String password,
  }) async {
    Map<String, dynamic> map = {};
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    };

    Map<String, dynamic> body = {
      "user": emailId,
      "password": password,
      "device_name": "Postman"
    };
    try {
      debugPrint(' trying this request... $body');
      debugPrint(' endpoint is ${AppConfig.login}');
      final response = await http.post(
        Uri.parse(AppConfig.login),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final Map<String, dynamic> decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List roles = decodedResponse['data']['user']['roles'];
        if (roles.contains('partner')) {
          debugPrint("LOGIN SUCCESSFUL");
          map = {'message': 'success', 'data': decodedResponse['data']};
          return map;
        } else {
          debugPrint("LOGIN FAILED");
          map = {
            'message': "User does have the role of 'partner'",
          };
          return map;
        }
      } else {
        debugPrint("LOGIN FAILED");
        map = {'message': decodedResponse['message']};
        return map;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<Map<String, dynamic>> membershipCheck({
    required String emailId,
  }) async {
    Map<String, dynamic> map = {};
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    };

    try {
      debugPrint(' endpoint is ${AppConfig.userInfo}');
      final response = await http.get(
        Uri.parse(AppConfig.userInfo + emailId),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("MEMBERSHIP CORRECT");
        map = decodedResponse['data'];
        return map;
      } else {
        debugPrint("MEMBERSHIP FAILED");
        return map;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> verifyAccount({
    required String email,
    required int otp,
  }) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    };
    Map<String, dynamic> body = {
      "email": email,
      "otp": otp,
    };
    try {
      debugPrint(' endpoint is ${AppConfig.verifyAccount}');
      final response = await http.post(
        Uri.parse(AppConfig.verifyAccount),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("VERIFICATION SUCCESSFUL");
        String message = 'success';
        return message;
      } else {
        debugPrint("VERIFICATION FAILED");
        String message = decodedResponse["message"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> resendVerification({
    required String email,
  }) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    };
    Map<String, dynamic> body = {
      "user": email,
    };
    try {
      debugPrint(' endpoint is ${AppConfig.resendCode}');
      final response = await http.post(
        Uri.parse(AppConfig.resendCode),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("VERIFICATION SUCCESSFUL");
        String message = 'success';
        return message;
      } else {
        debugPrint("VERIFICATION FAILED");
        String message = decodedResponse["message"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> requestPassswordReset({
    required String email,
  }) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    };
    Map<String, dynamic> body = {
      "email": email,
    };
    try {
      debugPrint(' endpoint is ${AppConfig.resetPasswordRequest}');
      final response = await http.post(
        Uri.parse(AppConfig.resetPasswordRequest),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("RESET REQUEST SUCCESSFUL");
        String message = 'success';
        return message;
      } else {
        debugPrint("RESET REQUEST FAILED");
        String message = decodedResponse["message"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> resetPassword(
      {required String token,
      required String password,
      required String passwordConfirmation}) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    };
    Map<String, dynamic> body = {
      "token": token,
      "password": password,
      "password_confirmation": passwordConfirmation
    };
    try {
      debugPrint(' endpoint is ${AppConfig.resetPassword}');
      final response = await http.post(
        Uri.parse(AppConfig.resetPassword),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("PASSWORD RESET SUCCESSFUL");
        String message = 'success';
        return message;
      } else {
        debugPrint("PASSWORD RESET FAILED");
        String message = decodedResponse["message"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> signout() async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      debugPrint(' endpoint is ${AppConfig.signout}');
      final response = await http.post(
        Uri.parse(AppConfig.signout),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          decodedResponse["message"] == "Sign out successful") {
        debugPrint("SIGNOUT SUCCESSFUL");
        String message = 'success';
        return message;
      } else {
        debugPrint("SIGNOUT FAILED");
        String message = decodedResponse["message"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      debugPrint(' endpoint is ${AppConfig.user}');
      final response = await http.get(
        Uri.parse(AppConfig.user),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("USER DETAILS FETCH SUCCESSFUL");
        Map<String, dynamic> map = {
          'message': 'success',
          'data': decodedResponse['data'],
          'token': accessToken
        };
        return map;
      } else {
        debugPrint("USER DETAILS FETCH FAILED");
        Map<String, dynamic> map = {'message': decodedResponse['message']};
        return map;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> updateAvatar({required PlatformFile file}) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      if (file.path == "" || file.path == null) {
        return "No file provided";
      }
      print('REQEST IS ..${AppConfig.user}/avatar');
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('${AppConfig.user}/avatar'),
      );

      var text = await http.MultipartFile.fromPath(
        "avatar",
        file.path!,
        filename: file.name,
      );
      request.headers.addAll(requestHeaders);
      request.files.add(text);
      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);
      print(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("UPDATE SUCCESSFUL");
        return 'success';
      } else {
        print(response.statusCode);
        print("UPDATE FAILED");
        return responseData['message'];
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
    required String phone,
    required String lastName,
    required String firstName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";

    Map<String, dynamic> body = {
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "new_password": newPassword,
      "old_password": oldPassword,
    };

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      debugPrint(' endpoint is ${AppConfig.user}');
      final response = await http.patch(
        Uri.parse(AppConfig.user),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final Map<String, dynamic> decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // List roles = decodedResponse['data']['user']['roles'];
        // if (roles.contains('partner')) {
        //   debugPrint("PASSWORD CHANGE SUCCESSFUL");
        //   return 'success';
        // } else {
        //   debugPrint("PASSWORD CHANGE FAILED");
        //   return decodedResponse['message'];
        // }
        debugPrint("PASSWORD CHANGE SUCCESSFUL");
        return 'success';
      } else {
        debugPrint("PASSWORD CHANGE FAILED");
        return decodedResponse['message'];
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
