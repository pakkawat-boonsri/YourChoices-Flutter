import 'package:your_choices/services/auth/auth_user.dart';
import 'package:your_choices/services/auth/firebase_auth_provider.dart';

class AuthService implements FirebaseAuthProvider {
  final FirebaseAuthProvider provider;
  AuthService(this.provider);

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  handleUserLogin() => provider.handleUserLogin();

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  signInWithGoogle() => provider.signInWithGoogle();
}
