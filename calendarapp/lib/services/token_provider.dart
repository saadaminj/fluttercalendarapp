import 'package:calendarapp/services/login_service.dart';
import 'package:calendarapp/src/generated/protos/login.pbgrpc.dart';
import 'package:fixnum/src/int64.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../src/generated/protos/login.pb.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenProvider {
  final String _jwtTokenKey = 'jwtToken';
  final String _jwtRefreshTokenKey = 'jwtRefreshToken';
  final String _userKey = 'calendarAppUser';
  String _token = '';
  String _refreshToken = '';
  User user = User();

  String get token => _token;
  String get refreshToken => _refreshToken;

  TokenProvider();

  Future<String> loadToken(LoginClient loginService) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_jwtTokenKey) ?? '';
    _refreshToken = prefs.getString(_jwtRefreshTokenKey) ?? '';
    if (isTokenExpired(token)) {
      String username = prefs.getString('${_userKey}username') ?? '';
      var response = await loginService.fetchRefreshToken(
          User(username: username, refreshToken: _refreshToken));
      if (response is LoginResponse) {
        saveToken(response.user.token, response.user.refreshToken);
      }
    }
    return _token;
  }

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  Future<User> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user.email = prefs.getString('${_userKey}email') ?? '';
    int i = prefs.getInt('${_userKey}id') ?? 0;
    user.userId = Int64(i);
    user.firstname = prefs.getString('${_userKey}firstname') ?? '';
    user.lastname = prefs.getString('${_userKey}lastname') ?? '';
    user.username = prefs.getString('${_userKey}username') ?? '';
    return user;
  }

  Future<void> saveToken(String token, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jwtTokenKey, token);
    await prefs.setString(_jwtRefreshTokenKey, refreshToken);
    _token = token;
    _refreshToken = refreshToken;
  }

  Future<void> saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_userKey}email', user.email);
    await prefs.setInt('${_userKey}id', user.userId.toInt());
    await prefs.setString('${_userKey}firstname', user.firstname);
    await prefs.setString('${_userKey}lastname', user.lastname);
    await prefs.setString('${_userKey}username', user.username);
    this.user = user;
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jwtTokenKey);
    await prefs.remove(_jwtRefreshTokenKey);
    _token = '';
    _refreshToken = '';
  }

  Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove user data from SharedPreferences
    await prefs.remove('${_userKey}email');
    await prefs.remove('${_userKey}id');
    await prefs.remove('${_userKey}firstname');
    await prefs.remove('${_userKey}lastname');
    await prefs.remove('${_userKey}username');
    user.clear();
  }
}
