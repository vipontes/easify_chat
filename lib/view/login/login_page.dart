import 'package:easify_chat/animations/fade_animation.dart';
import 'package:easify_chat/enums/view_state.dart';
import 'package:easify_chat/res/app_theme.dart';
import 'package:easify_chat/routes/routes.dart';
import 'package:easify_chat/util/localizations.dart';
import 'package:easify_chat/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginViewModel _viewModel = LoginViewModel();
  String _errorMessage = "";
  var _phoneController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  void initState() {
    _viewModel.viewState.listen((state) {
      switch (state) {
        case ViewState.loading:
          break;
        case ViewState.loaded:
          _viewModel.saveUserData();
          Routes.pushRemoveStack(context, Routes.home);
          break;
        case ViewState.idle:
          break;
        case ViewState.error:
          var msg = "";
          if (this._errorMessage.contains(' ')) {
            msg = this._errorMessage;
          } else {
            msg = AppLocalizations.of(context).translate(this._errorMessage);
          }
          Toast.show(msg, context);
          break;
        default:
          break;
      }
    });

    _viewModel.errorMessage.listen((e) {
      this._errorMessage = e;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: StreamBuilder<ViewState>(
        stream: _viewModel.viewState,
        initialData: ViewState.idle,
        builder: (context, snapshot) {
          return Container(
            height: screenHeight,
            color: AppTheme.nearlyWhite,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: FadeAnimation(
                      1.0,
                      Text(
                        "Chat",
                        style: AppTheme.display1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(
                          1.5,
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                    border: Border(
                                      bottom: BorderSide(color: AppTheme.white),
                                    ),
                                  ),
                                  child: StreamBuilder<String>(
                                      stream: _viewModel.email,
                                      builder: (context, snapshot) {
                                        _phoneController.value =
                                            _phoneController.value
                                                .copyWith(text: snapshot.data);
                                        return TextField(
                                          controller: _phoneController,
                                          onChanged: (value) {
                                            _viewModel.onPhoneChange(value);
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                AppLocalizations.of(context)
                                                    .translate('phone'),
                                            hintStyle: TextStyle(
                                              color: AppTheme.deactivatedText,
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: StreamBuilder<String>(
                                      stream: _viewModel.password,
                                      builder: (context, snapshot) {
                                        _passwordController.value =
                                            _passwordController.value
                                                .copyWith(text: snapshot.data);
                                        return TextField(
                                          obscureText: true,
                                          controller: _passwordController,
                                          onChanged: (value) {
                                            _viewModel.onPasswordChange(value);
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                AppLocalizations.of(context)
                                                    .translate('password'),
                                            hintStyle: TextStyle(
                                              color: AppTheme.deactivatedText,
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        FadeAnimation(
                          2.0,
                          GestureDetector(
                            onTap: () => _viewModel.login(),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppTheme.nearlyBlack),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('login'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
