import 'package:calendarapp/src/generated/protos/login.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart';

class LoginClient {
  late final LoginServiceClient _stub;

  LoginClient(ClientChannel channel) {
    _stub = LoginServiceClient(channel);
  }

  Future<GeneratedMessage> login(User user) async {
    final request = LoginRequest()..user = user;
    try {
      final response = await _stub.login(request);
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }

  Future<GeneratedMessage> signup(User user) async {
    final request = LoginRequest()..user = user;
    try {
      final response = await _stub.signup(request);
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }

  Future<GeneratedMessage> fetchRefreshToken(User user) async {
    final request = LoginRequest()..user = user;
    try {
      final response = await _stub.refreshTokenHandler(request);
      return response;
    } on GrpcError catch (e) {
      print('Caught error: $e');
      return ErrorInfo(reason: e.message);
    }
  }
}
