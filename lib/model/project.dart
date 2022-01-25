class Project {
  final int id;
  final String name;
  final String user;
  Project({
    required this.user,
    required this.name,
    required this.id,
  });
  Project.fromJson(json)
      : user = json['user'],
        id = json['id'],
        name = json['name'];
  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'name': name,
      };
}
