import 'package:calendarapp/blocs/login/login_bloc.dart';
import 'package:calendarapp/blocs/login/login_event.dart';
import 'package:calendarapp/blocs/login/login_state.dart';
import 'package:calendarapp/services/token_provider.dart';
import 'package:calendarapp/src/generated/protos/login.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignUpScreen> {
  late LoginBloc _loginBloc;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late TokenProvider _tokenProvider;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _tokenProvider = RepositoryProvider.of<TokenProvider>(context);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _firstnameController.dispose();
    _lastNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      if (state is SignupSuccessState) {
        _tokenProvider.saveToken(state.user.token);
        Navigator.pushReplacementNamed(context, '/home');
      }
      if (state is LoginFailedState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${state.msg} ")));
        _loginBloc.add(LoginInitialEvent());
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: TextFormField(
                          controller: _firstnameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                      ),
                      // const SizedBox(width: 16.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      // Simple regex for email validation
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.value.text) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _loginBloc.add(SignupEvent(User(
                            email: _emailController.value.text,
                            firstname: _firstnameController.value.text,
                            lastname: _lastNameController.value.text,
                            username: _usernameController.value.text,
                            password: _passwordController.value.text)));
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Login'),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
