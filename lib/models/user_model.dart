class UserModel {
  late final int id;
  late final String email, first_name, last_name, avatar;

  UserModel({
    required this.id,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.avatar,
  });

  // factory GetUserModel.fromJson(Map<String, dynamic> json) {
  //   return GetUserModel(
  //     id: json['id'],
  //     email: json['email'],
  //     first_name: json['first_name'],
  //     last_name: json['last_name'],
  //     avatar: json['avatar'],
  //   );
  // }
}
