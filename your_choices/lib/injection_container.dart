import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:your_choices/src/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:your_choices/src/data/data_sources/remote_data_source/remote_data_source_impl.dart';
import 'package:your_choices/src/data/repositories/firebase_repository_impl.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/customer_usecase.dart';
import 'package:your_choices/src/presentation/blocs/auth/auth_cubit.dart';
import 'package:your_choices/src/presentation/blocs/credential/credential_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer/customer_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //cubit
  sl.registerFactory(
    () => AuthCubit(
      customerUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CustomerCubit(
      customerUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CredentialCubit(
      customerUseCase: sl.call(),
    ),
  );
  //use-cases

  sl.registerLazySingleton(
    () => CustomerUseCase(
      repository: sl.call(),
    ),
  );
  //repository
  sl.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(
      remoteDataSource: sl.call(),
    ),
  );

  sl.registerLazySingleton<FirebaseRemoteDataSource>(
    () => FirebaseRemoteDataSourceImpl(
      firebaseFireStore: sl.call(),
      firebaseAuth: sl.call(),
    ),
  );
  //externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
}
