class UserModel {
  final int id;
  final String email, first_name, last_name, avatar;

  UserModel({
    required this.id,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.avatar,
  });

  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   return UserModel(
  //     id: json['id'],
  //     email: json['email'],
  //     first_name: json['first_name'],
  //     last_name: json['last_name'],
  //     avatar: json['avatar'],
  //   );
  // }
}
