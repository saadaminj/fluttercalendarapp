import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendarapp/app.dart';
import 'package:calendarapp/blocs/events/events_bloc.dart';
import 'package:calendarapp/blocs/events/events_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendarapp/services/events_service.dart';
import 'package:grpc/grpc.dart';

Widget appProvider() {
  return MultiRepositoryProvider(
      providers: repositoryProviders(),
      child: MultiBlocProvider(
          providers: [
            BlocProvider<EventBloc>(
              create: (context) {
                final titleService =
                    RepositoryProvider.of<EventClient>(context);
                return EventBloc(titleService);
              },
            ),
          ],
          child: BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              return const App();
            },
          )));
}

List<RepositoryProvider> repositoryProviders() {
  final channel = ClientChannel(
    'localhost', // The server address
    port: 50051, // The server port
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );
  return [
    RepositoryProvider<EventClient>(
      create: (context) {
        return EventClient(channel);
      },
    ),
  ];
}
