// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class AddOnsState extends Equatable {
  const AddOnsState();
}

class AddOnsInitial extends AddOnsState {
  const AddOnsInitial();

  @override
  List<Object?> get props => [];
}
