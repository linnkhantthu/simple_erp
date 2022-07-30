import 'package:http/http.dart' as http;

Future<http.Response> login() {
  return http.get(Uri.parse(''));
}
