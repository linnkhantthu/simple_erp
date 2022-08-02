import 'package:flutter/material.dart';
import 'package:simple_erp/users/Objects/ErrorMessage.dart';
import 'package:simple_erp/users/Objects/User.dart';
import 'package:simple_erp/users/login_page.dart';
import 'package:simple_erp/users/register_page.dart';
import 'package:simple_erp/users/utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  PageController page = PageController();
  late Object? currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    currentUser = getCurrentUser('current_user');
    if (currentUser is ErrorText) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage()),
                (Route<dynamic> route) => false),
          });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return progressBar();
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                removeCurrentUser("current_user");
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => const LoginPage()),
                    (Route<dynamic> route) => false);
              },
              child: const Text("Logout"),
            ),
          ],
          title: Text('Dashboard ${(currentUser as User).firstName}'),
        ),
        drawer: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 64.0,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.grey),
                margin: EdgeInsets.all(0.0),
                child:
                    Text('Categories', style: TextStyle(color: Colors.black)),
              ),
            ),
            ListTile(
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
  }
}
