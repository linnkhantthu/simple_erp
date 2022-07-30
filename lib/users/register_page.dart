import 'package:flutter/material.dart';
import 'package:simple_erp/users/User.dart';
import 'package:simple_erp/users/utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _mail;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late Future<User> futureUser;

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
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _mail,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Gmail"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _firstName,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "First Name"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _lastName,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Last Name"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _password,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Password"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _confirmPassword,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Confirm Password"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromRGBO(211, 211, 211, 1))),
                      onPressed: () async {
                        setState(() {
                          futureUser = fetchUser(_firstName.text,
                              _lastName.text, _mail.text, _password.text);
                        });
                        print(await futureUser);
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
