import 'package:calendarapp/services/token_provider.dart';
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart';

import '../src/generated/protos/events.pbgrpc.dart';

class EventClient {
  late final TokenProvider _tokenProvider;
  late final EventServiceClient _stub;

  EventClient(ClientChannel channel, TokenProvider tokenProvider) {
    _stub = EventServiceClient(channel);
    _tokenProvider = tokenProvider;
  }

  Future<GeneratedMessage> createEvent(Event event) async {
    try {
      var token = _tokenProvider.token;
      var user = _tokenProvider.user;
      final request = EventRequest(event: event, user: user);
      final callOptions =
          CallOptions(metadata: {'authorization': 'Bearer $token'});
      final response = await _stub.createEvent(request, options: callOptions);
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }

  Future<GeneratedMessage> getEventById(int id) async {
    var token = _tokenProvider.token;
    var user = _tokenProvider.user;
    final request = EventRequest(event: Event(id: id), user: user);
    final callOptions =
        CallOptions(metadata: {'authorization': 'Bearer $token'});
    try {
      final response = await _stub.getEventById(request, options: callOptions);
      print('Event fetched: ${response.event}');
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }

  Future<GeneratedMessage> updateEvent(Event event) async {
    var token = _tokenProvider.token;
    var user = _tokenProvider.user;
    final request = EventRequest(event: event, user: user);
    final callOptions =
        CallOptions(metadata: {'authorization': 'Bearer $token'});
    try {
      final response = await _stub.updateEvent(request, options: callOptions);
      print('Event updated: ${response.event}');
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }

  Future<GeneratedMessage> deleteEvent(int id) async {
    var token = _tokenProvider.token;
    var user = _tokenProvider.user;
    final request = EventRequest(event: Event(id: id), user: user);
    final callOptions =
        CallOptions(metadata: {'authorization': 'Bearer $token'});
    try {
      final response = await _stub.deleteEvent(request, options: callOptions);
      print('Event deleted');
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }

  Future<GeneratedMessage> listEvents() async {
    var token = _tokenProvider.token;
    var user = _tokenProvider.user;
    final request = EventRequest(user: user);
    final callOptions =
        CallOptions(metadata: {'authorization': 'Bearer $token'});
    try {
      final response = await _stub.listEvents(request, options: callOptions);
      print('Event list: ${response.events}');
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }
}
