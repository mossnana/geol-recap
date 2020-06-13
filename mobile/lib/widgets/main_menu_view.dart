import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geol_recap/bloc/authentication/authentication_bloc.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/models/delegate.dart';
import 'package:geol_recap/screens/about_us_screen.dart';
import 'package:geol_recap/screens/dictionary_screen.dart';
import 'package:geol_recap/screens/user_profile_screen.dart';

class MainMenuView extends StatefulWidget {
  final User userRepository;

  MainMenuView({Key key, this.userRepository}) : super(key: key);

  @override
  createState() {
    return _MainMenuView();
  }
}

class _MainMenuView extends State<MainMenuView> {
  User _userRepository;
  AuthenticationBloc _authenticationBloc;
  Map<String, int> userDetail = {
    'posts': 0,
    'likes': 0,
    'follows': 0,
  };

  Future<void> getFollowers() async {
    var userRepository = await Firestore
        .instance
        .collection('users')
        .document('${_userRepository.uid}')
        .get();
    setState(() {
      userDetail['followers'] = userRepository.data['followers'].length;
    });
  }

  @override
  void initState() {
    super.initState();
    _userRepository = widget.userRepository;
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    getFollowers();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: screenSize.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFEFEFEF)],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      'User profile',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  // User Card
                  UserProfileCard(uid: _userRepository.uid,),
                  SizedBox(
                    height: 25,
                  ),
                  // Bottom Menus
                  // General Setting
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DictionaryScreen()
                        )
                      );
                    },
                    child: Container(
                      width: screenSize.width * 1.069,
                      height: screenSize.height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 18, bottom: 18),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 22.5,
                                  backgroundColor: Color(0xFFFEC85C),
                                  child: Icon(
                                    Icons.book,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Geology Dictionary',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                      Text(
                                        'Geological terms from Geology.com',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFBDBDBD),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // Feedbacks
                  GestureDetector(
                    onTap: () async {
                      String dialog = await showDialog(
                          context: context,
                          builder: (context) {
                            String message = '';
                            Color color = Colors.amber;
                            print(message);
                            return AlertDialog(
                              title: Text('Submit your feedbacks'),
                              content: TextField(
                                onChanged: (value) {
                                  message = value;
                                },
                                autofocus: true,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  labelText: 'Comment',
                                  hintText:
                                      'Message will be sent to developer team',
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Back'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text('Send'),
                                  onPressed: () {
                                    Navigator.of(context).pop(message);
                                  },
                                ),
                              ],
                            );
                          });
                      await Firestore.instance.collection('feedbacks').add({
                        'comments': dialog,
                        'createdBy': widget.userRepository.uid,
                        'createdDate': DateTime.now(),
                      });
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Thank you for your feedback'),
                        ),
                      );
                    },
                    child: Container(
                      width: screenSize.width * 1.069,
                      height: screenSize.height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 18, bottom: 18),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 22.5,
                                  backgroundColor: Color(0xFFF468B7),
                                  child: Icon(
                                    Icons.sentiment_dissatisfied,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Feedback',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                      Text(
                                        'Call for support in any issues',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFBDBDBD),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // About Us
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => AboutUsScreen()
                          )
                      );
                    },
                    child: Container(
                      width: screenSize.width * 1.069,
                      height: screenSize.height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 18, bottom: 18),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 22.5,
                                  backgroundColor: Color(0xFF5FD0D3),
                                  child: Icon(
                                    Icons.face,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'About Us',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                      Text(
                                        'Well knowing about us, developer team',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFBDBDBD),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // Logout
                  GestureDetector(
                    onTap: () {
                      _authenticationBloc.add(LoggedOut());
                    },
                    child: Container(
                      width: screenSize.width * 1.069,
                      height: screenSize.height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 18, bottom: 18),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 22.5,
                                  backgroundColor: Color(0xFF8D7AEE),
                                  child: Icon(
                                    Icons.exit_to_app,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                      Text(
                                        'Exit your account',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFBDBDBD),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}