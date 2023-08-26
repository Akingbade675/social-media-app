class User {
  final int? id;
  final String? email;

  final String? name;
  final String? avatarUrl;

  User({this.id, this.email, this.name, this.avatarUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        avatarUrl: json['avatar_url']);
  }
}
