import 'package:equatable/equatable.dart';

import '../../src/generated/protos/login.pb.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitialState extends LoginState {
  const LoginInitialState() : super();

  @override
  List<Object?> get props => [null];
}

class Authenticated extends LoginState {
  const Authenticated() : super();

  @override
  List<Object?> get props => [null];
}

class AuthenticationFailed extends LoginState {
  const AuthenticationFailed() : super();

  @override
  List<Object?> get props => [null];
}

class LogoutSuccess extends LoginState {
  const LogoutSuccess() : super();

  @override
  List<Object?> get props => [null];
}

class LoginFailedState extends LoginState {
  final String msg;
  const LoginFailedState(this.msg) : super();

  @override
  List<Object?> get props => [null];
}

class LoginSuccessState extends LoginState {
  final User user;
  const LoginSuccessState(this.user) : super();

  @override
  List<Object?> get props => [null];
}

class SignupSuccessState extends LoginState {
  final User user;
  const SignupSuccessState(this.user) : super();

  @override
  List<Object?> get props => [null];
}
