import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simple_erp/users/Objects/User.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final currentUser =
      GetStorage(dotenv.env['SECRET_KEY'].toString()).read('current_user');

  @override
  Widget build(BuildContext context) {
    return Text("Dashboard as $currentUser");
  }
}
