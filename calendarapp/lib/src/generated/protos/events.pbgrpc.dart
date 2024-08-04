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

import 'events.pb.dart' as $1;

export 'events.pb.dart';

@$pb.GrpcServiceName('events.EventService')
class EventServiceClient extends $grpc.Client {
  static final _$createEvent = $grpc.ClientMethod<$1.EventRequest, $1.EventResponse>(
      '/events.EventService/CreateEvent',
      ($1.EventRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.EventResponse.fromBuffer(value));
  static final _$getEventById = $grpc.ClientMethod<$1.EventRequest, $1.EventResponse>(
      '/events.EventService/GetEventById',
      ($1.EventRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.EventResponse.fromBuffer(value));
  static final _$updateEvent = $grpc.ClientMethod<$1.EventRequest, $1.EventResponse>(
      '/events.EventService/UpdateEvent',
      ($1.EventRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.EventResponse.fromBuffer(value));
  static final _$deleteEvent = $grpc.ClientMethod<$1.EventRequest, $1.EventResponse>(
      '/events.EventService/DeleteEvent',
      ($1.EventRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.EventResponse.fromBuffer(value));
  static final _$listEvents = $grpc.ClientMethod<$1.EventRequest, $1.EventListResponse>(
      '/events.EventService/ListEvents',
      ($1.EventRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.EventListResponse.fromBuffer(value));

  EventServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$1.EventResponse> createEvent($1.EventRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createEvent, request, options: options);
  }

  $grpc.ResponseFuture<$1.EventResponse> getEventById($1.EventRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getEventById, request, options: options);
  }

  $grpc.ResponseFuture<$1.EventResponse> updateEvent($1.EventRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateEvent, request, options: options);
  }

  $grpc.ResponseFuture<$1.EventResponse> deleteEvent($1.EventRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteEvent, request, options: options);
  }

  $grpc.ResponseFuture<$1.EventListResponse> listEvents($1.EventRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listEvents, request, options: options);
  }
}

@$pb.GrpcServiceName('events.EventService')
abstract class EventServiceBase extends $grpc.Service {
  $core.String get $name => 'events.EventService';

  EventServiceBase() {
    $addMethod($grpc.ServiceMethod<$1.EventRequest, $1.EventResponse>(
        'CreateEvent',
        createEvent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.EventRequest.fromBuffer(value),
        ($1.EventResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.EventRequest, $1.EventResponse>(
        'GetEventById',
        getEventById_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.EventRequest.fromBuffer(value),
        ($1.EventResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.EventRequest, $1.EventResponse>(
        'UpdateEvent',
        updateEvent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.EventRequest.fromBuffer(value),
        ($1.EventResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.EventRequest, $1.EventResponse>(
        'DeleteEvent',
        deleteEvent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.EventRequest.fromBuffer(value),
        ($1.EventResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.EventRequest, $1.EventListResponse>(
        'ListEvents',
        listEvents_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.EventRequest.fromBuffer(value),
        ($1.EventListResponse value) => value.writeToBuffer()));
  }

  $async.Future<$1.EventResponse> createEvent_Pre($grpc.ServiceCall call, $async.Future<$1.EventRequest> request) async {
    return createEvent(call, await request);
  }

  $async.Future<$1.EventResponse> getEventById_Pre($grpc.ServiceCall call, $async.Future<$1.EventRequest> request) async {
    return getEventById(call, await request);
  }

  $async.Future<$1.EventResponse> updateEvent_Pre($grpc.ServiceCall call, $async.Future<$1.EventRequest> request) async {
    return updateEvent(call, await request);
  }

  $async.Future<$1.EventResponse> deleteEvent_Pre($grpc.ServiceCall call, $async.Future<$1.EventRequest> request) async {
    return deleteEvent(call, await request);
  }

  $async.Future<$1.EventListResponse> listEvents_Pre($grpc.ServiceCall call, $async.Future<$1.EventRequest> request) async {
    return listEvents(call, await request);
  }

  $async.Future<$1.EventResponse> createEvent($grpc.ServiceCall call, $1.EventRequest request);
  $async.Future<$1.EventResponse> getEventById($grpc.ServiceCall call, $1.EventRequest request);
  $async.Future<$1.EventResponse> updateEvent($grpc.ServiceCall call, $1.EventRequest request);
  $async.Future<$1.EventResponse> deleteEvent($grpc.ServiceCall call, $1.EventRequest request);
  $async.Future<$1.EventListResponse> listEvents($grpc.ServiceCall call, $1.EventRequest request);
}
