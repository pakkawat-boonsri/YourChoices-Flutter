// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class GetAccountBalanceUseCase {
  final FirebaseRepository repository;
  GetAccountBalanceUseCase({
    required this.repository,
  });

  Future<num> call(String uid)  async {
    return  await repository.getAccountBalance(uid);
  }
}
