import 'package:easify_chat/enums/view_state.dart';
import 'package:easify_chat/util/localizations.dart';
import 'package:easify_chat/view/home/widget/contact_list.dart';
import 'package:easify_chat/view_model/contact_view_model.dart';
import 'package:easify_chat_network/easify_chat_network.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ContactViewModel _viewModel = ContactViewModel();
  var _searchController = TextEditingController();

  @override
  void initState() {
    _viewModel.getContacts();

    _viewModel.viewState.listen((state) {
      switch (state) {
        case ViewState.error:
          break;
        case ViewState.loading:
        case ViewState.loaded:
        case ViewState.idle:
        default:
          break;
      }
    });

    _viewModel.contactsFullData.listen((data) {
      _searchController.text = "";
      setState(() {});
    });

    super.initState();
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).translate('search'),
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
            size: 20,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade100)),
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          _viewModel.onSearchChange(text);
        },
      ),
    );
  }

  Future<Null> _refreshLocalData() {
    return Future.delayed(Duration(milliseconds: 600), () async {
      //_viewModel.refreshLocalData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Contacts",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            _searchBar(),
            StreamBuilder<List<User>>(
                stream: _viewModel.contactsData,
                builder: (context, snapshot) {
                  var data = snapshot.data;
                  if (data == null) {
                    return GestureDetector(
                      onTap: () => _refreshLocalData(),
                      child: Center(
                        child: Image.asset(
                          "assets/img/logo.png",
                          fit: BoxFit.fill,
                          width: 200,
                          height: 200,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 16),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ContactList(user: data[index]);
                      },
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
