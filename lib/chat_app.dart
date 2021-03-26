import 'package:easify_chat/res/app_theme.dart';
import 'package:easify_chat/routes/routes.dart';
import 'package:easify_chat/util/localizations.dart';
import 'package:easify_chat_sqlite/easify_chat_sqlite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class ChatApp extends StatefulWidget {
  final bool isLoggedIn;

  const ChatApp({Key key, this.isLoggedIn}) : super(key: key);

  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(builder: (context) => AppDatabase()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat',
          theme: AppTheme.lightTheme,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('pt', 'BR'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback:
              (Locale locale, Iterable<Locale> supportedLocales) {
            if (locale == null) {
              return supportedLocales.first;
            }

            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          initialRoute: widget.isLoggedIn ? Routes.home : Routes.login,
          onGenerateRoute: Routes.generateRoute,
          navigatorKey: navigatorKey,
        ),
    );
  }
}
