//
//  Generated code. Do not modify.
//  source: protos/login.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'userId', '3': 1, '4': 1, '5': 3, '10': 'userId'},
    {'1': 'firstname', '3': 2, '4': 1, '5': 9, '10': 'firstname'},
    {'1': 'lastname', '3': 3, '4': 1, '5': 9, '10': 'lastname'},
    {'1': 'email', '3': 4, '4': 1, '5': 9, '10': 'email'},
    {'1': 'username', '3': 5, '4': 1, '5': 9, '10': 'username'},
    {'1': 'password', '3': 6, '4': 1, '5': 9, '10': 'password'},
    {'1': 'token', '3': 7, '4': 1, '5': 9, '10': 'token'},
    {'1': 'refreshToken', '3': 8, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEhYKBnVzZXJJZBgBIAEoA1IGdXNlcklkEhwKCWZpcnN0bmFtZRgCIAEoCVIJZmlyc3'
    'RuYW1lEhoKCGxhc3RuYW1lGAMgASgJUghsYXN0bmFtZRIUCgVlbWFpbBgEIAEoCVIFZW1haWwS'
    'GgoIdXNlcm5hbWUYBSABKAlSCHVzZXJuYW1lEhoKCHBhc3N3b3JkGAYgASgJUghwYXNzd29yZB'
    'IUCgV0b2tlbhgHIAEoCVIFdG9rZW4SIgoMcmVmcmVzaFRva2VuGAggASgJUgxyZWZyZXNoVG9r'
    'ZW4=');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.login.User', '10': 'user'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSHwoEdXNlchgBIAEoCzILLmxvZ2luLlVzZXJSBHVzZXI=');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.login.User', '10': 'user'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEh8KBHVzZXIYASABKAsyCy5sb2dpbi5Vc2VyUgR1c2Vy');

