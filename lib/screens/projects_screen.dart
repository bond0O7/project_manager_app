import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_manager_app/database/project_dao.dart' as projects_dao;
import 'package:project_manager_app/model/project.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  var projects = <Project>[];

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as String;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final id = await projects_dao.nextId();
            final newProject = await _getInputDialog(
              context,
              id: id,
              username: user,
            );
            if (newProject != null) {
              setState(() {
                projects_dao.insert(newProject);
              });
            }
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('Projects'),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * 0.7,
                width: size.width,
                child: StreamBuilder<Object>(
                  stream: projects_dao.query(user).asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      projects = snapshot.data as List<Project>;
                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        children: projects
                            .where(_filterModel)
                            .map((project) => Column(
                                  children: [
                                    Slidable(
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              setState(() {
                                                projects_dao.remove(project.id);
                                              });
                                            },
                                            icon: Icons.remove,
                                            backgroundColor: Colors.red[200]!,
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text(project.name),
                                        onLongPress: () async {
                                          final newProject =
                                              await _getInputDialog(
                                            context,
                                            id: project.id,
                                            projectName: project.name,
                                            username: user,
                                          );
                                          if (newProject != null) {
                                            setState(() {
                                              projects_dao.update(newProject);
                                            });
                                          }
                                        },
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/TasksScreen',
                                            arguments: project,
                                          );
                                        },
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 2,
                                    ),
                                  ],
                                ))
                            .toList(),
                      );
                    }
                    return ListView();
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
                        _filterModel = (Project p) => true;
                      } else {
                        _filterModel = (Project p) => p.name.contains(text);
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

  var _filterModel = (Project p) => true;

  Future<Project?> _getInputDialog(BuildContext context,
      {required int id, required String username, String projectName = ''}) {
    final projectNameController = TextEditingController(text: projectName);
    final key = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(projectName.isEmpty ? 'New project' : 'Update project'),
        content: Form(
          key: key,
          child: TextFormField(
            controller: projectNameController,
            decoration: const InputDecoration(
              hintText: 'Project Name',
            ),
            validator: (name) {
              name = name?.trim();
              return name!.isEmpty ? 'required' : null;
            },
            style: Theme.of(context).textTheme.bodyText2,
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
                  Project(
                    user: username,
                    id: id,
                    name: projectNameController.text,
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
