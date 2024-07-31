import '../../src/generated/protos/events.pb.dart';

abstract class EventEvent {
  const EventEvent();
}

class LoadEvent extends EventEvent {}

class HideCalendarEvent extends EventEvent {}

class ShowCalendarEvent extends EventEvent {
  Event? event;
  final int id;
  ShowCalendarEvent({
    required this.id,
    this.event,
  });
}

class OpenWidgetEvent extends EventEvent {}

class CloseWidgetEvent extends EventEvent {}

class CreateEvent extends EventEvent {
  final Event event;

  CreateEvent(this.event);
}

class UpdateEvent extends EventEvent {
  final Event event;

  UpdateEvent(this.event);
}

class DeleteEvent extends EventEvent {
  final int id;

  DeleteEvent(this.id);
}

class GetEvent extends EventEvent {}
