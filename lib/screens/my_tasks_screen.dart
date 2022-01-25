import 'package:flutter/material.dart';
import 'package:project_manager_app/model/project.dart';
import 'package:project_manager_app/model/task.dart';
import 'package:project_manager_app/database/tasks_dao.dart' as tasks_dao;
import 'package:project_manager_app/database/project_dao.dart' as projects_dao;

class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({Key? key}) : super(key: key);

  @override
  _MyTasksScreenState createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  var tasks = <Task>[];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final username = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: size.height * 0.7,
                child: StreamBuilder<Object>(
                  stream: tasks_dao.myTasks(username).asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      tasks = snapshot.data as List<Task>;
                      return ListView(
                        children: tasks
                            .where(_filterMode)
                            .map((task) => Column(
                                  children: [
                                    ListTile(
                                      tileColor: task.opened
                                          ? Theme.of(context)
                                              .listTileTheme
                                              .tileColor
                                          : Colors.orange[200]!
                                              .withOpacity(0.05),
                                      leading: IconButton(
                                        onPressed: () {
                                          task.completed = !task.completed;
                                          setState(() {
                                            tasks_dao.update(task);
                                          });
                                        },
                                        icon: task.completed
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.blue,
                                              )
                                            : const Icon(
                                                Icons.not_started_outlined,
                                                color: Colors.green,
                                              ),
                                      ),
                                      title: Text(task.name),
                                      subtitle: FutureBuilder(
                                        future: projects_dao.queryProjectById(
                                            task.currentProjectId),
                                        builder: (context, snapshot) => Text(
                                            snapshot.hasData
                                                ? (snapshot.data as Project)
                                                    .name
                                                : '-'),
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 2,
                                    ),
                                  ],
                                ))
                            .toList(),
                      );
                    } else {
                      return ListView();
                    }
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              SizedBox(
                width: size.width * 0.8,
                height: size.height * 0.1,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    suffixIcon: Icon(
                      Icons.search_outlined,
                    ),
                  ),
                  onChanged: (text) {
                    text = text.trim();
                    setState(() {
                      if (text.isEmpty) {
                        _filterMode = (_) => true;
                      } else {
                        _filterMode = (t) => t.name.contains(text);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var _filterMode = (Task t) => true;
}
