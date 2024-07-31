//
//  Generated code. Do not modify.
//  source: protos/events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use eventDescriptor instead')
const Event$json = {
  '1': 'Event',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'date', '3': 3, '4': 1, '5': 9, '10': 'date'},
    {'1': 'time', '3': 4, '4': 1, '5': 9, '10': 'time'},
  ],
};

/// Descriptor for `Event`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDescriptor = $convert.base64Decode(
    'CgVFdmVudBIOCgJpZBgBIAEoBVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhIKBGRhdGUYAy'
    'ABKAlSBGRhdGUSEgoEdGltZRgEIAEoCVIEdGltZQ==');

@$core.Deprecated('Use eventRequestDescriptor instead')
const EventRequest$json = {
  '1': 'EventRequest',
  '2': [
    {'1': 'event', '3': 1, '4': 1, '5': 11, '6': '.events.Event', '10': 'event'},
  ],
};

/// Descriptor for `EventRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventRequestDescriptor = $convert.base64Decode(
    'CgxFdmVudFJlcXVlc3QSIwoFZXZlbnQYASABKAsyDS5ldmVudHMuRXZlbnRSBWV2ZW50');

@$core.Deprecated('Use eventResponseDescriptor instead')
const EventResponse$json = {
  '1': 'EventResponse',
  '2': [
    {'1': 'event', '3': 1, '4': 1, '5': 11, '6': '.events.Event', '10': 'event'},
  ],
};

/// Descriptor for `EventResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventResponseDescriptor = $convert.base64Decode(
    'Cg1FdmVudFJlc3BvbnNlEiMKBWV2ZW50GAEgASgLMg0uZXZlbnRzLkV2ZW50UgVldmVudA==');

@$core.Deprecated('Use eventListResponseDescriptor instead')
const EventListResponse$json = {
  '1': 'EventListResponse',
  '2': [
    {'1': 'events', '3': 1, '4': 3, '5': 11, '6': '.events.Event', '10': 'events'},
  ],
};

/// Descriptor for `EventListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventListResponseDescriptor = $convert.base64Decode(
    'ChFFdmVudExpc3RSZXNwb25zZRIlCgZldmVudHMYASADKAsyDS5ldmVudHMuRXZlbnRSBmV2ZW'
    '50cw==');

