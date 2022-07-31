import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:simple_erp/users/Objects/ErrorMessage.dart';
import 'package:simple_erp/users/Objects/User.dart';

var protocol = dotenv.env['PROTOCOL'];
var hostname = dotenv.env['HOST_NAME'];
var port = dotenv.env['PORT'];

Future<Object> registerUser(
    String firstName, String lastName, String mail, String password) async {
  final url = Uri.parse("$protocol://$hostname:$port/register");
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
    throw Exception("404 not Found");
  }
}
