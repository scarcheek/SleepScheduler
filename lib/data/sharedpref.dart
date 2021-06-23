import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    if (value == null) return;
    return json.decode(value);
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
    print('lmao');
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
