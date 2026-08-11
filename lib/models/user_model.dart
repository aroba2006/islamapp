class User {
  final String email;
  final String username;
  final String password;
  final DateTime birthday;
  final String gender;
  final String? profilePicUrl; // ✅ Added this missing field!

  User({
    required this.email,
    required this.username,
    required this.password,
    required this.birthday,
    required this.gender,
    this.profilePicUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      username: json['username'],
      password: json['password'],
      birthday: DateTime.parse(json['birthday']),
      gender: json['gender'],
      profilePicUrl: json['profilePicUrl'], // ✅ Added this!
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'birthday': birthday.toIso8601String(),
      'gender': gender,
      'profilePicUrl': profilePicUrl, // ✅ Added this!
    };
  }

  User copyWith({
    String? email,
    String? username,
    DateTime? birthday,
    String? gender,
    String? profilePicUrl,
  }) {
    return User(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl, // ✅ Added this!
    );
  }
}