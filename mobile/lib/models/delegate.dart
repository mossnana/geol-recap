import 'dart:convert';
import 'package:crypto/crypto.dart' as Cryto;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/widgets/editor/editor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';

class Validator {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return true;
  }
}

class PostDelegate {
  // Position Converter
  static CameraPosition toCameraPosition(GeoPoint geoPoint) =>
      CameraPosition(target: LatLng(geoPoint.latitude, geoPoint.longitude));

  // Read APIs
  static Future<List<Post>> getAllPostsByFuture() async {
    QuerySnapshot snapshotPosts =
        await Firestore.instance.collection('posts').getDocuments();
    List<Post> objectPosts = snapshotPosts.documents.map<Post>((post) {
      return Post.fromJson(post.documentID, post.data);
    }).toList();
    return objectPosts;
  }

  static Future<Post> getALatestPostByFuture() async {
    QuerySnapshot snapshotPost = await Firestore.instance
        .collection('posts')
        .orderBy('createdDate', descending: true)
        .limit(1)
        .getDocuments();
    Post objectPost = snapshotPost.documents
        .map<Post>((post) {
          return Post.fromJson(post.documentID, post.data);
        })
        .toList()
        .first;
    return objectPost;
  }

  static Future<List<Post>> getLatestPostsByFuture({int limit}) async {
    QuerySnapshot snapshotPosts = await Firestore.instance
        .collection('posts')
        .orderBy('createdDate', descending: true)
        .limit(limit | 1)
        .getDocuments();
    List<Post> objectPosts = snapshotPosts.documents.map<Post>((post) {
      return Post.fromJson(post.documentID, post.data);
    }).toList();
    return objectPosts;
  }

  static Future<Post> getAPopularPostByFuture() async {
    QuerySnapshot snapshotPost = await Firestore.instance
        .collection('posts')
        .orderBy('uidFavorite', descending: false)
        .limit(1)
        .getDocuments();
    Post objectPost = snapshotPost.documents
        .map<Post>((post) {
          return Post.fromJson(post.documentID, post.data);
        })
        .toList()
        .first;
    return objectPost;
  }

  static Future<List<Post>> getPopularPostsByFuture({int limit}) async {
    QuerySnapshot snapshotPosts = await Firestore.instance
        .collection('posts')
        .orderBy('uidFavorite', descending: false)
        .limit(limit | 1)
        .getDocuments();
    List<Post> objectPosts = snapshotPosts.documents.map<Post>((post) {
      return Post.fromJson(post.documentID, post.data);
    }).toList();
    return objectPosts;
  }

  static Future<List<Post>> getUserPostsFromUidByStream({String uid}) async {
    QuerySnapshot snapshotPosts = await Firestore.instance
        .collection('posts')
        .where('createdBy', isEqualTo: uid)
        .orderBy('uidFavorite', descending: true)
        .getDocuments();
    List<Post> objectPosts = snapshotPosts.documents.map<Post>((post) {
      return Post.fromJson(post.documentID, post.data);
    }).toList();
    return objectPosts;
  }

  static Stream<QuerySnapshot> getAllPostsByStream() {
    return Firestore.instance.collection('posts').snapshots();
  }

  static Stream<QuerySnapshot> getLatestPostsByStream({int limit}) {
    if (limit != null) {
      return Firestore.instance
          .collection('posts')
          .orderBy('createdDate', descending: true)
          .limit(limit)
          .snapshots();
    }
    return Firestore.instance
        .collection('posts')
        .orderBy('createdDate', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getPopularPostsByStream({int limit}) {
    if (limit != null) {
      return Firestore.instance
          .collection('posts')
          .orderBy('uidFavorite', descending: false)
          .limit(limit)
          .snapshots();
    }
    return Firestore.instance
        .collection('posts')
        .orderBy('uidFavorite', descending: false)
        .snapshots();
  }

  static Stream<QuerySnapshot> getUserPostsByStream({String uid}) {
    return Firestore.instance
        .collection('posts')
        .where('createdBy', isEqualTo: uid)
        .orderBy('createdBy', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getMiningPostsByStream({int limit}) {
    if (limit != null) {
      return Firestore.instance
          .collection('posts')
          .where('category', isEqualTo: 4)
          .orderBy('createdDate', descending: true)
          .limit(limit)
          .snapshots();
    }
    return Firestore.instance
        .collection('posts')
        .where('category', isEqualTo: 4)
        .orderBy('createdDate', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getEnvironmentPostsByStream({int limit}) {
    if (limit != null) {
      return Firestore.instance
          .collection('posts')
          .where('category', isEqualTo: 2)
          .orderBy('createdDate', descending: true)
          .limit(limit)
          .snapshots();
    }
    return Firestore.instance
        .collection('posts')
        .where('category', isEqualTo: 2)
        .orderBy('createdDate', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getPetroleumPostsByStream({int limit}) {
    if (limit != null) {
      return Firestore.instance
          .collection('posts')
          .where('category', isEqualTo: 3)
          .orderBy('createdDate', descending: true)
          .limit(limit)
          .snapshots();
    }
    return Firestore.instance
        .collection('posts')
        .where('category', isEqualTo: 3)
        .orderBy('createdDate', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getMorphologyPostsByStream({int limit}) {
    if (limit != null) {
      return Firestore.instance
          .collection('posts')
          .where('category', isEqualTo: 1)
          .orderBy('createdDate', descending: true)
          .limit(limit)
          .snapshots();
    }
    return Firestore.instance
        .collection('posts')
        .where('category', isEqualTo: 1)
        .orderBy('createdDate', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getOtherPostsByStream({int limit}) {
    if (limit != null) {
      return Firestore.instance
          .collection('posts')
          .where('category', isEqualTo: 0)
          .orderBy('createdDate', descending: true)
          .limit(limit)
          .snapshots();
    }
    return Firestore.instance
        .collection('posts')
        .where('category', isEqualTo: 0)
        .orderBy('createdDate', descending: true)
        .snapshots();
  }

  static bool isFavoriteFromUid({Post post, String uid}) {
    return post.uidFavorite.contains(uid);
  }

  static bool isFavoriteFromUser({Post post, User user}) {
    return post.uidFavorite.contains(user.uid);
  }

  static NotusDocument getEmptyNotusDocument() {
    final Delta delta = Delta()..insert(" \n");
    return NotusDocument.fromDelta(delta);
  }

  // Create APIs
  static Future<List<dynamic>> imagesUploader({Post post, User user}) async {
    List<String> imageUrls = [];
    for (var image in post.imageFiles) {
      // Encode with User uid and upload date
      var imagePathKey = utf8.encode(user.uid);
      var imagePathValue =
          utf8.encode('${DateTime.now().millisecondsSinceEpoch}');
      var imagePathHead = new Cryto.Hmac(Cryto.sha256, imagePathKey);
      var digest = imagePathHead.convert(imagePathValue);
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('posts/$digest');
      StorageUploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.onComplete;
      await storageReference.getDownloadURL().then((fileURL) {
        imageUrls.add(fileURL);
      });
    }
    return imageUrls;
  }

  static Future<String> createNewPost(
      {Post post, User user, String content}) async {
    var imageUrls = await PostDelegate.imagesUploader(post: post, user: user);
    String encodedContent = jsonEncode(content);
    var recentDocument = await Firestore.instance.collection('posts').add({
      'title': post.title,
      'subTitle': post.subTitle,
      'content': jsonDecode(encodedContent),
      'createdDate': new DateTime.now(),
      'createdBy': user.uid,
      'position': GeoPoint(
          post.position.target.latitude, post.position.target.longitude),
      'uidFavorite': [],
      'imageUrls': imageUrls,
      'category': post.category.id
    });
    return recentDocument.documentID;
  }

  static Future<void> favoritePost(String fromUid, Post toPost) async {
    toPost.uidFavorite.add(fromUid);
    await Firestore.instance
        .collection("posts")
        .document(toPost.id)
        .updateData({'uidFavorite': toPost});
  }
}

class NotificationDelegate {
  static Future<List<DocumentSnapshot>> getNotificationsFromUid(
      {String uid}) async {
    QuerySnapshot snapshotPost = await Firestore.instance
        .collection('notifications')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    return snapshotPost.documents;
  }
}

class UserDelegate {
  static Future<User> getUserFromUid({String uid}) async {
    DocumentSnapshot jsonUser =
        await Firestore.instance.collection('users').document(uid).get();
    User objectUser = User.fromJson(jsonUser.documentID, jsonUser.data);
    return objectUser;
  }

  static Future<String> getUserProfileFromUid({String uid}) async {
    User user = await UserDelegate.getUserFromUid(uid: uid);
    return user.profileUrl;
  }

  static Future<Map<String, dynamic>> getUserStatisticFromUser(
      {User user}) async {
    Map<String, dynamic> userStatistic = {
      'posts': 0,
      'likes': 0,
      'followers': 0,
    };
    List<Post> posts = await Firestore.instance
        .collection('posts')
        .where('createdBy', isEqualTo: user.uid)
        .getDocuments()
        .then((snapshot) {
      return snapshot.documents
          .map((document) => Post.fromJson(document.documentID, document.data))
          .toList();
    });
    userStatistic['posts'] = posts.length;
    userStatistic['likes'] = posts.fold(0, (previous, current) {
      return previous + current.uidFavorite.length;
    });
    userStatistic['followers'] = user.followers.length;
    print(userStatistic);
    return userStatistic;
  }

  static bool isFollowedFromUser({User fromUser, User toUser}) {
    return toUser.followers.contains(fromUser.uid);
  }

  static Future<bool> followUserFromUid({String fromUid, String toUid}) async {
    try {
      User myUser = await UserDelegate.getUserFromUid(uid: fromUid);
      User followUser = await UserDelegate.getUserFromUid(uid: toUid);
      myUser.followings.add(toUid);
      followUser.followers.add(fromUid);
      await Firestore.instance
          .collection('users')
          .document(fromUid)
          .setData({'followings': myUser.followings}, merge: true);
      await Firestore.instance
          .collection('users')
          .document(toUid)
          .setData({'followers': followUser.followers}, merge: true);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> unFollowUserFromUid(
      {String fromUid, String toUid}) async {
    try {
      User myUser = await UserDelegate.getUserFromUid(uid: fromUid);
      User followUser = await UserDelegate.getUserFromUid(uid: toUid);
      myUser.followings.remove(toUid);
      followUser.followers.remove(fromUid);
      await Firestore.instance
          .collection('users')
          .document(fromUid)
          .setData({'followings': myUser.followings}, merge: true);
      await Firestore.instance
          .collection('users')
          .document(toUid)
          .setData({'followers': followUser.followers}, merge: true);
      return true;
    } catch (_) {
      return false;
    }
  }
}

class MapDelegate {
  static Future<Set<Marker>> getAllPostPosition(
      {BuildContext context, User user}) async {
    List<Post> posts = await PostDelegate.getAllPostsByFuture();
    Set<Marker> markers = posts
        .map<Marker>((post) => Marker(
            markerId: MarkerId(post.id),
            position: post.position.target,
            infoWindow: InfoWindow(title: post.title, snippet: post.subTitle),
            consumeTapEvents: false,
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ViewPostFragment(
                        postId: post.id,
                        userRepository: user,
                      )));
            }))
        .toSet();
    return markers;
  }
}

class DateTimeDelegate {
  static String toHumanString(DateTime date) {
    DateTime currentDateTime = DateTime.now();
    Duration diff = currentDateTime.difference(date);
    if (diff.inSeconds < 59) {
      return 'A minute ago';
    }
    if (diff.inMinutes < 59) {
      return '${diff.inMinutes} minute ago';
    }
    if (diff.inHours < 3) {
      return 'A few hours ago';
    }
    if (diff.inDays < 1) {
      return 'A day ago';
    }
    if (diff.inDays < 365) {
      String formattedDate =
          '${date.day} ${toMonthString(date.month)}, ${date.hour}:${toMinuteString(date.minute)}';
      return '$formattedDate';
    }
    String formattedDate =
        '${date.day} ${toMonthString(date.month)} ${date.year}, ${date.hour}:${toMinuteString(date.minute)}';
    return '$formattedDate';
  }

  static String toMinuteString(int number) {
    if (number == null) {
      return '00';
    }
    if (number < 11) {
      return '${number}0';
    }
    return '$number';
  }

  static String toMonthString(int number) {
    switch (number) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Jan';
    }
  }
}
