import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final bool _isDarkMode =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  final _name = TextEditingController();

  final _email = TextEditingController();

  final _password = TextEditingController();

  final _passwordConfirm = TextEditingController();

  late bool _error;

  bool _isLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _passwordConfirm.dispose();
    super.dispose();
  }

  Future<void> _signUpUser() async {
    if (_password.text != _passwordConfirm.text) {
      _error = true;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Passwords do not match",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (_name.text.isEmpty) {
      _error = true;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Please enter a name",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (_email.text.isEmpty) {
      _error = true;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Please enter a valid email address",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (_password.text.isEmpty) {
      _error = true;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Please enter a password",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      _error = false;
      await context
          .read<DatabaseService>()
          .signUpWithEmailAndPassword(_name.text, _email.text, _password.text);
    } catch (e) {
      _error = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Text(
                  "Sign up with Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Text(
                "Get chatting with friends and family today by signing up for our chat app!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            labelText: "Your name",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.teal))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            labelText: "Your email",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.teal))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextFormField(
                        controller: _password,
                        obscureText: true,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            labelText: "Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.teal))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextFormField(
                        controller: _passwordConfirm,
                        obscureText: true,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            labelText: "Confirm Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.teal))),
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 70,
                    child: !_isLoading
                        ? TextButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await _signUpUser();
                              setState(() {
                                _isLoading = false;
                              });
                              if (!_error && context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Signed up successfully",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green));
                                Navigator.pop(context);
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.teal)),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Create an account",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        : TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.teal)),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              )),
            ],
          ),
        ));
  }
}
