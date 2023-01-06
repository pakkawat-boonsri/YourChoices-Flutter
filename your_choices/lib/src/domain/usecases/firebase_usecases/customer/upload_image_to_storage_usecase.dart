import 'dart:io';

import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class UploadImageToStorageUseCase {
  final FirebaseRepository repository;

  UploadImageToStorageUseCase({required this.repository});

  Future<String> call(
    File file,
    String childName,
  ) async {
    return repository.uploadImageToStorage(
      file,
      childName,
    );
  }
}
