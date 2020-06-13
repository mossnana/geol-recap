import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolrecap/helpers/DatabaseDelegate.dart';
import 'package:geolrecap/screens/FeatureView.dart';
import 'package:geolrecap/screens/NotesView.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:utm/utm.dart';

class CheckPointView extends StatefulWidget {
  Map checkpoint;

  CheckPointView({this.checkpoint});

  @override
  State<CheckPointView> createState() {
    return _CheckPointView();
  }
}

class _CheckPointView extends State<CheckPointView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.checkpoint['name']),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteListWithScaffoldView()));
            },
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => NewCheckPointDataView(
                          checkpointId: widget.checkpoint['id'],
                        )),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: TableFeatureDelegate.get(widget.checkpoint['id']),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Text('Loading ...'),
              );
            default:
              if (snapshot.hasData) {
                if (snapshot.data.length != 0) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index]['name']),
                        subtitle: Text(
                            '${TableFeatureDelegate.typeToString(snapshot.data[index]['type'])}'),
                        trailing: Text(
                            '${DateTime.fromMillisecondsSinceEpoch(snapshot.data[index]['date']).toAppDate()}'),
                        onTap: () {
                          if (snapshot.data[index]['type'] == 'sedimentary') {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        SedimentaryRockView(
                                  featureId: snapshot.data[index]['featureId'],
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var curve = Curves.ease;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.data[index]['type'] ==
                              'igneous') {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        IgneousRockView(
                                  featureId: snapshot.data[index]['featureId'],
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var curve = Curves.ease;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.data[index]['type'] ==
                              'metamorphic') {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        MetamorphicRockView(
                                  featureId: snapshot.data[index]['featureId'],
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var curve = Curves.ease;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        StructureView(
                                  featureId: snapshot.data[index]['featureId'],
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var curve = Curves.ease;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          }
                        },
                      );
                    },
                    itemCount: snapshot.data.length,
                  );
                } else {
                  return Center(
                    child: Text('Click + to add new feature'),
                  );
                }
              } else {
                return Center(
                  child: Text('Click + to add new feature'),
                );
              }
          }
        },
      ),
    );
  }
}

class NewCheckPointView extends StatefulWidget {
  Map project;

  NewCheckPointView({this.project});

  @override
  State<StatefulWidget> createState() {
    return _NewCheckPointView();
  }
}

class _NewCheckPointView extends State<NewCheckPointView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _name;
  TextEditingController _landmark;
  TextEditingController _height;
  TextEditingController _width;
  TextEditingController _desc;
  TextEditingController _latitude;
  TextEditingController _longitude;
  TextEditingController _zone;
  TextEditingController _elevation;
  TextEditingController _north;
  TextEditingController _east;
  List<File> images;
  final FocusNode _nameNode = FocusNode();
  final FocusNode _landmarkNode = FocusNode();
  final FocusNode _heightNode = FocusNode();
  final FocusNode _widthNode = FocusNode();
  final FocusNode _descNode = FocusNode();
  final FocusNode _latitudeNode = FocusNode();
  final FocusNode _longitudeNode = FocusNode();
  final FocusNode _zoneNode = FocusNode();
  final FocusNode _elevationNode = FocusNode();
  final FocusNode _northNode = FocusNode();
  final FocusNode _eastNode = FocusNode();

  void _getPosition() async {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Getting a position'),
      ),
    );
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationData = await location.getLocation();
    var utm =
        UTM.fromLatLon(lat: locationData.latitude, lon: locationData.longitude);
    setState(() {
      _latitude.text = '${locationData.latitude}';
      _longitude.text = '${locationData.longitude}';
      _zone.text = '${utm.zone}';
      _north.text = '${utm.northing.toStringAsFixed(2)}';
      _east.text = '${utm.easting.toStringAsFixed(2)}';
    });
  }

  Future<bool> _exitScreen(BuildContext context) {
    return showDialog(
          context: context,
          child: AlertDialog(
            title: Text('คุณต้องการจะออกหรือไม่ ?'),
            content: Text('ข้อมูลของคุณจะไม่ถูกบันทึก'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'ออก',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                color: Colors.purpleAccent,
                child: Text(
                  'ไม่ออก',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _save() async {
    Map json = {
      'projectId': widget.project['id'],
      'name': _name.text,
      'landmark': _landmark.text,
      'description': _desc.text,
      'height': double.parse(_height.text),
      'width': double.parse(_width.text),
      'latitude': double.parse(_latitude.text),
      'longitude': double.parse(_longitude.text),
      'zone': _zone.text,
      'north': double.parse(_north.text),
      'east': double.parse(_east.text),
      'elevation':
          _elevation.text != null ? double.parse(_elevation.text) : 0.0,
      'images': images
    };
    await TableCheckPointDelegate.save(json);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _landmark = TextEditingController();
    _desc = TextEditingController();
    _height = TextEditingController();
    _width = TextEditingController();
    _latitude = TextEditingController();
    _longitude = TextEditingController();
    _zone = TextEditingController();
    _elevation = TextEditingController();
    _north = TextEditingController();
    _east = TextEditingController();
    images = [];
  }

  @override
  void dispose() {
    _nameNode.dispose();
    _landmarkNode.dispose();
    _heightNode.dispose();
    _widthNode.dispose();
    _descNode.dispose();
    _latitudeNode.dispose();
    _longitudeNode.dispose();
    _zoneNode.dispose();
    _elevationNode.dispose();
    _northNode.dispose();
    _eastNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitScreen(context),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('New Check Point'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Check point name
                Text(
                  'Name',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  focusNode: _nameNode,
                  onFieldSubmitted: (_) {
                    _nameNode.unfocus();
                    FocusScope.of(context).requestFocus(_landmarkNode);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Landmark
                Text(
                  'Landmark',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _landmark,
                  focusNode: _landmarkNode,
                  onFieldSubmitted: (_) {
                    _landmarkNode.unfocus();
                    FocusScope.of(context).requestFocus(_heightNode);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Height and Width
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Height',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _height,
                            focusNode: _heightNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (_) {
                              _heightNode.unfocus();
                              FocusScope.of(context).requestFocus(_widthNode);
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Width',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _width,
                            focusNode: _widthNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (_) {
                              _widthNode.unfocus();
                              FocusScope.of(context).requestFocus(_descNode);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // Outcrop Description
                Text(
                  'Outcrop Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _desc,
                  focusNode: _descNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Lat and Long
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Latitude',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _latitude,
                            focusNode: _latitudeNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _latitudeNode.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_longitudeNode);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Longtitude',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _longitude,
                            focusNode: _longitudeNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _longitudeNode.unfocus();
                              FocusScope.of(context).requestFocus(_zoneNode);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // Zone and Elevation
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Zone',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _zone,
                            focusNode: _zoneNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _zoneNode.unfocus();
                              FocusScope.of(context).requestFocus(_northNode);
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Elevation',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _elevation,
                            focusNode: _elevationNode,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // North and East
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'North',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _north,
                            focusNode: _northNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _northNode.unfocus();
                              FocusScope.of(context).requestFocus(_eastNode);
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'East',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _east,
                            focusNode: _eastNode,
                            textInputAction: TextInputAction.done,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // Get Position Button
                MaterialButton(
                  onPressed: _getPosition,
                  color: Colors.blueAccent,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Get Position',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Image
                MaterialButton(
                  onPressed: () async {
                    List<File> newImages =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NewImageView(
                                  files: images,
                                )));
                    if (newImages != null) {
                      setState(() {
                        images = newImages;
                      });
                    }
                  },
                  color: Colors.lightBlue,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Add Images',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Save Button
                MaterialButton(
                  onPressed: _save,
                  color: Colors.green,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Create',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditCheckPointView extends StatefulWidget {
  final Map checkpoint;

  EditCheckPointView({this.checkpoint});

  @override
  State<StatefulWidget> createState() {
    return _EditCheckPointView();
  }
}

class _EditCheckPointView extends State<EditCheckPointView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _name;
  TextEditingController _landmark;
  TextEditingController _height;
  TextEditingController _width;
  TextEditingController _desc;
  TextEditingController _latitude;
  TextEditingController _longitude;
  TextEditingController _zone;
  TextEditingController _elevation;
  TextEditingController _north;
  TextEditingController _east;
  List<File> images;
  final FocusNode _nameNode = FocusNode();
  final FocusNode _landmarkNode = FocusNode();
  final FocusNode _heightNode = FocusNode();
  final FocusNode _widthNode = FocusNode();
  final FocusNode _descNode = FocusNode();
  final FocusNode _latitudeNode = FocusNode();
  final FocusNode _longitudeNode = FocusNode();
  final FocusNode _zoneNode = FocusNode();
  final FocusNode _elevationNode = FocusNode();
  final FocusNode _northNode = FocusNode();
  final FocusNode _eastNode = FocusNode();

  void _getPosition() async {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Getting a position'),
      ),
    );
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationData = await location.getLocation();
    var utm =
        UTM.fromLatLon(lat: locationData.latitude, lon: locationData.longitude);
    setState(() {
      _latitude.text = '${locationData.latitude}';
      _longitude.text = '${locationData.longitude}';
      _zone.text = '${utm.zone}';
      _north.text = '${utm.northing.toStringAsFixed(2)}';
      _east.text = '${utm.easting.toStringAsFixed(2)}';
    });
  }

  Future<bool> _exitScreen(BuildContext context) {
    return showDialog(
          context: context,
          child: AlertDialog(
            title: Text('คุณต้องการจะออกหรือไม่ ?'),
            content: Text('ข้อมูลของคุณจะไม่ถูกบันทึก'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'ออก',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                color: Colors.purpleAccent,
                child: Text(
                  'ไม่ออก',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _save() async {
    print(widget.checkpoint['projectId']);
    Map json = {
      'projectId': widget.checkpoint['checkpoint']['projectId'],
      'checkpointId': widget.checkpoint['checkpoint']['id'],
      'name': _name.text,
      'landmark': _landmark.text,
      'description': _desc.text,
      'height': double.parse(_height.text),
      'width': double.parse(_width.text),
      'latitude': double.parse(_latitude.text),
      'longitude': double.parse(_longitude.text),
      'zone': _zone.text,
      'north': double.parse(_north.text),
      'east': double.parse(_east.text),
      'elevation':
          _elevation.text != null ? double.parse(_elevation.text) : 0.0,
      'images': images
    };
    int resultId = await TableCheckPointDelegate.edit(json);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _name =
        TextEditingController(text: widget.checkpoint['checkpoint']['name']);
    _landmark = TextEditingController(
        text: '${widget.checkpoint['checkpoint']['landmark']}');
    _height = TextEditingController(
        text: '${widget.checkpoint['checkpoint']['height']}');
    _width = TextEditingController(
        text: '${widget.checkpoint['checkpoint']['width']}');
    _desc = TextEditingController(
        text: '${widget.checkpoint['checkpoint']['description']}');
    _latitude = TextEditingController(
        text: '${widget.checkpoint['checkpoint']['latitude']}');
    _longitude = TextEditingController(
        text: '${widget.checkpoint['checkpoint']['longitude']}');
    _zone =
        TextEditingController(text: widget.checkpoint['checkpoint']['zone']);
    _elevation = TextEditingController(
        text: '${widget.checkpoint['checkpoint']['elevation']}');
    _north = TextEditingController(
        text: '${widget.checkpoint['checkpoint']['north']}');
    _east = TextEditingController(
        text: '${widget.checkpoint['checkpoint']['east']}');
    images = widget.checkpoint['images'].map<File>((e) => File(e)).toList();
  }

  @override
  void dispose() {
    _nameNode.dispose();
    _landmarkNode.dispose();
    _heightNode.dispose();
    _widthNode.dispose();
    _descNode.dispose();
    _latitudeNode.dispose();
    _longitudeNode.dispose();
    _zoneNode.dispose();
    _elevationNode.dispose();
    _northNode.dispose();
    _eastNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitScreen(context),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Edit Check Point'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Check point name
                Text(
                  'Name',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  focusNode: _nameNode,
                  onFieldSubmitted: (_) {
                    _nameNode.unfocus();
                    FocusScope.of(context).requestFocus(_landmarkNode);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Landmark
                Text(
                  'Landmark',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _landmark,
                  focusNode: _landmarkNode,
                  onFieldSubmitted: (_) {
                    _landmarkNode.unfocus();
                    FocusScope.of(context).requestFocus(_heightNode);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Height and Width
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Height',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _height,
                            focusNode: _heightNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (_) {
                              _heightNode.unfocus();
                              FocusScope.of(context).requestFocus(_widthNode);
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Width',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _width,
                            focusNode: _widthNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (_) {
                              _widthNode.unfocus();
                              FocusScope.of(context).requestFocus(_descNode);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // Outcrop Description
                Text(
                  'Outcrop Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _desc,
                  focusNode: _descNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Lat and Long
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Latitude',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _latitude,
                            focusNode: _latitudeNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _latitudeNode.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_longitudeNode);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Longtitude',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _longitude,
                            focusNode: _longitudeNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _longitudeNode.unfocus();
                              FocusScope.of(context).requestFocus(_zoneNode);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // Zone and Elevation
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Zone',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _zone,
                            focusNode: _zoneNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _zoneNode.unfocus();
                              FocusScope.of(context).requestFocus(_northNode);
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Elevation',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _elevation,
                            focusNode: _elevationNode,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // North and East
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'North',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _north,
                            focusNode: _northNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _northNode.unfocus();
                              FocusScope.of(context).requestFocus(_eastNode);
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'East',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _east,
                            focusNode: _eastNode,
                            textInputAction: TextInputAction.done,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // Get Position Button
                MaterialButton(
                  onPressed: _getPosition,
                  color: Colors.blueAccent,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Get Position',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Image
                MaterialButton(
                  onPressed: () async {
                    List<File> newImages = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewImageView(
                          files: images,
                        ),
                      ),
                    );
                    if (newImages != null) {
                      setState(() {
                        images = newImages;
                      });
                    }
                  },
                  color: Colors.lightBlue,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Edit Images',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Save Button
                MaterialButton(
                  onPressed: _save,
                  color: Colors.green,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewCheckPointDataView extends StatelessWidget {
  int checkpointId;

  NewCheckPointDataView({this.checkpointId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select feature type'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoteListWithScaffoldView(),
                ),
              );
            },
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Sedimentary Rock'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => NewSedimentaryRock(
                    checkpointId: checkpointId,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Igneous Rock'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => NewIgneousRock(
                    checkpointId: checkpointId,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Metamorphic Rock'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => NewMetamorphicRock(
                    checkpointId: checkpointId,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Geologic Structure'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => NewStructure(
                    checkpointId: checkpointId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

extension on DateTime {
  String toAppDate() {
    var formatter = DateFormat('d MMMM y HH:mm');
    return '${formatter.format(this)}';
  }
}
