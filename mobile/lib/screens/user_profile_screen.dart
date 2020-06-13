import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/models/delegate.dart';
import 'package:geol_recap/widgets/editor/editor.dart';
import 'package:geol_recap/widgets/loading_widget.dart';

class UserProfileScreen extends StatefulWidget {
  final String uid;
  final User userRepository;

  UserProfileScreen({this.uid, this.userRepository});

  @override
  State<StatefulWidget> createState() {
    return _UserProfileScreen();
  }
}

class _UserProfileScreen extends State<UserProfileScreen> {
  User _user = User.init();

  Future<void> getUserData() async {
    User user = await UserDelegate.getUserFromUid(uid: widget.uid);
    setState(() {
      _user = user;
    });
  }

  _unFollow() async {
    bool result = await UserDelegate.unFollowUserFromUid(
        fromUid: widget.userRepository.uid, toUid: widget.uid);
    await getUserData();
  }

  _follow() async {
    bool result = await UserDelegate.followUserFromUid(
        fromUid: widget.userRepository.uid, toUid: widget.uid);
    await getUserData();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: screenSize.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  UserProfileCard(
                    uid: widget.uid,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // Follow Button
                      UserDelegate.isFollowedFromUser(
                              fromUser: widget.userRepository, toUser: _user)
                          ? GestureDetector(
                              onTap: _unFollow,
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 22.5,
                                    backgroundColor: Color(0xFFF6F5F8),
                                    child: Icon(
                                      Icons.remove_circle,
                                      color: Color(0xFF42526F),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    'Unfollow',
                                    style: TextStyle(
                                        color: Color(0xFF42526F),
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: _follow,
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 22.5,
                                    backgroundColor: Color(0xFFF6F5F8),
                                    child: Icon(
                                      Icons.group_add,
                                      color: Color(0xFF42526F),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    'Follow',
                                    style: TextStyle(
                                        color: Color(0xFF42526F),
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                      // Report Button
                      Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 22.5,
                            backgroundColor: Color(0xFFF6F5F8),
                            child: Icon(
                              Icons.report,
                              color: Color(0xFF42526F),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            'Report',
                            style: TextStyle(
                              color: Color(0xFF42526F),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: PostDelegate.getUserPostsByStream(uid: widget.uid),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Text('Loading...');
                        default:
                          if (snapshot.data.documents.isEmpty) {
                            return Center(
                              child: Text('No own posts'),
                            );
                          } else {
                            List<Post> posts =
                                snapshot.data.documents.map<Post>((post) {
                              return Post.fromJson(post.documentID, post.data);
                            }).toList();
                            return Column(
                              children: posts
                                  .map(
                                    (post) => Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Container(
                                                  height: screenSize.height * 0.384,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    image: DecorationImage(
                                                      image: post.imageUrls
                                                              .isNotEmpty
                                                          ? NetworkImage(
                                                              post.imageUrls[0],
                                                              scale: 0.5)
                                                          : NetworkImage(
                                                              'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg',
                                                            ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              post.title,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w500),
                                              softWrap: false,
                                              overflow: TextOverflow.fade,
                                            ),
                                            Text(
                                              post.subTitle,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey),
                                              softWrap: false,
                                              overflow: TextOverflow.fade,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '${post.toDateString}',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '${post.uidFavorite.length} Likes',
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserProfileCard extends StatelessWidget {
  String uid;

  UserProfileCard({this.uid});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    Widget loadingWidget = Container(
      width: screenSize.width * 1.069,
      height: screenSize.height * 0.213,
      decoration: BoxDecoration(
        color: Color(0xFF3977FF),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 20.0,
            spreadRadius: 0.0,
            offset: Offset(
              0.0,
              5.0,
            ),
          )
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 18, bottom: 18),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.white,
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
                        '-',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                      Text(
                        '-',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB0C9FF),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '-',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Posts',
                      style: TextStyle(
                        color: Color(0xFFB0C9FF),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '-',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Likes',
                      style: TextStyle(
                        color: Color(0xFFB0C9FF),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '-',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Followers',
                      style: TextStyle(
                        color: Color(0xFFB0C9FF),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
    Widget loadedWidget(user) {
      return Container(
        width: screenSize.width * 1.069,
        height: screenSize.height * 0.213,
        decoration: BoxDecoration(
          color: Color(0xFF3977FF),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 20.0,
              spreadRadius: 0.0,
              offset: Offset(
                0.0,
                5.0,
              ),
            )
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, top: 18, bottom: 18),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage('${user.profileUrl}'),
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
                          '${user.displayName}',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                        Text(
                          '${user.email}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFB0C9FF),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              UserProfileStatisticRow(
                user: user,
              )
            ],
          ),
        ),
      );
    }

    return FutureBuilder(
      future: UserDelegate.getUserFromUid(uid: uid),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return loadedWidget(snapshot.data);
          default:
            return loadingWidget;
        }
      },
    );
  }
}

class UserProfileStatisticRow extends StatelessWidget {
  final User user;

  UserProfileStatisticRow({this.user});

  @override
  Widget build(BuildContext context) {
    Widget loadingWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '-',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              'Posts',
              style: TextStyle(
                color: Color(0xFFB0C9FF),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '-',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              'Likes',
              style: TextStyle(
                color: Color(0xFFB0C9FF),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '-',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              'Follows',
              style: TextStyle(
                color: Color(0xFFB0C9FF),
              ),
            ),
          ],
        ),
      ],
    );
    Widget loadedWidget(data) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${data['posts']}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                'Posts',
                style: TextStyle(
                  color: Color(0xFFB0C9FF),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${data['likes']}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                'Likes',
                style: TextStyle(
                  color: Color(0xFFB0C9FF),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${data['followers']}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                'Followers',
                style: TextStyle(
                  color: Color(0xFFB0C9FF),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return FutureBuilder(
      future: UserDelegate.getUserStatisticFromUser(user: user),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return loadedWidget(snapshot.data);
          default:
            return loadingWidget;
        }
      },
    );
  }
}
