import 'package:flutter/material.dart';
import 'package:simple_erp/errors/connection_lost.dart';
import 'package:simple_erp/home.dart';
import 'package:simple_erp/users/Objects/ErrorMessage.dart';
import 'package:simple_erp/users/Objects/User.dart';
import 'package:simple_erp/users/utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // TextField controllers
  late final TextEditingController _mail;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  bool _isLoading = false;

  // Error Texts
  var _mailErrorText = null;
  var _firstNameErrorText = null;
  var _lastNameErrorText = null;
  var _passwordErrorText = null;
  var _confirmPasswordErrorText = null;

  // To register user
  late Future<Object> futureUser;

  @override
  void initState() {
    _mail = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    var currentUser = getCurrentUser('current_user');

    if (currentUser is User) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => const Home()),
                (Route<dynamic> route) => false),
          });
    }
    super.initState();
  }

  @override
  void dispose() {
    _mail.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _password.dispose();
    _confirmPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("SimpleERP"),
        ),
        body: _isLoading
            ? connectionLost("Registering new user", Colors.cyan)
            : SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Register",
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
                              controller: _firstName,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: "First Name",
                                  errorText: _firstNameErrorText),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              controller: _lastName,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: "Last Name",
                                  errorText: _lastNameErrorText),
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
                            child: TextField(
                              controller: _confirmPassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.key,
                                    color: Colors.red,
                                  ),
                                  border: const OutlineInputBorder(),
                                  hintText: "Confirm Password",
                                  errorText: _confirmPasswordErrorText),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromRGBO(211, 211, 211, 1))),
                              onPressed: () async {
                                setState(() {
                                  // Check if the fields are empty
                                  _mailErrorText = (_mail.text != "")
                                      ? null
                                      : "This field can't be empty";
                                  _firstNameErrorText = (_firstName.text != "")
                                      ? null
                                      : "This field can't be empty";
                                  _lastNameErrorText = (_lastName.text != "")
                                      ? null
                                      : "This field can't be empty";
                                  _passwordErrorText = (_password.text != "")
                                      ? null
                                      : "This field can't be empty";
                                  _confirmPasswordErrorText =
                                      (_confirmPassword.text != "")
                                          ? null
                                          : "This field can't be empty";

                                  _confirmPasswordErrorText = (_confirmPassword
                                                  .text !=
                                              "" &&
                                          _confirmPassword.text !=
                                              _password.text)
                                      ? "This field must be equal to Password field"
                                      : null;
                                  if (_mailErrorText != null ||
                                      _firstNameErrorText != null ||
                                      _lastNameErrorText != null ||
                                      _passwordErrorText != null ||
                                      _confirmPasswordErrorText != null) {
                                  } else {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    try {
                                      // Display the progress bar
                                      futureUser = registerUser(
                                          _firstName.text,
                                          _lastName.text,
                                          _mail.text,
                                          _password.text);
                                      futureUser.then((value) {
                                        if (value is User) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          Navigator.pushNamed(context, '/login',
                                              arguments: value);
                                        } else {
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
                                "Register",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              child: const Text("Already have an account?"),
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
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

Widget progressBar() {
  return const Center(child: CircularProgressIndicator());
}
