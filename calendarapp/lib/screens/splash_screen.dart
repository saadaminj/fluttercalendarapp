import 'package:calendarapp/blocs/login/login_bloc.dart';
import 'package:calendarapp/blocs/login/login_event.dart';
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
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      print("state is in spashscreen ${state}");
      if (state is LoginInitialState) {
        _loginBloc.add(CheckAuth());
      }
      if (state is Authenticated || state is LoginSuccessState) {
        Navigator.pushNamed(context, '/home');
      }
      if (state is AuthenticationFailed || state is LogoutSuccess) {
        Navigator.pushNamed(context, '/login');
      }
    }, builder: (context, state) {
      if (state is LoginInitialState) {
        _loginBloc.add(CheckAuth());
      }
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show a loading indicator
        ),
      );
    });
  }
}
