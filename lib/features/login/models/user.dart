import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String id;
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;

  const UserData({
    required this.id,
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
  });

  UserData copyWith({
    String? id,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
  }) {
    return UserData(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        lastName: json['lastName'],
        firstName: json['firstName'],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'lastName': lastName,
      'firstName': firstName,
    };
  }

  @override
  List<Object?> get props => [id, email, password, lastName, firstName];
}
