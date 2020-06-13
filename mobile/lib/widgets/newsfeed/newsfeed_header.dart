import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/widgets/newsfeed/newsfeed_highlight.dart';

class NewsfeedHeader extends StatelessWidget {
  final String title;
  final User userRepository;

  const NewsfeedHeader({this.title, this.userRepository});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "$title",
          style: TextStyle(fontSize: screenSize.width * 0.06, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewsfeedLatestPosts(userRepository: userRepository,)
              )
            );
          },
          padding: EdgeInsets.only(
            right: 0
          ),
          child: Text(
            'View More',
            style: TextStyle(
              color: Colors.red
            ),
          ),
        )
      ],
    );
  }
}
