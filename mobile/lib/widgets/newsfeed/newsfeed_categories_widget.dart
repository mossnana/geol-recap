import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/widgets/newsfeed/newsfeed_highlight.dart';

class NewsfeedCategories extends StatelessWidget {
  final User userRepository;

  NewsfeedCategories({this.userRepository});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.114,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewsfeedMiningPosts(userRepository: userRepository,)
                )
              );
            },
            child: NewsfeedCategory(
              title: 'Mining',
              description: 'Mining & Engineering',
              asset: 'assets/images/editor/mining.png',
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => NewsfeedEnvironmentPosts(userRepository: userRepository,)
                    )
                );
              },
              child: NewsfeedCategory(
            title: 'Environment',
            description: 'Enviroment & Hydrology',
            asset: 'assets/images/editor/environment.png',
          )),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => NewsfeedPetroleumPosts(userRepository: userRepository,)
                    )
                );
              },
              child: NewsfeedCategory(
            title: 'Petroleum',
            description: 'Petroleum & Sedimentary',
            asset: 'assets/images/editor/petroleum.png',
          )),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => NewsfeedMorphologyPosts(userRepository: userRepository,)
                    )
                );
              },
              child: NewsfeedCategory(
            title: 'Morphology',
            description: 'Morphology & Structural',
            asset: 'assets/images/editor/morphology.png',
          )),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => NewsfeedOtherPosts(userRepository: userRepository,)
                    )
                );
              },
              child: NewsfeedCategory(
            title: 'Others',
            description: 'Other Topics',
            asset: 'assets/images/editor/others.png',
          )),
        ],
      ),
    );
  }
}

class NewsfeedCategory extends StatelessWidget {
  String title;
  String description;
  String asset;

  NewsfeedCategory({this.title, this.description, this.asset});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFA9A9A9),
              blurRadius: 10.0,
              // has the effect of softening the shadow
              spreadRadius: 0.0,
              // has the effect of extending the shadow
              offset: Offset(
                0.0,
                5.0,
              ),
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ImageIcon(
              AssetImage('${this.asset}'),
              size: screenSize.width * 0.072,
              color: Colors.red,
            ),
            SizedBox(
              width: screenSize.width * 0.024,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${this.title}',
                  style: TextStyle(fontSize: screenSize.width * 0.048, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${this.description}',
                  style: TextStyle(fontSize: screenSize.width * 0.024, color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
