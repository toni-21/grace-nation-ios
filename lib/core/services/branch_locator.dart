import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/core/models/country.dart';
import 'package:grace_nation/core/models/state.dart';
import 'package:grace_nation/core/models/branch.dart';

class BranchLocator {
  Future<List<Country>> getCountries() async {
    List<Country> result = [];
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
    };
    try {
      debugPrint(' endpoint is ${AppConfig.countries}');
      final response = await http.get(
        Uri.parse(AppConfig.countries),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("COUNTRIES LIST SUCCESSFUL");

        final List data = decodedResponse['data'];
        for (int i = 0; i < data.length; i++) {
          Map<String, dynamic> map = data[i];
          final newCountry = Country.fromJson(map);
          result.add(newCountry);
        }
        return result;
      } else {
        debugPrint("COUNTRIES LIST FAILED");
        print(decodedResponse["message"]);
        return result;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<List<States>> getStates({required int countryId}) async {
    List<States> result = [];
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
    };
    try {
      debugPrint(' endpoint is ${AppConfig.states}');
      final response = await http.get(
        Uri.parse('${AppConfig.states}?country_id=$countryId'),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("STATES LIST SUCCESSFUL");

        final List data = decodedResponse['data'];
        for (int i = 0; i < data.length; i++) {
          Map<String, dynamic> map = data[i];
          final newState = States.fromJson(map);
          result.add(newState);
        }
        return result;
      } else {
        debugPrint("STATES LIST FAILED");
        print(decodedResponse["message"]);
        return result;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<List<Branch>> getBranches(
      {required int countryId, required int stateId, String? area}) async {
    List<Branch> result = [];
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
    };
    try {
      debugPrint(' endpoint is ${AppConfig.branches}?country_id=$countryId&state_id=$stateId&area=$area');
      final response = await http.get(
        Uri.parse(
            '${AppConfig.branches}?country_id=$countryId&state_id=$stateId&area=$area'),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("BRANCHES LIST SUCCESSFUL");

        final List data = decodedResponse['data'];
        for (int i = 0; i < data.length; i++) {
          Map<String, dynamic> map = data[i];
          final newState = Branch.fromJson(map);
          result.add(newState);
        }
        return result;
      } else {
        debugPrint("BRANCHES LIST FAILED");
        print(decodedResponse["message"]);
        return result;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
