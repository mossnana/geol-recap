import 'dart:convert';
import 'package:crypto/crypto.dart' as cryto;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/models/delegate.dart';
import 'package:geol_recap/screens/user_profile_screen.dart';
import 'package:geol_recap/widgets/editor/map_anchor.dart';
import 'package:geol_recap/widgets/loading_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:flare_flutter/flare_actor.dart';

class NewPostFragment extends StatefulWidget {
  final User userRepository;

  NewPostFragment({this.userRepository});

  @override
  State<StatefulWidget> createState() {
    return _NewPostFragment();
  }
}

class _NewPostFragment extends State<NewPostFragment> {
  ZefyrController _editorController;
  FocusNode _editorFocusNode;

  @override
  void initState() {
    super.initState();
    final document = PostDelegate.getEmptyNotusDocument();
    _editorController = ZefyrController(document);
    _editorFocusNode = FocusNode();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Do you want to exit ?',
          style: TextStyle(fontSize: 15),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            color: Colors.blue,
            child: Text(
              "No",
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(height: 16),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              "Yes",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  void dispose() {
    _editorController.document.close();
    _editorController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editorWidget = ZefyrEditor(
      padding: EdgeInsets.all(20.0),
      controller: _editorController,
      focusNode: _editorFocusNode,
      autofocus: false,
      physics: ClampingScrollPhysics(),
    );
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              child: Text(
                'New Story',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                final String content = jsonEncode(_editorController.document);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => NewPostFinalFragment(
                      userRepository: widget.userRepository,
                      content: content,
                    )
                  )
                );
              },
            )
          ],
        ),
        body: ZefyrScaffold(
          child: editorWidget,
        )
      ),
    );
  }
}

class NewPostFinalFragment extends StatefulWidget {
  final User userRepository;
  String content;
  NewPostFinalFragment({this.userRepository, this.content});
  @override
  State<StatefulWidget> createState() {
    return _NewPostFinalFragment();
  }
}

class _NewPostFinalFragment extends State<NewPostFinalFragment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading;
  Post _post;

  @override
  void initState() {
    super.initState();
    loading = false;
    _post = Post.init();
  }

  Future _pickImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 10)
        .then((selectedImage) {
      setState(() {
        _post.imageFiles.add(selectedImage);
      });
    });
  }

  Future<void> _newPost() async {
    _post.imageUrls = await PostDelegate.imagesUploader(
      post: _post,
      user: widget.userRepository,
    );
    var documentID = await PostDelegate.createNewPost(
        post: _post,
        user: widget.userRepository,
        content: widget.content
    );
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Posted Document : $documentID'),
        backgroundColor: Colors.blueAccent,
        onVisible: () {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final fromWidget = Column(
      children: <Widget>[
        Container(
          child: Text(
            'Upload your image',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Row(
                children: _post.imageFiles.asMap().entries.map<Widget>((image) {
                  return Stack(
                    children: <Widget>[
                      Image.file(
                        image.value,
                        height: screenSize.height * 0.114,
                        width: screenSize.width * 0.243,
                        fit: BoxFit.fitHeight,
                      ),
                      Container(
                        height: screenSize.height * 0.114,
                        width: screenSize.width * 0.243,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _post.imageFiles.removeAt(image.key);
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }).toList()),
            _post.imageFiles.length < 3
                ? GestureDetector(
              onTap: _pickImage,
              child: Container(
                  width: screenSize.width * 0.243,
                  height: screenSize.height * 0.114,
                  color: Colors.black12,
                  child: Center(
                    child: Icon(Icons.add),
                  )),
            )
                : Container(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        // Title
        Container(
          child: Text(
            'Title',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _post.title = value;
            });
          },
        ),
        SizedBox(
          height: 10,
        ),
        // Sub title
        Container(
          child: Text(
            'Sub-title',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _post.subTitle = value;
            });
          },
        ),
        SizedBox(
          height: 10,
        ),
        // Category
        Container(
          child: Text(
            'Category',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        // Mining
        Row(
          children: <Widget>[
            FlatButton(
              child: Container(
                width: screenSize.width * 0.631,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Image.asset(
                      'assets/images/editor/mining.png',
                      width: 20,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Mining & Engineering Geology',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              color: _post.category.id == 4 ? _post.category.color : Colors.grey,
              onPressed: () {
                setState(() {
                  _post.category.id = 4;
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        // Environment
        Row(
          children: <Widget>[
            FlatButton(
              child: Container(
                width: screenSize.width * 0.631,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Image.asset(
                      'assets/images/editor/environment.png',
                      width: 20,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Hydrology & Environmental Geology',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              color:
              _post.category.id == 2 ? _post.category.color : Colors.grey,
              onPressed: () {
                setState(() {
                  _post.category.id = 2;
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        // Petroleum
        Row(
          children: <Widget>[
            FlatButton(
              child: Container(
                width: screenSize.width * 0.631,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Image.asset(
                      'assets/images/editor/petroleum.png',
                      width: 20,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Petroleum & Sedimentary Geology',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              color: _post.category.id == 3 ? _post.category.color : Colors.grey,
              onPressed: () {
                setState(() {
                  _post.category.id = 3;
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        // Morphology
        Row(
          children: <Widget>[
            FlatButton(
              child: Container(
                width: screenSize.width * 0.631,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Image.asset(
                      'assets/images/editor/morphology.png',
                      width: 20,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Morphology & Structural Geology',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              color: _post.category.id == 1 ? _post.category.color : Colors.grey,
              onPressed: () {
                setState(() {
                  _post.category.id = 1;
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        // Other
        Row(
          children: <Widget>[
            FlatButton(
              child: Container(
                width: screenSize.width * 0.631,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Image.asset(
                      'assets/images/editor/others.png',
                      width: 20,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Other',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              color: _post.category.id == 0 ? _post.category.color : Colors.grey,
              onPressed: () {
                setState(() {
                  _post.category.id = 0;
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        // Location
        Container(
          child: Text(
            'Location',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Container(
              height: 50.0,
              child: RaisedButton(
                onPressed: () async {
                  final CameraPosition position =
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MapAnchor()),
                  );
                  setState(() {
                    _post.position = position;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    constraints:
                    BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Check in",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            _post.position != null
                ? Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.cyan),
              child: Text(
                ''
                    '${_post.position.target.latitude.toStringAsFixed(3)}, '
                    '${_post.position.target.longitude.toStringAsFixed(3)}',
                style: TextStyle(color: Colors.white),
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            )
                : Container(),
            _post.position != null
                ? IconButton(
              color: Colors.red,
              onPressed: () {
                setState(() {
                  _post.position = null;
                });
              },
              icon: Icon(Icons.close),
            )
                : Container(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
    if(loading) {
      return Scaffold(
        body: LoadingWidget(),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            child: Text(
              'New Story',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            onPressed: _newPost,
          )
        ],
      ),
      body: Container(
        height: screenSize.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: fromWidget
          ),
        ),
      ),
    );
  }
}

class ViewPostFragment extends StatefulWidget {
  String postId;
  User userRepository;

  ViewPostFragment({this.postId, this.userRepository});

  @override
  State<StatefulWidget> createState() {
    return _ViewPostFragment();
  }
}

class _ViewPostFragment extends State<ViewPostFragment> {
  ZefyrController _editorController = ZefyrController(NotusDocument());
  NotusDocument _content = NotusDocument();
  FocusNode _editorFocusNode = FocusNode();
  Post _post;
  @override
  void initState() {
    super.initState();
    final initDocument = Delta()..insert('\n');
    _content = NotusDocument.fromDelta(initDocument);
    _editorController = ZefyrController(_content);
    _loadDocument(widget.postId);
  }

  @override
  void dispose() {
    _editorController.document.close();
    super.dispose();
  }

  Future<void> _loadDocument(String postId) async {
    await Future.delayed(Duration(seconds: 3));
    await Firestore.instance
        .collection("posts")
        .document(widget.postId)
        .get()
        .then((value) {
      setState(() {
        _post = Post.fromJson(value.documentID, value.data);
        _content = NotusDocument.fromJson(jsonDecode(_post.content));
        _editorController = ZefyrController(_content);
      });
    });
  }

  Future<void> onFavorite() async {
    _post.uidFavorite.add(widget.userRepository.uid);
    await Firestore.instance
        .collection("posts")
        .document(widget.postId)
        .updateData({
          'uidFavorite': _post.uidFavorite
        });
    setState(() {});
  }

  Future<void> onUnfavorite() async {
    _post.uidFavorite.remove(widget.userRepository.uid);
    await Firestore.instance
        .collection("posts")
        .document(widget.postId)
        .updateData({
      'uidFavorite': _post.uidFavorite
    });
    setState(() {});
  }

  Widget categoryWidget(PostCategory category) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: category.color,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Text(
            '${category.toString()}',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final editorWidget = ZefyrEditor(
      controller: _editorController,
      focusNode: _editorFocusNode,
      autofocus: false,
      physics: ClampingScrollPhysics(),
      mode: ZefyrMode.view,
    );
    if (_post != null) {
      return SafeArea(
        child: Scaffold(
          body: ZefyrScaffold(
            child: Container(
              color: Color(0xFFF6FCFE),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // AppBar
                    Container(
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.lightBlue,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Text(
                            'Geol Recap',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2F68A0)),
                          ),
                          // Like
                          _post.isFavorited(widget.userRepository.uid) ?
                          // Like
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Color(0xFF399DC6),
                            ),
                            onPressed: onUnfavorite,
                          ) :
                          // Unlike
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Color(0xFF399DC6),
                            ),
                            onPressed: onFavorite,
                          )
                        ],
                      ),
                    ),
                    // Image Carousel Slider
                    CarouselSlider(
                      height: 270.0,
                      enableInfiniteScroll: false,
                      viewportFraction: 1.0,
                      aspectRatio: MediaQuery.of(context).size.aspectRatio,
                      items: _post.imageUrls.map<Widget>((url) {
                        return Builder(builder: (BuildContext context) {
                          return Container(
                              child: Image.network(
                            '$url',
                            fit: BoxFit.fitHeight,
                          ));
                        });
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Header Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        FutureBuilder(
                          future: _post.createdByProfileUrl,
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.done) {
                              if(snapshot.hasData) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UserProfileScreen(uid: _post.createdBy, userRepository: widget.userRepository,)
                                      )
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage('${snapshot.data}'),
                                  ),
                                );
                              } else {
                                return CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.red,
                                );
                              }
                            } else {
                              return CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.white,
                              );
                            }
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: screenSize.width * 0.802,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${_post.title}',
                                style: TextStyle(
                                    color: Color(0xFF2F68A0),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Sub Header Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 80,
                        ),
                        Container(
                          width: screenSize.width * 0.802,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${_post.subTitle}',
                                style: TextStyle(
                                  color: Color(0xFF6EBBDC),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 80,
                        ),
                      ],
                    ),
                    categoryWidget(_post.category),
                    SizedBox(
                      height: 20,
                    ),
                    // Content
                    Container(
                      height: screenSize.height * 0.57,
                      child: editorWidget
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          body: LoadingWidget()
        ),
      );
    }
  }
}
