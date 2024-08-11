import 'package:calendarapp/blocs/login/login_bloc.dart';
import 'package:calendarapp/blocs/login/login_event.dart';
import 'package:calendarapp/screens/home_screen.dart';
import 'package:calendarapp/screens/phone_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/login/login_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late final LoginBloc _loginBloc;
  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LoginInitialState) {
            _loginBloc.add(CheckAuth());
          }
          if (state is Authenticated || state is LoginSuccessState) {
            return const MyHomePage();
          }
          if (state is AuthenticationFailed || state is LogoutSuccess) {
            return PhoneAuthScreen();
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Show a loading indicator
            ),
          );
        });
  }
}
