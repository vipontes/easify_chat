import 'package:easify_chat/enums/view_state.dart';
import 'package:easify_chat/util/connectivity_helper.dart';
import 'package:easify_chat_network/easify_chat_network.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ContactViewModel extends ChangeNotifier {
  List<User> _contacts = List<User>();
  List<User> _contactsForDisplay = List<User>();

  final _viewStateController = BehaviorSubject<ViewState>();
  Stream<ViewState> get viewState => _viewStateController.stream;

  final _contactsDataController = BehaviorSubject<List<User>>();
  Stream<List<User>> get contactsData => _contactsDataController.stream;

  final _contactsFullDataController = BehaviorSubject<List<User>>();
  Stream<List<User>> get contactsFullData => _contactsFullDataController.stream;

  void getContacts() async {
    var connectivity = await ConnectivityHelper.checkConnectivity();
    if (connectivity) {
      UserService().getContacts().then((res) {
        var decodedResponse = res.fold((error) => error, (val) => val);
        if (decodedResponse is List<User>) {
          _contactsDataController.sink.add(decodedResponse);
          _contactsFullDataController.sink.add(decodedResponse);
          _refreshContacts(decodedResponse);
          _viewStateController.add(ViewState.loaded);
          _viewStateController.add(ViewState.idle);
        } else if (decodedResponse is ErrorHandler) {
          var message = decodedResponse.message;
        }
      }).catchError((error) {
        _viewStateController.add(ViewState.error);
      });
    } else {
      _viewStateController.add(ViewState.error);
    }
  }

  void _refreshContacts(List<User> list) {
    _contacts.clear();
    _contactsForDisplay.clear();
    _contacts.addAll(list);
    _contactsForDisplay.addAll(list);
  }

  void onSearchChange(String value) {
    _contactsForDisplay = _contacts.where((item) {
      var name = item.userName.toLowerCase();
      return name.contains(value);
    }).toList();

    _contactsDataController.sink.add(_contactsForDisplay);
  }

  @override
  void dispose() {
    _viewStateController.close();
    _contactsDataController.close();
    _contactsFullDataController.close();
    super.dispose();
  }
}