import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bool _isDarkMode =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  final _email = TextEditingController();

  final _password = TextEditingController();

  late bool _error;

  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signInUser() async {
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
          .signInWithEmailAndPassword(_email.text, _password.text);
    } catch (e) {
      _error = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
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
              const SizedBox(height: 60),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Text(
                  "Log in to MessageApp",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Text(
                "Welcome back! Sign in using your email to continue",
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
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                  const SizedBox(height: 60),
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 70,
                      child: !_isLoading
                          ? TextButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await _signInUser();
                                setState(() {
                                  _isLoading = false;
                                });
                                if (!_error && context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                            "Logged in successfully",
                                            style:
                                                TextStyle(color: Colors.white),
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
                                child: Text("Log in",
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
                            )),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, "/reset_password"),
                    child: const Text("Forgot password?",
                        style: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.bold)),
                  )
                ],
              )),
            ],
          ),
        ));
  }
}
