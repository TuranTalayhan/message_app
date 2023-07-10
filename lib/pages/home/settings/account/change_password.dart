import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _newPasswordConfirm = TextEditingController();
  bool _error = false;
  bool _hasChanged = false;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Change password"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextFormField(
                  controller: _currentPassword,
                  decoration: const InputDecoration(
                    labelText: "Current password",
                  )),
              const SizedBox(height: 20),
              TextFormField(
                  controller: _newPassword,
                  decoration: const InputDecoration(
                    labelText: "New password",
                  )),
              const SizedBox(height: 20),
              TextFormField(
                  controller: _newPasswordConfirm,
                  decoration: const InputDecoration(
                    labelText: "Confirm new password",
                  )),
              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.of(context).size.width - 70,
                child: !_isLoading
                    ? TextButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          _changePassword();
                          setState(() {
                            _isLoading = false;
                          });
                          if (context.mounted) {
                            if (!_error && _hasChanged) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Saved changes successfully",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green));
                            }
                            Navigator.pop(context);
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.teal)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Save changes",
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
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.teal)),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _changePassword() {}
}
