import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class SignInUserUseCase {
  final FirebaseRepository repository;

  SignInUserUseCase({required this.repository});

  Future<void> call(String email, String password) {
    return repository.signInUser(email, password);
  }
}
