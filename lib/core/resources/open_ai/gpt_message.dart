import 'package:equatable/equatable.dart';

class GptMessage extends Equatable {
  final String role;
  final String content;

  const GptMessage({required this.role, required this.content});

  factory GptMessage.fromJson(Map<dynamic, dynamic> json) {
    return GptMessage(
      role: json['role'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }

  @override
  List<Object> get props => [role, content];
}
