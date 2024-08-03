import '../../src/generated/protos/login.pb.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class LoginInitialEvent extends LoginEvent {}

class LogoutEvent extends LoginEvent {}

class CheckAuth extends LoginEvent {}

class SignupEvent extends LoginEvent {
  final User user;
  const SignupEvent(this.user);
}

class Login extends LoginEvent {
  final User user;
  const Login(this.user);
}
