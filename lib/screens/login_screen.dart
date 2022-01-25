import 'package:flutter/material.dart';
import 'package:project_manager_app/database/user_dao.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final key = GlobalKey<FormState>();

  final usernameController = TextEditingController(),
      passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Project Manager App'),
        ),
        body: Center(
          child: SizedBox(
            width: size.width * 0.7,
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                      ),
                      style: Theme.of(context).textTheme.bodyText2,
                      validator: (username) =>
                          username!.trim().isEmpty ? 'required' : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      style: Theme.of(context).textTheme.bodyText2,
                      validator: (password) =>
                          password!.trim().isEmpty ? 'required' : null,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/RegisterScreen');
                          },
                          child: const Text('Register'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () async {
                            if (key.currentState!.validate()) {
                              if (await checkUser(
                                  username: usernameController.text,
                                  password: passwordController.text)) {
                                Navigator.pushNamed(
                                  context,
                                  '/MainScreen',
                                  arguments: usernameController.text,
                                );
                              } else {
                                const snackBar = SnackBar(
                                  content: Text('Wrong username or password'),
                                  duration: Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
