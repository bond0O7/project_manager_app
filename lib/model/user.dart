class User {
  final String username;
  final String password;
  String? email;
  User({
    required this.password,
    required this.username,
    this.email,
  });
  User.fromJson(json)
      : username = json['username'],
        password = json['password'],
        email = json['email'];
  Map<String, dynamic> toJson() => {
        'password': password,
        'username': username,
        'email': email,
      };
}
