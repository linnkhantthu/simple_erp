import 'package:flutter/material.dart';
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
    if (_isLoading) {
      return progressBar();
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text("SimpleERP"),
          ),
          body: Center(
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
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "Password",
                            errorText: _passwordErrorText),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _confirmPassword,
                        decoration: InputDecoration(
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
                                    _confirmPassword.text != _password.text)
                                ? "This field must be equal to Password field"
                                : null;
                            if (_mailErrorText != null ||
                                _firstNameErrorText != null ||
                                _lastNameErrorText != null ||
                                _passwordErrorText != null ||
                                _confirmPasswordErrorText != null) {
                            } else {
                              try {
                                _isLoading = true;
                                futureUser = registerUser(_firstName.text,
                                    _lastName.text, _mail.text, _password.text);
                                futureUser.then((value) {
                                  if (value is User) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.pushReplacementNamed(
                                        context, '/login',
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
                              _isLoading = false;
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
                    )
                  ],
                ),
              ),
            ),
          ));
    }
  }
}

Widget progressBar() {
  return const Center(child: CircularProgressIndicator());
}
