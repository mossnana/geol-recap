import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:geol_recap/models/collection.dart';

// BLoC
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  AuthenticationBloc({
    @required UserRepository userRepository
  }) : assert(userRepository != null), _userRepository = userRepository;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if(isSignedIn) {
        final user = await _userRepository.getUser();
        yield Authenticated(userRepository: user);
      } else {
        yield Unauthenticated();
      }
    } catch(error) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final user = await _userRepository.getUser();
    yield Authenticated(userRepository: user);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}

// Event
abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() {
    return 'AppStarted';
  }
}

class LoggedIn extends AuthenticationEvent {
  @override
  String toString() {
    return 'LoggedIn';
  }
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() {
    return 'LoggedOut';
  }
}

// State
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() {
    return 'Uninitialized';
  }
}

class Authenticated extends AuthenticationState {
  final User userRepository;

  const Authenticated({this.userRepository});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Authenticated with account email';
}

class Unauthenticated extends AuthenticationState {

  @override
  String toString() {
    return 'Unauthenticated';
  }
}