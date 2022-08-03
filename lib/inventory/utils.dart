import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:simple_erp/inventory/Objects/Product.dart';
import 'package:simple_erp/users/Objects/ErrorMessage.dart';
import 'package:simple_erp/users/Objects/User.dart';
import 'package:simple_erp/users/utils.dart';

var protocol = dotenv.env['PROTOCOL'];
var hostname = dotenv.env['HOST_NAME'];
var port = dotenv.env['PORT'];

Future<Object> fetchInventory() async {
  var currentUser = getCurrentUser('current_user');
  var mail = (currentUser as User).mail;
  final url = Uri.parse("$protocol://$hostname/inventory");
  final headers = {
    "Content-Type": "application/json",
  };
  Map<String, dynamic> body = {
    'mail': mail,
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
      return Product.fromJson(jsonBody['data']);
    } else {
      return ErrorText.fromJson(jsonBody['data']);
    }
  } else {
    throw Exception("404 not Found");
  }
}
