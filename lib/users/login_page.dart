import 'package:flutter/material.dart';
import 'package:simple_erp/errors/connection_lost.dart';
import 'package:simple_erp/home.dart';
import 'package:simple_erp/users/Objects/ErrorMessage.dart';
import 'package:simple_erp/users/Objects/User.dart';
import 'package:simple_erp/users/register_page.dart';
import 'package:simple_erp/users/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _mail;
  late final TextEditingController _password;
  var _flashMessage = null;
  var _mailErrorText = null;
  var _passwordErrorText = null;
  late Future<Object> futureUser;
  bool _isLoading = false; // For loading screen

  @override
  void initState() {
    _mail = TextEditingController();
    _password = TextEditingController();
    // Checking if the user is authenticated
    print("Login Page: Checking if the user is authenticated ...");
    var currentUser = getCurrentUser('current_user');
    if (currentUser is User) {
      print(
          "Login Page: The user is authenticated as " + currentUser.firstName);
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => const Home()),
            (Route<dynamic> route) => false),
      );
    } else {
      print("Login Page: The user is not authenticated, need to login.");
    }
    super.initState();
  }

  @override
  void dispose() {
    _mail.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the there are any Args/ if args is not null show it to the user
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      print("Login Page: Got Args" + (args as User).mail);
      final user = args as User;
      setState(() {
        _flashMessage = user.mail;
        _mail.text = user.mail;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("SimpleERP"),
        ),
        body: _isLoading
            ? connectionLost("Loggin in to your account", Colors.cyan)
            : SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              (_flashMessage != null)
                                  ? "Registered as $_flashMessage"
                                  : "",
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              controller: _mail,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.mail,
                                    color: Colors.blue,
                                  ),
                                  border: const OutlineInputBorder(),
                                  hintText: "Gmail",
                                  errorText: _mailErrorText),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              controller: _password,
                              obscureText: true,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.key,
                                    color: Colors.red,
                                  ),
                                  border: const OutlineInputBorder(),
                                  hintText: "Password",
                                  errorText: _passwordErrorText),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromRGBO(211, 211, 211, 1))),
                              onPressed: () {
                                setState(() {
                                  // Check if the fields are empty
                                  _mailErrorText = (_mail.text != "")
                                      ? null
                                      : "This field can't be empty";

                                  _passwordErrorText = (_password.text != "")
                                      ? null
                                      : "This field can't be empty";

                                  if (_mailErrorText != null ||
                                      _passwordErrorText != null) {
                                  } else {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    try {
                                      // Display the progress bar

                                      futureUser =
                                          loginUser(_mail.text, _password.text);
                                      futureUser.then((value) {
                                        if (value is User) {
                                          print(
                                              "Logged in successfully as ${value}");
                                          setCurrentUser(
                                              'current_user', value.toJson());
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder:
                                                          (BuildContext
                                                                  context) =>
                                                              const Home()),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        } else {
                                          print(
                                              "Logged in Failed${(value as ErrorText).message}");
                                          setState(() {
                                            _isLoading = false;
                                            _mailErrorText =
                                                (value as ErrorText).message;
                                          });
                                        }
                                      });
                                    } catch (e) {
                                      throw Exception(e);
                                    }
                                  }
                                });
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
