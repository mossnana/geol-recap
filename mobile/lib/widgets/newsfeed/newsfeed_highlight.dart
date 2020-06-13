import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/models/delegate.dart';
import 'package:geol_recap/widgets/editor/editor.dart';
import 'package:geol_recap/widgets/loading_widget.dart';
import 'package:geol_recap/widgets/not_found_widget.dart';
import 'package:geol_recap/widgets/post.dart';

class NewsfeedPopularPost extends StatelessWidget {
  final User userRepository;

  NewsfeedPopularPost({this.userRepository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: PostDelegate.getPopularPostsByStream(limit: 1),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.active:
            Post post = Post.fromJson(snapshot.data.documents[0].documentID, snapshot.data.documents[0].data);
            return PostCard(post: post, userRepository: userRepository,);
          default:
            return LoadingWidget();
        }
      },
    );
  }
}

class NewsfeedPopularPosts extends StatelessWidget {
  final User userRepository;

  NewsfeedPopularPosts({this.userRepository});

  Stream<QuerySnapshot> _firestoreStream = Firestore.instance
      .collection('posts')
      .orderBy('uidFavorite', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Popular',
          style: TextStyle(color: Color(0xFF3A3556)),
        ),
        iconTheme: IconThemeData(color: Color(0xFF3A3556)),
        flexibleSpace: Container(
          color: Colors.white,
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          height: screenSize.height,
          child: StreamBuilder(
            stream: _firestoreStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return ListView.separated(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    Post post =
                        Post.fromJson(snapshot.data.documentID, snapshot.data);
                    print(post);
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViewPostFragment(
                              postId: snapshot.data.documents[index].documentID,
                              userRepository: userRepository,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 40,
                          left: 40,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Container(
                          height: screenSize.height * 0.205,
                          child: Padding(
                            padding: EdgeInsets.only(top: 30, bottom: 30),
                            child: Row(
                              children: <Widget>[
                                Image.network(
                                  '${snapshot.data.documents[index]['imageUrls'][0]}',
                                  height: screenSize.height * 0.136,
                                  width: screenSize.width * 0.291,
                                  filterQuality: FilterQuality.low,
                                  fit: BoxFit.fitWidth,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'A minute ago',
                                      style: TextStyle(
                                          color: Color(0xFF3A3556),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Divider(),
                                    Container(
                                      width: screenSize.width * 0.461,
                                      height: screenSize.height * 0.091,
                                      child: Text(
                                        '${snapshot.data.documents[index]['title']}',
                                        style: TextStyle(
                                            color: Color(0xFF918F9D),
                                            fontWeight: FontWeight.w700),
                                        overflow: TextOverflow.fade,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, _) {
                    return Divider();
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class NewsfeedLatestPost extends StatelessWidget {
  final User userRepository;

  NewsfeedLatestPost({this.userRepository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: PostDelegate.getLatestPostsByStream(limit: 1),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.active:
            Post post = Post.fromJson(snapshot.data.documents[0].documentID, snapshot.data.documents[0].data);
            return PostCard(post: post, userRepository: userRepository,);
          default:
            return LoadingWidget();
        }
      },
    );
  }
}

class NewsfeedLatestPosts extends StatelessWidget {
  final User userRepository;
  NewsfeedLatestPosts({this.userRepository});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: -----------------------
      body: StreamBuilder<QuerySnapshot>(
        stream: PostDelegate.getLatestPostsByStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              if (snapshot.data.documents.isEmpty) {
                return Text('Error');
              } else {
                List<Post> posts = snapshot.data.documents.map<Post>((post) {
                  return Post.fromJson(post.documentID, post.data);
                }).toList();
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewPostFragment(
                                          postId: posts[index].id,
                                          userRepository: userRepository,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 337.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: posts[index].imageUrls.isNotEmpty
                                            ? NetworkImage(posts[index].imageUrls[0],
                                            scale: 0.5)
                                            : NetworkImage(
                                          'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              posts[index].title,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              posts[index].subTitle,
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
                                  '${posts[index].toDateString}',
                                  style: TextStyle(color: Colors.grey),
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
                                  '${posts[index].uidFavorite.length} Likes',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}

class NewsfeedMiningPosts extends StatelessWidget {
  final User userRepository;
  NewsfeedMiningPosts({this.userRepository});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: PostDelegate.getMiningPostsByStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingWidget();
            default:
              if (snapshot.data.documents.isEmpty) {
                return Center(
                  child: Text('No Post in this Topic'),
                );
              } else {
                List<Post> posts = snapshot.data.documents.map<Post>((post) {
                  return Post.fromJson(post.documentID, post.data);
                }).toList();
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewPostFragment(
                                          postId: posts[index].id,
                                          userRepository: userRepository,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 337.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: posts[index].imageUrls.isNotEmpty
                                            ? NetworkImage(posts[index].imageUrls[0],
                                            scale: 0.5)
                                            : NetworkImage(
                                          'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              posts[index].title,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              posts[index].subTitle,
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
                                  '${posts[index].toDateString}',
                                  style: TextStyle(color: Colors.grey),
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
                                  '${posts[index].uidFavorite.length} Likes',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}

class NewsfeedEnvironmentPosts extends StatelessWidget {
  final User userRepository;
  NewsfeedEnvironmentPosts({this.userRepository});
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: PostDelegate.getEnvironmentPostsByStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingWidget();
            default:
              if (snapshot.data.documents.isEmpty) {
                return Center(
                  child: Text('No Post in this Topic'),
                );
              } else {
                List<Post> posts = snapshot.data.documents.map<Post>((post) {
                  return Post.fromJson(post.documentID, post.data);
                }).toList();
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewPostFragment(
                                          postId: posts[index].id,
                                          userRepository: userRepository,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: screenSize.height * 0.384,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: posts[index].imageUrls.isNotEmpty
                                            ? NetworkImage(posts[index].imageUrls[0],
                                            scale: 0.5)
                                            : NetworkImage(
                                          'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              posts[index].title,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              posts[index].subTitle,
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
                                  '${posts[index].toDateString}',
                                  style: TextStyle(color: Colors.grey),
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
                                  '${posts[index].uidFavorite.length} Likes',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}

class NewsfeedPetroleumPosts extends StatelessWidget {
  final User userRepository;
  NewsfeedPetroleumPosts({this.userRepository});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: PostDelegate.getPetroleumPostsByStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingWidget();
            default:
              if (snapshot.data.documents.isEmpty) {
                return Center(
                  child: Text('No Post in this Topic'),
                );
              } else {
                List<Post> posts = snapshot.data.documents.map<Post>((post) {
                  return Post.fromJson(post.documentID, post.data);
                }).toList();
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewPostFragment(
                                          postId: posts[index].id,
                                          userRepository: userRepository,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 337.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: posts[index].imageUrls.isNotEmpty
                                            ? NetworkImage(posts[index].imageUrls[0],
                                            scale: 0.5)
                                            : NetworkImage(
                                          'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              posts[index].title,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              posts[index].subTitle,
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
                                  '${posts[index].toDateString}',
                                  style: TextStyle(color: Colors.grey),
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
                                  '${posts[index].uidFavorite.length} Likes',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}

class NewsfeedMorphologyPosts extends StatelessWidget {
  final User userRepository;
  NewsfeedMorphologyPosts({this.userRepository});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: PostDelegate.getMorphologyPostsByStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingWidget();
            default:
              if (snapshot.data.documents.isEmpty) {
                return Center(
                  child: Text('No Post in this Topic'),
                );
              } else {
                List<Post> posts = snapshot.data.documents.map<Post>((post) {
                  return Post.fromJson(post.documentID, post.data);
                }).toList();
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewPostFragment(
                                          postId: posts[index].id,
                                          userRepository: userRepository,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 337.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: posts[index].imageUrls.isNotEmpty
                                            ? NetworkImage(posts[index].imageUrls[0],
                                            scale: 0.5)
                                            : NetworkImage(
                                          'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              posts[index].title,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              posts[index].subTitle,
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
                                  '${posts[index].toDateString}',
                                  style: TextStyle(color: Colors.grey),
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
                                  '${posts[index].uidFavorite.length} Likes',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}

class NewsfeedOtherPosts extends StatelessWidget {
  final User userRepository;
  NewsfeedOtherPosts({this.userRepository});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: PostDelegate.getOtherPostsByStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingWidget();
            default:
              if (snapshot.data.documents.isEmpty) {
                return Center(
                  child: Text('No Post in this Topic'),
                );
              } else {
                List<Post> posts = snapshot.data.documents.map<Post>((post) {
                  return Post.fromJson(post.documentID, post.data);
                }).toList();
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewPostFragment(
                                          postId: posts[index].id,
                                          userRepository: userRepository,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 337.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: posts[index].imageUrls.isNotEmpty
                                            ? NetworkImage(posts[index].imageUrls[0],
                                            scale: 0.5)
                                            : NetworkImage(
                                          'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              posts[index].title,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              posts[index].subTitle,
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
                                  '${posts[index].toDateString}',
                                  style: TextStyle(color: Colors.grey),
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
                                  '${posts[index].uidFavorite.length} Likes',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
