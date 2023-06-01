// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:your_choices/src/domain/entities/admin/admin_entity.dart';

class AdminModel extends AdminEntity {
  const AdminModel({
    super.uid,
    super.username,
    super.email,
    super.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'type': type,
      'email': email,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminModel.fromJson(String source) => AdminModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
