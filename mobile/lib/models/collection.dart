import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geol_recap/models/delegate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Post {
  String id;
  String title;
  String subTitle;
  dynamic content;
  String createdBy;
  DateTime createdDate;
  CameraPosition position;
  List<dynamic> uidFavorite = [];
  List<dynamic> imageUrls = [];
  List<File> imageFiles = [];
  PostCategory category;

  Post({
    this.id,
    this.title,
    this.subTitle,
    this.content,
    this.createdDate,
    this.createdBy,
    this.position,
    this.uidFavorite,
    this.imageUrls,
    this.imageFiles,
    this.category,
  });

  String get toDateString => createdDate.toHumanString();

  Future<dynamic> get createdByProfileUrl async {
    dynamic profileUrl = await Firestore.instance
        .collection("users")
        .document(createdBy)
        .get()
        .then((value) {
      return value.data['profileUrl'];
    });
    return profileUrl;
  }

  factory Post.init() => Post(
        id: '000',
        title: 'Title',
        subTitle: 'Sub Title',
        content: '',
        createdDate: new DateTime.now(),
        createdBy: '000',
        imageUrls: [],
        imageFiles: [],
        category: PostCategory(id: 0),
      );

  factory Post.fromJson(String documentID, Map<String, dynamic> json) => Post(
      id: documentID,
      title: json['title'],
      subTitle: json['subTitle'],
      content: json['content'],
      createdDate: json['createdDate'].toDate(),
      createdBy: json['createdBy'],
      position: PostDelegate.toCameraPosition(json['position']),
      uidFavorite: json['uidFavorite'] != null ? json['uidFavorite'] : [],
      imageUrls: json['imageUrls'],
      category: PostCategory(
        id: json['category'],
      ));

  Future<String> saveToFirestore(
      {String uid, List<dynamic> uploadedImages, String content}) async {
    var recentDocument = await Firestore.instance.collection('posts').add({
      'title': title,
      'subTitle': subTitle,
      'content': jsonDecode(content),
      'createdDate': new DateTime.now(),
      'createdBy': uid,
      'position': GeoPoint(position.target.latitude, position.target.longitude),
      'uidFavorite': [],
      'imageUrls': uploadedImages,
      'category': category.id
    });
    return recentDocument.documentID;
  }

  bool isFavorited(String searchUid) {
    if (this.uidFavorite != null) {
      List<dynamic> searchResult = this.uidFavorite.where((dynamic uidInList) {
        return searchUid == uidInList;
      }).toList();
      if (searchResult.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    await _firebaseAuth.signInWithCredential(credential);
    await _saveUserDetail(_firebaseAuth.currentUser());
    return _firebaseAuth.currentUser();
  }

  Future<void> _saveUserDetail(Future<FirebaseUser> firebaseUser) async {
    FirebaseUser currentUser = await firebaseUser;
    if (currentUser.uid != null) {
      final searchedId = await Firestore.instance
          .collection('users')
          .document('${currentUser.uid}')
          .get();
      if (!searchedId.exists) {
        await Firestore.instance
            .collection('users')
            .document('${currentUser.uid}')
            .setData({
          'displayName': currentUser.displayName,
          'email': currentUser.email,
          'profileUrl': currentUser.photoUrl,
          'phoneNumber': currentUser.phoneNumber,
        });
      }
    }
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<User> getUser() async {
    final currentUser = await _firebaseAuth.currentUser();
    final currentUserObject =
        await UserDelegate.getUserFromUid(uid: currentUser.uid);
    return currentUserObject;
  }
}

class Profile {
  String uid;
  String displayName;
  String email;
  List<dynamic> followers;
  String phoneNumber;
  String profileUrl;

  Profile(
      {this.uid,
      this.displayName,
      this.email,
      this.followers,
      this.phoneNumber,
      this.profileUrl});

  factory Profile.fromJson(String documentID, Map<String, dynamic> json) =>
      Profile(
        uid: documentID,
        displayName: json['displayName'],
        email: json['email'],
        followers: json['followers'],
        phoneNumber: json['phoneNumber'],
        profileUrl: json['profileUrl'],
      );
}

class User {
  String uid;
  String displayName;
  String email;
  List<dynamic> followers;
  List<dynamic> followings;
  String phoneNumber;
  String profileUrl;
  bool isInit;

  User(
      {this.uid,
      this.displayName,
      this.email,
      this.followers,
      this.followings,
      this.phoneNumber,
      this.profileUrl,
      this.isInit});

  factory User.fromJson(String documentID, Map<String, dynamic> json) => User(
        uid: documentID,
        displayName: json['displayName'],
        email: json['email'],
        followers: json['followers'],
        followings: json['followings'],
        phoneNumber: json['phoneNumber'],
        profileUrl: json['profileUrl'],
        isInit: false,
      );

  factory User.init() => User(
        uid: '000',
        displayName: 'Newbie',
        email: 'newbie@geolrecap.com',
        followers: [],
        followings: [],
        phoneNumber: '0800000000',
        profileUrl: 'https://en.pimg.jp/013/438/888/1/13438888.jpg',
        isInit: true,
      );

  Map<String, dynamic> toJson() => {
        'displayName': this.displayName,
        'email': this.email,
        'followers': this.followers,
        'followings': this.followings,
        'phoneNumber': this.phoneNumber,
        'profileUrl': this.profileUrl
      };
}

class MyNotification {
  String uid;
  String message;
  DateTime createdTime;
  String ref;

  MyNotification({this.uid, this.message, this.createdTime, this.ref});

  factory MyNotification.fromJson(Map<String, dynamic> json) => MyNotification(
    uid: json['uid'],
    message: json['message'],
    createdTime: json['createdDate'].toDate(),
    ref: json['ref']
  );
}

class Dictionary extends Taggable {
  int id;
  String key;
  String value;
  String imageUrl;

  Dictionary({this.id, this.key, this.value, this.imageUrl});

  factory Dictionary.fromJson(Map<String, dynamic> json) => Dictionary(
      id: json['id'],
      key: json['key'],
      value: json['value'],
      imageUrl: json['image_url']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'key': key, 'value': value, 'imageUrl': imageUrl};

  @override
  List<Object> get props => null;
}

class PostCategory {
  int id;

  PostCategory({this.id});

  factory PostCategory.fromJson(String value) {
    switch (value) {
      case 'Morphology & Structural Geology':
        return PostCategory(id: 1);
      case 'Hydrology & Environmental Geology':
        return PostCategory(id: 2);
      case 'Petroleum & Sedimentary Geology':
        return PostCategory(id: 3);
      case 'Mining & Engineering Geology':
        return PostCategory(id: 4);
      default:
        return PostCategory(id: 0);
    }
  }

  Color get color {
    switch (this.id) {
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.lightBlueAccent;
      case 3:
        return Colors.purpleAccent;
      case 4:
        return Colors.amber;
      default:
        return Colors.teal;
    }
  }

  String toString() {
    switch (this.id) {
      case 1:
        return 'Morphology & Structural Geology';
      case 2:
        return 'Hydrology & Environmental Geology';
      case 3:
        return 'Petroleum & Sedimentary Geology';
      case 4:
        return 'Mining & Engineering Geology';
      default:
        return 'Others';
    }
  }
}

extension on DateTime {
  String toHumanString() {
    return DateTimeDelegate.toHumanString(this);
  }
}
