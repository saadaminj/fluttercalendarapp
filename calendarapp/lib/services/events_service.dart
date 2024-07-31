import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart';

import '../src/generated/protos/events.pbgrpc.dart';

class EventClient {
  late final EventServiceClient _stub;

  EventClient(ClientChannel channel) {
    _stub = EventServiceClient(channel);
  }

  Future<GeneratedMessage> createEvent(Event event) async {
    final request = EventRequest()..event = event;
    try {
      final response = await _stub.createEvent(request);
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }

  Future<GeneratedMessage> getEventById(int id) async {
    final request = EventRequest()..event = Event(id: id);
    try {
      final response = await _stub.getEventById(request);
      print('Event fetched: ${response.event}');
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }

  Future<GeneratedMessage> updateEvent(Event event) async {
    final request = EventRequest()..event = event;
    try {
      final response = await _stub.updateEvent(request);
      print('Event updated: ${response.event}');
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }

  Future<GeneratedMessage> deleteEvent(int id) async {
    final request = EventRequest()..event = Event(id: id);
    try {
      final response = await _stub.deleteEvent(request);
      print('Event deleted');
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }

  Future<GeneratedMessage> listEvents() async {
    final request = EventRequest();
    try {
      final response = await _stub.listEvents(request);
      print('Event list: ${response.events}');
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }
}
