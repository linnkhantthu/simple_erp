import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:simple_erp/users/utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Object? currentUser;

  @override
  void initState() {
    currentUser = getCurrentUser('current_user');
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          if (currentUser == null)
            {Navigator.pushReplacementNamed(context, '/login')}
        });
    var jsonData = currentUser.toString();
    print(" DASHBOARD : ${jsonDecode(jsonEncode(jsonData))[0]}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Dashboard');
  }
}
