import '../../screens/HomeScreen.dart';

abstract class TitleEvent {
  const TitleEvent();
}

class LoadTitle extends TitleEvent {}

class HideCalendarEvent extends TitleEvent {}

class ShowCalendarEvent extends TitleEvent {
  Events? event;
  final int id;
  ShowCalendarEvent({
    required this.id,
    this.event,
  });
}

class OpenWidgetEvent extends TitleEvent {}

class CloseWidgetEvent extends TitleEvent {}
