class Task {
  final int id;
  final int currentProjectId;
  final String name;
  final String username;
  bool completed = false;
  bool opened = false;

  Task({
    required this.username,
    required this.id,
    required this.currentProjectId,
    required this.name,
  });
  Task.fromJson(json)
      : id = json['id'],
        currentProjectId = json['projectId'],
        name = json['name'],
        username = json['user'],
        completed = json['completed'] as int == 0 ? false : true,
        opened = json['opened'] as int == 0 ? false : true;

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': currentProjectId,
        'name': name,
        'user': username,
        'completed': completed ? 1 : 0,
        'opened': opened ? 1 : 0,
      };
}
