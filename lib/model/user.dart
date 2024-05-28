class UserModel {
  String? email;
  String? password;
  String? name;
  String? username;
  String? profilePictureUrl;

  UserModel(
      {this.email,
      this.password,
      this.name,
      this.username,
      this.profilePictureUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json["email"],
      password: json["password"],
      name: json["name"],
      username: json["username"],
      profilePictureUrl: json["profilePictureUrl"],
    );
  }
}
