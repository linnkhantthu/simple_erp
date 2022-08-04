import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String routeName = "Dashboard";
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
          title: Text('$routeName (${(currentUser as User).firstName})'),
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
                leading: const Icon(
                  Icons.dashboard,
                  color: Colors.blue,
                ),
                title: const Text("Dashboard"),
                onTap: () {
                  setState(() {
                    routeName = "Dashboard";
                    _homeWidget = const Dashboard();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.inventory,
                  color: Colors.orange,
                ),
                title: const Text("Inventory"),
                onTap: () {
                  setState(() {
                    routeName = "Inventory";
                    _homeWidget = const Inventory();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text("Logout & Exit"),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Logout and Exit?"),
                      content: const Text("Are you sure?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            )),
                        TextButton(
                            onPressed: () {
                              removeCurrentUser("current_user")
                                  .whenComplete(() {
                                Navigator.pop(context, 'Sure');
                                SystemNavigator.pop();
                              });
                            },
                            child: const Text("Sure"))
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: FittedBox(child: _homeWidget),
          ),
        ),
      );
    }
  }
}
