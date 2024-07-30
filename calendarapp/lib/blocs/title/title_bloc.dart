import 'package:bloc/bloc.dart';
import 'package:calendarapp/services/title_service.dart';
import 'package:calendarapp/blocs/title/title_event.dart';
import 'package:calendarapp/blocs/title/title_state.dart';

class TitleBloc extends Bloc<TitleEvent, TitleState> {
  final TitleService titleService;
  TitleBloc(this.titleService) : super(const TitleInitial()) {
    on<OpenWidgetEvent>((event, emit) => const OpenWidgetState());
    on<CloseWidgetEvent>((event, emit) => const CloseWidgetState());
    on<ShowCalendarEvent>((event, emit) {
      emit(ShowCalendarState(id: event.id, event: event.event));
    });
    on<HideCalendarEvent>((event, emit) {
      emit(const HideCalendarState());
    });
  }
}
