import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class SignInRoleUseCase {
  final FirebaseRepository repository;

  SignInRoleUseCase({required this.repository});

  Future<String> call(String uid) {
    return repository.signInRole(uid);
  }
}
