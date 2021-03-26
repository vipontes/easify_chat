import 'package:easify_chat/enums/view_state.dart';
import 'package:easify_chat/util/connectivity_helper.dart';
import 'package:easify_chat/util/constants.dart';
import 'package:easify_chat_network/api/error_handler/error_handler.dart';
import 'package:easify_chat_network/api/login_service.dart';
import 'package:easify_chat_network/model/user.dart';
import 'package:easify_chat_sqlite/database/moor_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../chat_app.dart';

class LoginViewModel extends ChangeNotifier {
  final _viewStateController = BehaviorSubject<ViewState>();
  final _phoneController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _errorMessage = BehaviorSubject<String>();

  Stream<String> get email => _phoneController.stream;

  Function(String) get onPhoneChange => _phoneController.add;

  Stream<String> get password => _passwordController.stream;

  Function(String) get onPasswordChange => _passwordController.add;

  Stream<ViewState> get viewState => _viewStateController.stream;

  Stream<String> get errorMessage => _errorMessage.stream;

  User _user;

  String _loggedUserPassword = "";

  Future<bool> login() async {
    final email = _phoneController.value;
    final password = _passwordController.value;
    _loggedUserPassword = password;

    var connectivity = await ConnectivityHelper.checkConnectivity();
    if (!connectivity) {
      _errorMessage.add("internet_connection_error");
      _viewStateController.add(ViewState.error);
      return false;
    }

    LoginService().login(email, password).then((res) async {
      var decodedResponse = res.fold((error) => error, (val) => val);
      if (decodedResponse is User) {
        _user = decodedResponse;
        _viewStateController.add(ViewState.loaded);
      } else if (decodedResponse is ErrorHandler) {
        final ErrorHandler e = decodedResponse;
        if (e.message != null)
          _errorMessage.add(e.message);
        else
          _errorMessage.add("internal_error");
        _viewStateController.add(ViewState.error);
        return false;
      }
      return true;
    }).catchError((error) {
      _errorMessage.add("internal_error");
      _viewStateController.add(ViewState.error);
      return false;
    });
  }

  Future<void> saveUserData() async {
    if (_user != null) {
      await _saveTokenIntoSharedPreferences();
      await _saveUserIntoLocalDatabase();
    }
  }

  Future _saveUserIntoLocalDatabase() async {
    LocalAuth user = LocalAuth(
        userId: _user.userId,
        userFullName: _user.userName,
        userPhone: _user.userPhone,
        userPass: _loggedUserPassword,
        userAccessGranted: _user.userAccessGranted,
        userCreatedAt: _user.userCreatedAt,
        userToken: _user.userToken,
        userRefreshToken: _user.userRefreshToken);
    
    final database = Provider.of<AppDatabase>(navigatorKey.currentContext);
    await database.localAuthDao.deleteAll();
    await database.localAuthDao.insertAuth(user);
  }

  Future _saveTokenIntoSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.isLoggedIn, true);
    await prefs.setString(Constants.token, _user.userToken);
    await prefs.setString(Constants.refreshToken, _user.userRefreshToken);
  }

  @override
  void dispose() {
    _viewStateController.close();
    _phoneController.close();
    _passwordController.close();
    _errorMessage.close();
    super.dispose();
  }
}
