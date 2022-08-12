import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:simple_erp/inventory/Objects/Product.dart';
import 'package:simple_erp/users/Objects/ErrorMessage.dart';
import 'package:simple_erp/users/Objects/User.dart';
import 'package:simple_erp/users/utils.dart';
import 'dart:async';

var protocol = dotenv.env['PROTOCOL'];
var hostname = dotenv.env['HOST_NAME'];
var port = dotenv.env['PORT'];

Future<List<Object>> fetchInventory() async {
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
      List<Product> products = [];
      for (var element in jsonBody['data']) {
        products.add(Product.fromJson(element));
      }
      return products;
    } else {
      return [ErrorText.fromJson(jsonBody['data'])];
    }
  } else {
    throw Exception("404 not Found");
  }
}

// STEP1:  Stream setup
class StreamSocket {
  final _socketResponse = StreamController<List<Object>>();

  // void Function(String) get addResponse => _socketResponse.sink.add;
  void addResponse(List<Object> event) {
    if (!_socketResponse.isClosed) {
      _socketResponse.sink.add(event);
    }
  }

  // Stream get getResponse => _socketResponse.stream;
  Stream<List<Object>>? getResponse() {
    return _socketResponse.stream;
  }

  void dispose() {
    _socketResponse.close();
  }
}

void resetAddProductForm(
    TextEditingController _id,
    TextEditingController _productName,
    TextEditingController _contains,
    TextEditingController _price) {
  _id.clear();
  _productName.clear();
  _contains.clear();
  _price.clear();
}
