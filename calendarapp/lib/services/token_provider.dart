import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider {
  final String _jwtTokenKey = 'jwtToken';
  String _token = '';

  String get token => _token;

  TokenProvider();

  Future<String> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_jwtTokenKey) ?? '';
    return _token;
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jwtTokenKey, token);
    _token = token;
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jwtTokenKey);
    _token = '';
  }
}
