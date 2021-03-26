import 'package:easify_chat/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool _isLoggedIn = false;

  var prefs = await SharedPreferences.getInstance();
  _isLoggedIn = prefs.getBool(Constants.isLoggedIn) ?? false;

  runApp(ChatApp(
    isLoggedIn: _isLoggedIn,
  ));
}
