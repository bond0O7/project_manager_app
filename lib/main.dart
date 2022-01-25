import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_manager_app/database/db.dart';
import 'package:project_manager_app/model/user.dart';
import 'package:project_manager_app/screens/login_screen.dart';
import 'package:project_manager_app/screens/my_tasks_screen.dart';
import 'package:project_manager_app/screens/projects_screen.dart';
import 'package:project_manager_app/screens/register_screen.dart';
import 'package:project_manager_app/screens/tasks_screen.dart';
import 'package:project_manager_app/database/user_dao.dart' as users_dao;
import 'package:project_manager_app/database/tasks_dao.dart' as tasks_dao;

import 'model/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    Database.init();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.orange),
          appBarTheme: AppBarTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.orange[900]!,
            titleTextStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
          ),
          scaffoldBackgroundColor: Colors.grey[900],
          popupMenuTheme: PopupMenuThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.black,
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
            },
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.orange[900]!),
              elevation: MaterialStateProperty.all<double>(10),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.accent,
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
              color: Colors.grey[200]!.withOpacity(0.5),
            ),
            isDense: true,
            suffixIconColor: Colors.orange[100],
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.orange[900]!,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.orange[900]!,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
          dialogTheme: DialogTheme(
            titleTextStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
            backgroundColor: Colors.grey[900],
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          listTileTheme: ListTileThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: Colors.orange[900]!.withOpacity(0.2),
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            textColor: Colors.grey[400],
          ),
          textTheme: TextTheme(
            bodyText2: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            bodyText1: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.orange[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/MainScreen': (context) => const MainScreen(),
          '/TasksScreen': (context) => const TasksScreen(),
          '/RegisterScreen': (context) => const RegisterScreen(),
        },
      );
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final username = ModalRoute.of(context)!.settings.arguments as String;
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        drawer: SafeArea(
          child: Drawer(
            elevation: 10,
            backgroundColor: Colors.grey[800]!,
            shape: const RoundedRectangleBorder(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.2,
                  ),
                  SizedBox(
                    height: size.height * 0.25,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange[900]!,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.userAlt,
                              ),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              const Text('Profile'),
                            ],
                          ),
                          FutureBuilder(
                            future: users_dao.userByUsername(username),
                            builder: (context, snapshot) {
                              final user =
                                  snapshot.hasData && snapshot.data is User
                                      ? snapshot.data as User
                                      : null;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Username:  ${user?.username ?? '-'}'),
                                  Text('Email        :  ${user?.email ?? '-'}'),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.3,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    title: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: TabBar(
          onTap: (idx) {
            if (idx == 1) {
              Future.delayed(const Duration(seconds: 3), () {
                setState(() {
                  tasks_dao.markAllTaskAsOpened(username);
                });
              });
            }
          },
          tabs: [
            const Icon(Icons.line_weight, color: Colors.black),
            StreamBuilder(
                stream: Stream<Future<bool>>.periodic(
                    const Duration(milliseconds: 500),
                    (_) async => _hasUnOpenedTasks(username)),
                builder: (context, snapshot) {
                  return FutureBuilder(
                      future: snapshot.data is Future<bool>
                          ? snapshot.data as Future<bool>
                          : Future<bool>.delayed(Duration.zero, () => false),
                      builder: (context, snapshot) {
                        return Icon(
                          FontAwesomeIcons.tasks,
                          color: snapshot.hasData &&
                                  snapshot.data is bool &&
                                  snapshot.data as bool
                              ? Colors.orange[900]
                              : Colors.black,
                        );
                      });
                }),
          ],
        ),
        body: const TabBarView(
          children: [ProjectsScreen(), MyTasksScreen()],
        ),
      ),
    );
  }

  Future<bool> _hasUnOpenedTasks(String user) async {
    return (await tasks_dao.myTasks(user)).any((task) => !task.opened);
  }
}
