import 'package:equatable/equatable.dart';

abstract class FCMState extends Equatable {
  const FCMState();

  @override
  List<Object> get props => [];
}

class FCMInitial extends FCMState {}
