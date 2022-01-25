import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project_manager_app/database/user_dao.dart' as user_dao;
import 'package:project_manager_app/model/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final key = GlobalKey<FormState>();
  final usernameController = TextEditingController(),
      passwordController = TextEditingController(),
      emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Center(
          child: SizedBox(
            width: size.width * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: usernameController,
                          decoration:
                              const InputDecoration(hintText: 'Username'),
                          validator: (username) {
                            if (username!.isEmpty) {
                              return 'required';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: passwordController,
                          decoration:
                              const InputDecoration(hintText: 'Password'),
                          obscureText: true,
                          validator: (password) {
                            if (password!.isEmpty) {
                              return 'required';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(hintText: 'Email'),
                          validator: (email) {
                            if (email!.isEmpty &&
                                EmailValidator.validate(email)) {
                              return 'required: a valid email';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (key.currentState!.validate()) {
                            final username = usernameController.text;
                            final isRegistered = await user_dao.exist(username);
                            final snackBar = SnackBar(
                              content: Text(isRegistered
                                  ? 'This username is already registered'
                                  : 'Registered'),
                              duration: const Duration(seconds: 3),
                            );
                            if (!isRegistered) {
                              user_dao.register(User(
                                username: username,
                                password: passwordController.text,
                                email: emailController.text,
                              ));
                            }
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
