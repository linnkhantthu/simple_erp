import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_erp/dashboard.dart';
import 'package:simple_erp/inventory.dart';
import 'package:simple_erp/inventory/purchase.dart';
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
  bool _inventorySubtitle = false;

  @override
  void initState() {
    // Check if the user is authenticated
    currentUser = getCurrentUser('current_user');
    if (currentUser is ErrorText) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const LoginPage()),
            (Route<dynamic> route) => false),
      );
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
              ExpansionTile(
                  leading: const Icon(
                    Icons.inventory,
                    color: Colors.orange,
                  ),
                  title: InkWell(
                    child: const Text("Inventory"),
                    onTap: () {
                      setState(() {
                        routeName = "Inventory";
                        _homeWidget = const Inventory();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                      child: ListTile(
                        leading: const Icon(
                          Icons.shopping_bag,
                          color: Colors.green,
                        ),
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Purchase"),
                        onTap: () {
                          setState(() {
                            routeName = "Purchase";
                            _homeWidget = const Purchase();
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ]),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text("Logout"),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Logout"),
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
                                // SystemChannels.platform
                                //     .invokeMethod('SystemNavigator.pop');
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const LoginPage()),
                                    (Route<dynamic> route) => false);
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
        body: _homeWidget,
      );
    }
  }
}
