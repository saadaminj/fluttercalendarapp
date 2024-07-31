import 'package:equatable/equatable.dart';

import '../../src/generated/protos/events.pb.dart';

abstract class EventState extends Equatable {
  const EventState();
}

class OpenWidgetState extends EventState {
  const OpenWidgetState() : super();

  @override
  List<Object?> get props => [null];
}

class CloseWidgetState extends EventState {
  const CloseWidgetState() : super();

  @override
  List<Object?> get props => [null];
}

class EventInitial extends EventState {
  const EventInitial() : super();

  @override
  List<Object?> get props => [];
}

class EventLoading extends EventState {
  const EventLoading() : super();

  @override
  List<Object?> get props => [null];
}

class EventLoaded extends EventState {
  final String title;
  const EventLoaded(this.title) : super();

  @override
  List<Object?> get props => [title];
}

class ShowCalendarState extends EventState {
  const ShowCalendarState({required this.id, this.event}) : super();
  final int id;
  final Event? event;
  @override
  List<Object?> get props => [];
}

class HideCalendarState extends EventState {
  const HideCalendarState() : super();

  @override
  List<Object?> get props => [];
}

class GetEventsState extends EventState {
  final List<Event> eventslist;
  const GetEventsState(this.eventslist) : super();

  @override
  List<Object?> get props => [];
}

class CreateEventState extends EventState {
  const CreateEventState() : super();

  @override
  List<Object?> get props => [];
}

class UpdateEventState extends EventState {
  const UpdateEventState() : super();

  @override
  List<Object?> get props => [];
}

class DeleteEventState extends EventState {
  const DeleteEventState() : super();

  @override
  List<Object?> get props => [];
}

class RequestFailedState extends EventState {
  final String msg;
  const RequestFailedState(this.msg) : super();

  @override
  List<Object?> get props => [];
}
