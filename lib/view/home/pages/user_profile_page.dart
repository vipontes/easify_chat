import 'package:easify_chat/model/profile.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage({Key key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Profile profile = Profile(
    imageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
    title: 'Sarah Rodriguez',
    subtitle: 'Developer',
    totalPost: '31sss2',
    totalFollowers: '12.4m',
    totalFollowing: '13.2m',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 750),
            transitionBuilder: (Widget child, Animation<double> animation) => SlideTransition(
              child: child,
              position: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(animation),
            ),
            child: HeaderSection(
              profile: profile,
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final Profile profile;
  HeaderSection({
    this.profile,
    Key key,
  }) : super(key: ValueKey<String>(profile.imageUrl));

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 110,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(image: NetworkImage(profile.imageUrl), fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: Text(
              profile.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          SizedBox(height: 50),
          Container(
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Text("Logout", style: TextStyle(fontSize: 16),),
                SizedBox(height: 6,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}