import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_manager_app/model/project.dart';
import 'package:project_manager_app/model/task.dart';
import 'package:project_manager_app/model/user.dart';
import 'package:project_manager_app/database/tasks_dao.dart' as tasks_dao;
import 'package:project_manager_app/database/user_dao.dart' as users_dao;

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  var tasks = <Task>[];
  var users = <User>[];
  @override
  Widget build(BuildContext context) {
    final currentProject =
        ModalRoute.of(context)!.settings.arguments as Project;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final id = await tasks_dao.nextId();
            final newTask = await _getInputDialog(
              context,
              id: id,
              projectId: currentProject.id,
              username: currentProject.user,
            );
            if (newTask != null) {
              setState(() {
                tasks_dao.insert(newTask);
              });
            }
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(currentProject.name),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.7,
                width: size.width,
                child: StreamBuilder<Object>(
                  stream: tasks_dao.tasks(currentProject.id).asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      tasks = snapshot.data as List<Task>;
                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        children: tasks
                            .where(_filterMode)
                            .map((task) => Column(
                                  children: [
                                    Slidable(
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              setState(() {
                                                tasks_dao.remove(task.id);
                                              });
                                            },
                                            icon: Icons.remove,
                                            backgroundColor: Colors.red[200]!,
                                          )
                                        ],
                                      ),
                                      child: ListTile(
                                        onLongPress: () async {
                                          final newTask = await _getInputDialog(
                                            context,
                                            id: task.id,
                                            projectId: task.currentProjectId,
                                            username: task.username,
                                            taskName: task.name,
                                          );
                                          if (newTask != null) {
                                            newTask.completed = task.completed;
                                            setState(() {
                                              tasks_dao.update(newTask);
                                            });
                                          }
                                        },
                                        title: Text(task.name),
                                        trailing: Text(task.username),
                                        leading: task.completed
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.blue,
                                              )
                                            : const Icon(
                                                Icons.not_started_outlined,
                                                color: Colors.green,
                                              ),
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
                      suffixIcon: Icon(Icons.search_outlined)),
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

  var _filterMode = (Task p) => true;

  Future<Task?> _getInputDialog(
    BuildContext context, {
    required int id,
    required int projectId,
    required String username,
    String taskName = '',
  }) {
    final taskNameController = TextEditingController(text: taskName);
    final key = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(taskName.isEmpty ? 'New task' : 'Update task'),
        content: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: taskNameController,
                  decoration: const InputDecoration(
                    hintText: 'Task Name',
                  ),
                  validator: (name) {
                    name = name?.trim();
                    return name!.isEmpty ? 'required' : null;
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<Object>(
                  stream: users_dao.allUsers().asStream(),
                  builder: (context, snapshot) {
                    return DropdownButtonFormField<String>(
                      elevation: 0,
                      dropdownColor: Colors.grey[900]!.withOpacity(0.91),
                      items: (snapshot.hasData
                              ? (snapshot.data as List<User>)
                              : [])
                          .map(
                            (user) => DropdownMenuItem<String>(
                              child: Text(
                                user.username,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              value: user.username,
                            ),
                          )
                          .toList(),
                      onChanged: (user) {
                        username = user!;
                      },
                      value: username,
                    );
                  },
                ),
              )
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          MaterialButton(
            onPressed: () {
              if (key.currentState!.validate()) {
                Navigator.pop(
                  context,
                  Task(
                    username: username,
                    currentProjectId: projectId,
                    id: id,
                    name: taskNameController.text,
                  ),
                );
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
