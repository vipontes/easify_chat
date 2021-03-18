import 'package:easify_chat/animations/fade_route.dart';
import 'package:easify_chat/view/home/home_page.dart';
import 'package:easify_chat/view/login/login_page.dart';
import 'package:flutter/material.dart';


class Routes {
  static const String home = '/home';
  static const String login = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case home:
        return FadeRoute(page: HomePage());
      case login:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }

  static RouteSettings _createRouteSettings(String route, {Object data}) {
    return RouteSettings(name: route, arguments: data);
  }

  static void push(BuildContext context, String route, {Object data}) {
    Navigator.of(context).push(
      generateRoute(_createRouteSettings(route, data: data)),
    );
  }

  static void pushRemoveStack(BuildContext context, String route,
      {Object data}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        _createRouteSettings(route).name, (Route<dynamic> route) => false,
        arguments: data);
  }

  static void replace(BuildContext context, String route) {
    Navigator.of(context).pushReplacement(
      generateRoute(_createRouteSettings(route)),
    );
  }

  static void makeFirst(BuildContext context, String route) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
    Navigator.of(context).pushReplacement(
      generateRoute(_createRouteSettings(route)),
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
