import 'package:bloc/bloc.dart';
import 'package:calendarapp/services/events_service.dart';
import 'package:calendarapp/blocs/events/events_event.dart';
import 'package:calendarapp/blocs/events/events_state.dart';
import 'package:calendarapp/src/generated/protos/events.pb.dart';
import 'package:grpc/grpc.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventClient eventService;
  EventBloc(this.eventService) : super(const EventInitial()) {
    on<ShowCalendarEvent>((event, emit) {
      emit(ShowCalendarState(id: event.id, event: event.event));
    });
    on<HideCalendarEvent>((event, emit) {
      emit(const HideCalendarState());
    });
    on<CreateEvent>((event, emit) async {
      final response = await eventService.createEvent(event.event);
      if (response is EventResponse) {
        emit(const CreateEventState());
      } else if (response is ErrorInfo) {
        emit(RequestFailedState(response.reason));
      }
    });
    on<DeleteEvent>((event, emit) async {
      final response = await eventService.deleteEvent(event.id);
      if (response is EventResponse) {
        emit(const DeleteEventState());
      } else if (response is ErrorInfo) {
        emit(RequestFailedState(response.reason));
      }
    });
    on<GetEvent>((event, emit) async {
      final response = await eventService.listEvents();
      if (response is EventListResponse) {
        emit(GetEventsState(response.events));
      } else if (response is ErrorInfo) {
        emit(RequestFailedState(response.reason));
      }
    });
    on<UpdateEvent>((event, emit) async {
      final response = await eventService.updateEvent(event.event);
      if (response is EventResponse) {
        emit(const UpdateEventState());
      } else if (response is ErrorInfo) {
        emit(RequestFailedState(response.reason));
      }
    });
  }
}
