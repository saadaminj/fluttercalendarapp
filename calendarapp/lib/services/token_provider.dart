import 'package:fixnum/src/int64.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../src/generated/protos/login.pb.dart';

class TokenProvider {
  final String _jwtTokenKey = 'jwtToken';
  final String _userKey = 'calendarAppUser';
  String _token = '';
  User user = User();

  String get token => _token;

  TokenProvider();

  Future<String> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_jwtTokenKey) ?? '';
    return _token;
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

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jwtTokenKey, token);
    _token = token;
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
    _token = '';
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
