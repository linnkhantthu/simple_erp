import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simple_erp/configs.dart';
import 'package:simple_erp/inventory/Objects/Product.dart';
import 'package:simple_erp/users/Objects/ErrorMessage.dart';
import 'package:simple_erp/users/Objects/User.dart';
import 'package:simple_erp/users/utils.dart';
import 'dart:async';

Future<List<Object>> fetchInventory() async {
  var currentUser = getCurrentUser('current_user');
  var mail = (currentUser as User).mail;
  final url = Uri.parse("${Config.apiURI}/inventory");
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

Future<Object> deleteProduct(productId) async {
  var currentUser = getCurrentUser('current_user');
  var mail = (currentUser as User).mail;
  final url = Uri.parse("${Config.apiURI}/delete_product");
  final headers = {
    "Content-Type": "application/json",
  };
  Map<String, dynamic> body = {
    'mail': mail,
    'product_id': productId,
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
      return ErrorText(message: jsonBody['data']);
    }
  } else {
    throw Exception("404 not Found");
  }
}
