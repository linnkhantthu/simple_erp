import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:simple_erp/users/Objects/ErrorMessage.dart';
import 'package:simple_erp/users/Objects/User.dart';
import 'package:simple_erp/users/login_page.dart';
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
          if (currentUser is ErrorText)
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => const LoginPage()),
                  (Route<dynamic> route) => false)
            }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Text("Logout"),
          ),
        ],
        title: Text('Dashboard ${(currentUser as User).firstName}'),
      ),
    );
  }
}
