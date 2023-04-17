import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hospital/models/patient.dart';
import 'package:hospital/models/patient_data.dart';
import 'package:hospital/screens/log_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class ApiCalls extends GetxController {
  String _token = '';
  RxBool isLoggedIn = false.obs;
  List<Patient> patientList = [].obs.cast<Patient>().toList();
  RxMap patient = {}.obs;
  String get token {
    return _token;
  }

  bool get isAuth {
    if (_token != '') {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, String>> getHeaders(var token) async {
    print('getting token $token');

    if (token == '') {
      var token = await getToken();
      print('calling token $token');
      if (token == '') {
        Get.offAllNamed(LogInPage.routeName);
        return {};
      }
      return {
        'Content-type': 'application/json; charset=utf-8',
        'Authorization': 'Token $token',
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      };
    } else {
      return {
        'Content-type': 'application/json; charset=utf-8',
        'Authorization': 'Token $token',
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      };
    }
  }

  Map<String, String> authHeaders() {
    return {
      'Content-type': 'application/json; charset=utf-8',
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials":
          "true", // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
    };
  }

  Future<int> authenticate(String url, var body) async {
    var urlLink = Uri.parse(url);

    try {
      http.Response response = await http.post(
        urlLink,
        headers: authHeaders(),
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        var sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString(
            'Token', jsonEncode({'Key': responseData['key']}));
      } else if (response.statusCode == 400) {
        var responseData = jsonDecode(response.body);
        Get.snackbar('', 'user name is already used');
        EasyLoading.dismiss();
      }

      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      return response.statusCode;
    } catch (e) {
      // catchException(e);
      // EasyLoading.dismiss();
      rethrow;
    }
  }

  Future<int> logIn(String url, var body) async {
    var urlLink = Uri.parse(url);

    try {
      http.Response response = await http.post(
        urlLink,
        headers: authHeaders(),
        body: json.encode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString(
            'Token', jsonEncode({'Key': responseData['key']}));
      } else if (response.statusCode == 400) {
        Get.snackbar('', 'Unable to log in with the provided credentials',
            backgroundColor: Colors.blue);
      } else {
        Get.snackbar('', 'Unable to log Something went wrong',
            backgroundColor: Colors.blue);
      }

      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      return response.statusCode;
    } catch (e) {
      // catchException(e);
      // EasyLoading.dismiss();
      rethrow;
    }
  }

  Future<int> getPatientList(String url) async {
    var urlLink = Uri.parse(url);
    try {
      var headers = await getHeaders(_token);
      log(headers.toString());
      http.Response response = await http.get(
        urlLink,
        headers: headers,
      );
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        log(response.body);
        var responseData = jsonDecode(response.body);
        List<Patient> temp = [];
        for (var data in responseData) {
          temp.add(
            Patient(
              patientName: data['Patient_Name'],
              id: data['id'],
              visited: data['Visited'],
            ),
          );
        }

        patientList = temp;
      }

      return response.statusCode;
    } catch (e) {
      log(e.toString());
      // catchException(e);
      // EasyLoading.dismiss();
      rethrow;
    }
  }

  Future<int> getPatientDetails(String url) async {
    var urlLink = Uri.parse(url);
    try {
      var headers = await getHeaders(_token);

      http.Response response = await http.get(
        urlLink,
        headers: headers,
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        patient.value = responseData;
        // List<Patient> temp = [];
        // for (var data in responseData) {
        //   temp.add(
        //     Patient(
        //       patientName: data['Patient_Name'],
        //       id: data['id'],
        //       visited: data['Visited'],
        //     ),
        //   );
        // }

        // patientList = temp;
      }

      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      return response.statusCode;
    } catch (e) {
      // catchException(e);
      // EasyLoading.dismiss();
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCurrentUsertDetails(String url) async {
    var urlLink = Uri.parse(url);
    try {
      var headers = await getHeaders(_token);

      http.Response response = await http.get(
        urlLink,
        headers: headers,
      );

      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // List<Patient> temp = [];
        // for (var data in responseData) {
        //   temp.add(
        //     Patient(
        //       patientName: data['Patient_Name'],
        //       id: data['id'],
        //       visited: data['Visited'],
        //     ),
        //   );
        // }

        // patientList = temp;
        return {'Status_Code': response.statusCode, 'Body': responseData};
      }

      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      return {'Status_Code': response.statusCode, 'Body': {}};
    } catch (e) {
      // catchException(e);
      // EasyLoading.dismiss();
      rethrow;
    }
  }

  Future<int> addClient(String url, var body) async {
    var urlLink = Uri.parse(url);
    try {
      var headers = await getHeaders(_token);

      http.Response response = await http.post(
        urlLink,
        headers: headers,
        body: jsonEncode(body),
      );

      // if (response.statusCode == 200) {
      //   var responseData = jsonDecode(response.body);
      //   // patient.value = responseData;
      //   // List<Patient> temp = [];
      //   // for (var data in responseData) {
      //   //   temp.add(
      //   //     Patient(
      //   //       patientName: data['Patient_Name'],
      //   //       id: data['id'],
      //   //       visited: data['Visited'],
      //   //     ),
      //   //   );
      //   // }

      //   // patientList = temp;
      // }

      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      return response.statusCode;
    } catch (e) {
      // catchException(e);
      // EasyLoading.dismiss();
      rethrow;
    }
  }

  Future<bool> tryAutoLogIn() async {
    log('trying auto login');
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('Token') != true) {
      return false;
    } else {
      var extratedData = sharedPreferences.getString('Token');
      var data = jsonDecode(extratedData!);
      _token = data['Key'];
      isLoggedIn.value = true;
      log('returning value');
      return true;
    }
  }

  Future<bool> clearLogIn() async {
    log('trying auto login');
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('Token') != true) {
      _token = '';
      return false;
    } else {
      _token = '';

      sharedPreferences.remove('Token');

      return true;
    }
  }

  Future<String> getToken() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('Token') != true) {
      return '';
    } else {
      var extratedData = sharedPreferences.getString('Token');
      var data = jsonDecode(extratedData!);
      _token = data['Key'];
      isLoggedIn.value = true;
      return data['Key'];
    }
  }

  Future<int> uploadFile(
      String url, var data, var image, var name, var fileType) async {
    var urlLink = Uri.parse(url);
    var headers = await getHeaders(_token);
    try {
      http.MultipartRequest request = http.MultipartRequest('POST', urlLink);
      request.headers.addAll(headers);
      request.files.add(
        http.MultipartFile.fromBytes(
          'Instruction_File',
          image,
          filename: name,
        ),
      );
      request.fields['Patient_Name'] = data['Patient_Name'].toString();
      request.fields['Age'] = data['Age'].toString();
      request.fields['Complaint'] = data['Complaint'].toString();
      request.fields['Gender'] = data['Gender'].toString();
      request.fields['Instructions'] = data['Instructions'].toString();
      request.fields['Client'] = data['Client'].toString();

      var res = await request.send();
      log(res.statusCode.toString());
      log(res.stream.toString());
      var response = await http.Response.fromStream(res);
      log(response.body.toString());
      // if (res.statusCode == 200 || res.statusCode == 201) {
      //   var response = await http.Response.fromStream(res);

      //   var data = jsonDecode(response.body);

      //   return res.statusCode;
      // }

      return res.statusCode;
    } catch (e) {
      // catchException(e);
      // EasyLoading.dismiss();
      rethrow;
    }
  }
}
