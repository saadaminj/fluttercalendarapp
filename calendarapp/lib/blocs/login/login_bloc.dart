import 'package:bloc/bloc.dart';
import 'package:calendarapp/services/login_service.dart';
import 'package:calendarapp/services/token_provider.dart';
import 'package:calendarapp/src/generated/protos/login.pb.dart';
import 'package:grpc/grpc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final TokenProvider tokenProvider;
  final LoginClient loginService;
  LoginBloc(this.loginService, this.tokenProvider)
      : super(const LoginInitialState()) {
    on<Login>((event, emit) async {
      var response = await loginService.login(event.user);
      if (response is LoginResponse) {
        await tokenProvider
            .saveToken(response.user.token)
            .then((value) async => await tokenProvider.saveUser(response.user))
            .then((value) => emit(LoginSuccessState(response.user)));
      } else if (response is ErrorInfo) {
        emit(LoginFailedState(response.reason));
      }
    });
    on<LogoutEvent>((event, emit) {
      tokenProvider.clearToken();
      tokenProvider.clearUser();
      emit(const LogoutSuccess());
    });
    on<CheckAuth>((event, emit) async {
      String token = await tokenProvider.loadToken();
      if (token.isNotEmpty) {
        await tokenProvider.loadUser();
        emit(const Authenticated());
      } else {
        emit(const AuthenticationFailed());
      }
    });
    on<LoginInitialEvent>((event, emit) => const LoginInitialState());
    on<SignupEvent>((event, emit) async {
      var response = await loginService.signup(event.user);
      if (response is LoginResponse) {
        await tokenProvider
            .saveToken(response.user.token)
            .then((value) async => await tokenProvider.saveUser(response.user))
            .then((value) => emit(SignupSuccessState(response.user)));
        ;
      } else if (response is ErrorInfo) {
        emit(LoginFailedState(response.reason));
      }
    });
  }
}
