import 'package:equatable/equatable.dart';

class AdminEntity extends Equatable {
  final String? uid;
  final String? username;
  final String? type;
  final String? email;

  const AdminEntity({
    this.uid,
    this.username,
    this.type,
    this.email,
  });

  @override
  List<Object?> get props => [
        uid,
        username,
        type,
        email,
      ];

  AdminEntity copyWith({
    String? uid,
    String? username,
    String? type,
    String? email,
  }) {
    return AdminEntity(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      type: type ?? this.type,
      email: email ?? this.email,
    );
  }
}