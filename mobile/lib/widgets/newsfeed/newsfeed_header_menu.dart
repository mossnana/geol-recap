import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/screens/dictionary_screen.dart';
import 'package:geol_recap/widgets/editor/editor.dart';

class NewsfeedHeaderMenu extends StatelessWidget {
  final User userRepository;

  NewsfeedHeaderMenu({this.userRepository});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Row(
      children: <Widget>[
        // Single Menu
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewPostFragment(userRepository: userRepository,),
                ),
              );
            },
            child: Container(
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Color(0xFFFD7384)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  Text("Post", style: TextStyle(color: Colors.white))
                ],
              ),
            ),
          ),
        ),
        // Upper Row
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DictionaryScreen()
                )
              );
            },
            child: Container(
              height: 100.0,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(1),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0XFF2BD093),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 10,),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.collections_bookmark,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Dictionary',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NewPostFragment(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0XFFFC7B4D),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.map,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Map',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        // Lower Row
        Expanded(
          child: Container(
            height: screenSize.height * 0.114,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(1),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0XFFF1B069),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 10,),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.perm_identity,
                              color: Colors.white,
                            ),
                          ),
                          Text('My Profile',
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(1),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0XFF53CEDB),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 10,),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                          Text('More', style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
