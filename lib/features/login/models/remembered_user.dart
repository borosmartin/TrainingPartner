import 'package:equatable/equatable.dart';

class RememberedUser extends Equatable {
  final String email;
  final String password;

  const RememberedUser({
    required this.email,
    required this.password,
  });

  RememberedUser copyWith({
    String? email,
    String? password,
  }) {
    return RememberedUser(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  factory RememberedUser.fromJson(Map<String, dynamic> json) => RememberedUser(
        email: json['email'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  List<Object> get props => [email, password];
}
