//
//  Generated code. Do not modify.
//  source: protos/events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'events.pb.dart' as $0;

export 'events.pb.dart';

@$pb.GrpcServiceName('events.EventService')
class EventServiceClient extends $grpc.Client {
  static final _$createEvent = $grpc.ClientMethod<$0.EventRequest, $0.EventResponse>(
      '/events.EventService/CreateEvent',
      ($0.EventRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.EventResponse.fromBuffer(value));
  static final _$getEventById = $grpc.ClientMethod<$0.EventRequest, $0.EventResponse>(
      '/events.EventService/GetEventById',
      ($0.EventRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.EventResponse.fromBuffer(value));
  static final _$updateEvent = $grpc.ClientMethod<$0.EventRequest, $0.EventResponse>(
      '/events.EventService/UpdateEvent',
      ($0.EventRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.EventResponse.fromBuffer(value));
  static final _$deleteEvent = $grpc.ClientMethod<$0.EventRequest, $0.EventResponse>(
      '/events.EventService/DeleteEvent',
      ($0.EventRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.EventResponse.fromBuffer(value));
  static final _$listEvents = $grpc.ClientMethod<$0.EventRequest, $0.EventListResponse>(
      '/events.EventService/ListEvents',
      ($0.EventRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.EventListResponse.fromBuffer(value));

  EventServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.EventResponse> createEvent($0.EventRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createEvent, request, options: options);
  }

  $grpc.ResponseFuture<$0.EventResponse> getEventById($0.EventRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getEventById, request, options: options);
  }

  $grpc.ResponseFuture<$0.EventResponse> updateEvent($0.EventRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateEvent, request, options: options);
  }

  $grpc.ResponseFuture<$0.EventResponse> deleteEvent($0.EventRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteEvent, request, options: options);
  }

  $grpc.ResponseFuture<$0.EventListResponse> listEvents($0.EventRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listEvents, request, options: options);
  }
}

@$pb.GrpcServiceName('events.EventService')
abstract class EventServiceBase extends $grpc.Service {
  $core.String get $name => 'events.EventService';

  EventServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.EventRequest, $0.EventResponse>(
        'CreateEvent',
        createEvent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EventRequest.fromBuffer(value),
        ($0.EventResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EventRequest, $0.EventResponse>(
        'GetEventById',
        getEventById_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EventRequest.fromBuffer(value),
        ($0.EventResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EventRequest, $0.EventResponse>(
        'UpdateEvent',
        updateEvent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EventRequest.fromBuffer(value),
        ($0.EventResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EventRequest, $0.EventResponse>(
        'DeleteEvent',
        deleteEvent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EventRequest.fromBuffer(value),
        ($0.EventResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EventRequest, $0.EventListResponse>(
        'ListEvents',
        listEvents_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EventRequest.fromBuffer(value),
        ($0.EventListResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.EventResponse> createEvent_Pre($grpc.ServiceCall call, $async.Future<$0.EventRequest> request) async {
    return createEvent(call, await request);
  }

  $async.Future<$0.EventResponse> getEventById_Pre($grpc.ServiceCall call, $async.Future<$0.EventRequest> request) async {
    return getEventById(call, await request);
  }

  $async.Future<$0.EventResponse> updateEvent_Pre($grpc.ServiceCall call, $async.Future<$0.EventRequest> request) async {
    return updateEvent(call, await request);
  }

  $async.Future<$0.EventResponse> deleteEvent_Pre($grpc.ServiceCall call, $async.Future<$0.EventRequest> request) async {
    return deleteEvent(call, await request);
  }

  $async.Future<$0.EventListResponse> listEvents_Pre($grpc.ServiceCall call, $async.Future<$0.EventRequest> request) async {
    return listEvents(call, await request);
  }

  $async.Future<$0.EventResponse> createEvent($grpc.ServiceCall call, $0.EventRequest request);
  $async.Future<$0.EventResponse> getEventById($grpc.ServiceCall call, $0.EventRequest request);
  $async.Future<$0.EventResponse> updateEvent($grpc.ServiceCall call, $0.EventRequest request);
  $async.Future<$0.EventResponse> deleteEvent($grpc.ServiceCall call, $0.EventRequest request);
  $async.Future<$0.EventListResponse> listEvents($grpc.ServiceCall call, $0.EventRequest request);
}
