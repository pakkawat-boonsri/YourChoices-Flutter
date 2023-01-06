import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:your_choices/src/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:your_choices/src/data/data_sources/remote_data_source/remote_data_source_impl.dart';
import 'package:your_choices/src/data/repositories/firebase_repository_impl.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/create_customer_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_current_uid_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_single_customer.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/is_sign_in_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/sign_in_customer_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/sign_out_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/sign_up_customer_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/update_customer_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/upload_image_to_storage_usecase.dart';
import 'package:your_choices/src/presentation/blocs/auth/auth_cubit.dart';
import 'package:your_choices/src/presentation/blocs/credential/credential_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer/customer_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //cubit
  sl.registerFactory(
    () => AuthCubit(
      getCurrentUidUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      signOutUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CustomerCubit(
      getSingleCustomerUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CredentialCubit(
      signInCustomerUseCase: sl.call(),
      signUpCustomerUseCase: sl.call(),
    ),
  );
  //use-cases

  sl.registerLazySingleton(
    () => CreateCustomerUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => GetSingleCustomerUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => GetCurrentUidUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => IsSignInUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => SignOutUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => UpdateCustomerUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => UploadImageToStorageUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => SignInCustomerUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => SignUpCustomerUseCase(repository: sl.call()),
  );
  //repository
  sl.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(remoteDataSource: sl.call()),
  );

  sl.registerLazySingleton<FirebaseRemoteDataSource>(
    () => FirebaseRemoteDataSourceImpl(
      firebaseFireStore: sl.call(),
      firebaseAuth: sl.call(),
      firebaseStorage: sl.call(),
    ),
  );
  //externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
