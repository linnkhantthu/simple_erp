import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:simple_erp/configs.dart';
import 'package:simple_erp/users/Objects/ErrorMessage.dart';
import 'package:simple_erp/users/Objects/User.dart';

final box = GetStorage();

Future<Object> registerUser(
    String firstName, String lastName, String mail, String password) async {
  final url = Uri.parse("${Config.apiURI}/register");
  final headers = {
    "Content-Type": "application/json",
  };
  Map<String, dynamic> body = {
    'firstName': firstName,
    'lastName': lastName,
    'mail': mail,
    'password': password,
  };
  final encoding = Encoding.getByName('utf-8');
  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
      encoding: encoding,
    );
    dynamic jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonBody['status']) {
        return User.fromJson(jsonBody['data']);
      } else {
        return ErrorText.fromJson(jsonBody['data']);
      }
    } else {
      return const ErrorText(message: "404 not Found");
    }
  } catch (e) {
    return const ErrorText(message: "Connection Refused");
  }
}

Future<Object> loginUser(String mail, String password) async {
  final url = Uri.parse("${Config.apiURI}/login");
  final headers = {
    "Content-Type": "application/json",
  };
  Map<String, dynamic> body = {
    'mail': mail,
    'password': password,
  };
  final encoding = Encoding.getByName('utf-8');
  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
      encoding: encoding,
    );
    dynamic jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonBody['status']) {
        return User.fromJson(jsonBody['data']);
      } else {
        return ErrorText.fromJson(jsonBody['data']);
      }
    } else {
      // throw Exception("404 not Found");
      return const ErrorText(message: "404 not Dound");
    }
  } catch (e) {
    return const ErrorText(message: "Connection Refused");
  }
}

void setCurrentUser(String key, value) {
  box.write(key, value);
}

Object? getCurrentUser(String key) {
  var ans = box.read(key);
  if (ans == null) {
    return const ErrorText(message: "You need to login first");
  } else {
    return User.fromJson(ans);
  }
}

Future<void> removeCurrentUser(String key) async {
  await box.remove(key);
}
