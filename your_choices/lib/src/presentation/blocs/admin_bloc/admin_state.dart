// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'admin_cubit.dart';

abstract class AdminState extends Equatable {
  const AdminState();
}

class AdminInitial extends AdminState {
  @override
  List<Object?> get props => [];
}

class AdminLoading extends AdminState {
  @override
  List<Object?> get props => [];
}

class AdminLoaded extends AdminState {
  final List<AdminTransactionEntity> transactions;
  const AdminLoaded({
    required this.transactions,
  });

  @override
  List<Object?> get props => [transactions];

  AdminLoaded copyWith({
    List<AdminTransactionEntity>? transactions,
  }) {
    return AdminLoaded(
      transactions: transactions ?? this.transactions,
    );
  }
}
