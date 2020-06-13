import 'package:flutter/material.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/widgets/editor/editor.dart';
import 'package:geol_recap/widgets/explore/explore.dart';
import 'package:geol_recap/widgets/newsfeed/newsfeed_header.dart';
import 'package:geol_recap/widgets/newsfeed/newsfeed_categories_widget.dart';
import 'newsfeed_highlight.dart';

class NewsfeedFragment extends StatefulWidget {
  final User userRepository;

  NewsfeedFragment({this.userRepository});

  @override
  State<NewsfeedFragment> createState() {
    return _NewsfeedFragment();
  }
}

class _NewsfeedFragment extends State<NewsfeedFragment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        height: screenSize.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: screenSize.width * 0.048,
              right: screenSize.width * 0.048,
              bottom: screenSize.height * 0.022,
              top: screenSize.height * 0.011
            ),
            child: Column(
              children: <Widget>[
                // Header
                Container(
                  width: double.infinity,
                  height: screenSize.height * 0.057,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.navigate_before,
                          size: 40,
                          color: Colors.white,
                        ),
                        Text(
                          "GEOL RECAP",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        Icon(
                          Icons.navigate_before,
                          color: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
                // New Post Button
                Container(
                  height: screenSize.height * 0.057,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewPostFragment(userRepository: widget.userRepository,)
                        )
                      );
                    },
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, color: Colors.white,),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'New story',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.011,),
                Container(
                  height: screenSize.height * 0.057,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ExploreFragment(userRepository: widget.userRepository,)
                          )
                      );
                    },
                    color: Colors.blueAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.map, color: Colors.white,),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Explore from map',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.011,),
                // Categories
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Topics",
                      style:
                      TextStyle(fontSize: screenSize.width * 0.06, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.011,
                ),
                NewsfeedCategories(
                  userRepository: widget.userRepository,
                ),
                // Latest Post Section
                NewsfeedHeader(
                  title: 'Latest',
                  userRepository: widget.userRepository,
                ),
                SizedBox(
                  height: screenSize.height * 0.011,
                ),
                NewsfeedLatestPost(
                  userRepository: widget.userRepository,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
