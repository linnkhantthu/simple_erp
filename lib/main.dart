import 'package:flutter/material.dart';
import 'package:simple_erp/dashboard.dart';
import 'package:simple_erp/users/Objects/User.dart';
import 'package:simple_erp/users/login_page.dart';
import 'package:simple_erp/users/register_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simple_erp/users/utils.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = getCurrentUser("current_user");
    var initialRoute = "/";
    if (currentUser is User) {
      initialRoute = "/dashboard";
    }
    return MaterialApp(
      title: "SimpleERP",
      theme: ThemeData(primarySwatch: Colors.grey),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const Dashboard(),
      },
    );
  }
}
