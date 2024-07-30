import 'package:equatable/equatable.dart';

import '../../screens/HomeScreen.dart';

abstract class TitleState extends Equatable {
  const TitleState();
}

class OpenWidgetState extends TitleState {
  const OpenWidgetState() : super();

  @override
  List<Object?> get props => [null];
}

class CloseWidgetState extends TitleState {
  const CloseWidgetState() : super();

  @override
  List<Object?> get props => [null];
}

class TitleInitial extends TitleState {
  const TitleInitial() : super();

  @override
  List<Object?> get props => [];
}

class TitleLoading extends TitleState {
  const TitleLoading() : super();

  @override
  List<Object?> get props => [null];
}

class TitleLoaded extends TitleState {
  final String title;
  const TitleLoaded(this.title) : super();

  @override
  List<Object?> get props => [title];
}

class ShowCalendarState extends TitleState {
  const ShowCalendarState({required this.id, this.event}) : super();
  final int id;
  final Events? event;
  @override
  List<Object?> get props => [];
}

class HideCalendarState extends TitleState {
  const HideCalendarState() : super();

  @override
  List<Object?> get props => [];
}
