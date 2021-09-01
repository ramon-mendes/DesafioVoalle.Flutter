class User {
  late String name;
  late String email;
  late String token;

  User(this.name, this.email, this.token);

  User.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.email = json['email'];
    this.token = json['token'];
  }
}
