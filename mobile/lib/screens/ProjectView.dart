import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolrecap/helpers/DatabaseDelegate.dart';
import 'package:geolrecap/screens/CheckPointView.dart';
import 'package:geolrecap/screens/NotesView.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_porter/utils/csv_utils.dart';
import 'package:utm/utm.dart';

class ProjectListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProjectListView();
  }
}

class _ProjectListView extends State<ProjectListView> {
  Future<List<Map>> _getProjects() async {
    List<Map> projects = await TableProjectDelegate.get();
    return projects;
  }

  TextEditingController _projectCode = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getProjects(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List<Map> projects = snapshot.data;
            if (projects.length == 0)
              return Center(
                child: Text('Click + to add new project'),
              );
            return ListView.builder(
              itemBuilder: (context, index) {
                Map project = projects[index];
                return Slidable(
                  actionExtentRatio: 0.15,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Export',
                      color: Colors.blueAccent,
                      icon: Icons.info,
                      foregroundColor: Colors.white,
                      onTap: () async {
                        var result = await showDialog(
                          context: context,
                          child: Container(
                              width: 200,
                              height: 200,
                              child: SimpleDialog(
                                contentPadding: EdgeInsets.all(20),
                                title: Text("Project Information"),
                                children: <Widget>[
                                  Text('Project Code'),
                                  TextFormField(
                                    initialValue: project['code'],
                                    readOnly: true,
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Export',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.blueAccent,
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.red,
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                ],
                              )),
                        );
                        print(_projectCode.text);
                        bool exportResult =
                            await TableProjectDelegate.exportToWeb(
                                projectId: project['id'],
                                projectCode: project['code']);
                        print(exportResult);
                      },
                    ),
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.amber,
                      icon: Icons.mode_edit,
                      foregroundColor: Colors.white,
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditProjectView(
                                  project: project,
                                )));
                      },
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      foregroundColor: Colors.white,
                      onTap: () async {
                        await TableProjectDelegate.delete(id: project['id']);
                        setState(() {});
                      },
                    ),
                  ],
                  actionPane: SlidableBehindActionPane(),
                  child: ListTile(
                    title: Text(
                      '${project['name']}',
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text('${project['location']}'),
                    trailing: Text(
                        '${DateTime.fromMillisecondsSinceEpoch(project['createdDate']).toAppDate()}'),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ProjectView(
                            project: project,
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                    },
                  ),
                );
              },
              itemCount: projects.length,
            );
            break;
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}

class ProjectView extends StatefulWidget {
  Map project = {};

  ProjectView({this.project});

  @override
  State<StatefulWidget> createState() {
    return _ProjectView();
  }
}

class _ProjectView extends State<ProjectView> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.project['name']}'),
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
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewCheckPointView(
                        project: widget.project,
                      )));
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProjectViewHeader(),
              Container(
                height:
                    (screenSize.height - AppBar().preferredSize.height) * 0.85,
                child: ProjectViewCheckpointList(
                  project: widget.project,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectViewHeader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProjectViewHeader();
  }
}

class _ProjectViewHeader extends State<ProjectViewHeader> {
  String _north = '00000000.000';
  String _east = '0000000.000';

  void _getPosition() async {
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
      _north = '${utm.northing.toStringAsFixed(3)}';
      _east = '${utm.easting.toStringAsFixed(3)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: 'North ',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: '${_north}',
                      style: TextStyle(color: Colors.redAccent)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'East ',
                style: TextStyle(
                    color: Colors.indigoAccent, fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: '$_east',
                      style: TextStyle(color: Colors.indigoAccent)),
                ],
              ),
            ),
          ],
        ),
        leading: Icon(Icons.pin_drop),
        trailing: FlatButton(
          onPressed: _getPosition,
          child: Text('Get Position'),
        ),
      ),
    );
  }
}

class ProjectViewCheckpointList extends StatefulWidget {
  final Map project;

  ProjectViewCheckpointList({this.project});

  @override
  State<StatefulWidget> createState() {
    return _ProjectViewCheckpointList();
  }
}

class _ProjectViewCheckpointList extends State<ProjectViewCheckpointList> {
  @override
  Widget build(BuildContext context) {
    Widget checkpointListView(List data) => ListView.builder(
          itemBuilder: (context, index) {
            return Slidable(
              actionExtentRatio: 0.15,
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Edit',
                  color: Colors.amber,
                  icon: Icons.mode_edit,
                  foregroundColor: Colors.white,
                  onTap: () async {
                    Map checkpointWithImages =
                        await TableCheckPointDelegate.getWithImages(
                            checkpointId: data[index]['id']);
                    print(checkpointWithImages);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditCheckPointView(
                              checkpoint: checkpointWithImages,
                            )));
                  },
                ),
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  foregroundColor: Colors.white,
                  onTap: () async {
                    int totalRowsDeleted =
                        await TableCheckPointDelegate.delete(data[index]['id']);
                    setState(() {});
                    print(totalRowsDeleted);
                  },
                ),
              ],
              actionPane: SlidableBehindActionPane(),
              child: Card(
                elevation: 0,
                child: ListTile(
                  title: Text(data[index]['name']),
                  subtitle: Text(
                      '${data[index]['zone']} ${data[index]['north']} ${data[index]['east']}'),
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            CheckPointView(
                          checkpoint: data[index],
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
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
                  },
                ),
              ),
            );
          },
          itemCount: data.length,
        );
    return FutureBuilder(
      future: TableCheckPointDelegate.get(projectId: widget.project['id']),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Text('Loading ...'),
            );
          default:
            if (snapshot.data.length != 0) {
              return checkpointListView(snapshot.data);
            } else {
              return Center(
                child: Text('Click + to add new checkpoint'),
              );
            }
        }
      },
    );
  }
}

class NewProjectView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewProjectView();
  }
}

class _NewProjectView extends State<NewProjectView> {
  GlobalKey _scaffoldKey = GlobalKey();
  TextEditingController _name;
  TextEditingController _location;
  TextEditingController _description;
  TextEditingController _code;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _location = TextEditingController();
    _description = TextEditingController();
    _code = TextEditingController();
  }

  _save() async {
    int projectId = await TableProjectDelegate.save(
      name: _name.text,
      location: _location.text,
      desc: _description.text,
      code: _code.text,
    );
    print('Created project id $projectId');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Project'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Create',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _save,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Project Name',
                style: Theme.of(context).textTheme.display1,
              ),
              TextField(
                controller: _name,
              ),
              SizedBox(
                height: 15,
              ),
              Text('Project Location',
                  style: Theme.of(context).textTheme.display1),
              TextField(
                controller: _location,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Project Description',
                style: Theme.of(context).textTheme.display1,
              ),
              TextField(
                controller: _description,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Project Code',
                style: Theme.of(context).textTheme.display1,
              ),
              TextField(
                controller: _code,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProjectView extends StatefulWidget {
  Map project;

  EditProjectView({this.project});

  @override
  State<StatefulWidget> createState() {
    return _EditProjectView();
  }
}

class _EditProjectView extends State<EditProjectView> {
  GlobalKey _scaffoldKey = GlobalKey();
  TextEditingController _name;
  TextEditingController _location;
  TextEditingController _description;
  TextEditingController _code;

  _save() async {
    int projectId = await TableProjectDelegate.edit(
        projectId: widget.project['id'],
        name: _name.text,
        location: _location.text,
        desc: _description.text,
        code: _code.text);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.project['name']);
    _location = TextEditingController(text: widget.project['location']);
    _description = TextEditingController(text: widget.project['description']);
    _code = TextEditingController(text: widget.project['code']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Project'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Edit',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _save,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Project Name',
                style: Theme.of(context).textTheme.display1,
              ),
              TextField(
                controller: _name,
              ),
              SizedBox(
                height: 15,
              ),
              Text('Project Location',
                  style: Theme.of(context).textTheme.display1),
              TextField(
                controller: _location,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Project Description',
                style: Theme.of(context).textTheme.display1,
              ),
              TextField(
                controller: _description,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Project Code',
                style: Theme.of(context).textTheme.display1,
              ),
              TextField(
                controller: _code,
              ),
            ],
          ),
        ),
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
