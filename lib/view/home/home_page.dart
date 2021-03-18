import 'package:easify_chat/res/app_theme.dart';
import 'package:easify_chat/routes/routes.dart';
import 'package:easify_chat/view_model/home_view_model.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel _viewModel = HomeViewModel();

  List<String> listTitle = ['title1', 'title2', 'title3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat'), actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.exit_to_app,
          ),
          onPressed: () {
            _viewModel.logout();
            Routes.pushRemoveStack(context, Routes.login);
          },
        )
      ]),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Text("Home"),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
