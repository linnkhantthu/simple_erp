import 'package:flutter/material.dart';
import 'package:simple_erp/dashboard.dart';
import 'package:simple_erp/inventory.dart';
import 'package:simple_erp/users/Objects/ErrorMessage.dart';
import 'package:simple_erp/users/Objects/User.dart';
import 'package:simple_erp/users/login_page.dart';
import 'package:simple_erp/users/register_page.dart';
import 'package:simple_erp/users/utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Object? currentUser;
  bool _isLoading = false;
  Widget _homeWidget = const Dashboard();

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
        resizeToAvoidBottomInset: true,
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
        drawer: Container(
          width: 250,
          decoration: const BoxDecoration(color: Colors.white),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 64.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.all(0.0),
                  child:
                      Text('Categories', style: TextStyle(color: Colors.black)),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text("Dashboard"),
                onTap: () {
                  setState(() {
                    _homeWidget = const Dashboard();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text("Inventory"),
                onTap: () {
                  setState(() {
                    _homeWidget = const Inventory();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(child: FittedBox(child: _homeWidget)),
      );
    }
  }
}
