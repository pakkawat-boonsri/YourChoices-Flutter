import '../../repositories/firebase_repository.dart';

class SignInRoleUseCase {
  final FirebaseRepository repository;

  SignInRoleUseCase({required this.repository});

  Future<String> call(String uid) {
    return repository.signinRole(uid);
  }
}