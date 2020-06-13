import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  @override
  UserState get initialState => AppStarted();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {}
}

// Event
abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RequestAuthenticate extends UserEvent {}

// State
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class AppStarted extends UserState {}

class UserUnauthenticated extends UserState {}

class UserAuthenticated extends UserState {}