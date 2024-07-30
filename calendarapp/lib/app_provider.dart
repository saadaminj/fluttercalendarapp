import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendarapp/app.dart';
import 'package:calendarapp/blocs/title/title_bloc.dart';
import 'package:calendarapp/blocs/title/title_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendarapp/services/title_service.dart';

Widget appProvider() {
  return MultiRepositoryProvider(
      providers: repositoryProviders(),
      child: MultiBlocProvider(
          providers: [
            BlocProvider<TitleBloc>(
              create: (context) {
                final titleService =
                    RepositoryProvider.of<TitleService>(context);
                return TitleBloc(titleService);
              },
            ),
          ],
          child: BlocBuilder<TitleBloc, TitleState>(
            builder: (context, state) {
              return const App();
            },
          )));
}

List<RepositoryProvider> repositoryProviders() {
  return [
    RepositoryProvider<TitleService>(
      create: (context) {
        return DummyTitleService();
      },
    ),
  ];
}
