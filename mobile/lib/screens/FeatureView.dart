import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolrecap/helpers/DatabaseDelegate.dart';
import 'package:path/path.dart';
import 'package:geolrecap/screens/GeologicalDetail.dart';
import 'package:geolrecap/screens/NotesView.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import 'FeatureView2.dart';

class NewImageView extends StatefulWidget {
  List<File> files;

  NewImageView({this.files});

  @override
  State<NewImageView> createState() {
    return _NewImageView();
  }
}

class _NewImageView extends State<NewImageView> {
  List<File> _images;
  TextEditingController _renameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _images = widget.files;
  }

  @override
  Widget build(BuildContext context) {
    Future _getImage() async {
      var result = await showDialog(
          context: context,
          child: SimpleDialog(
            title: Text("Get Image From ?"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Camera"),
                onPressed: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              SimpleDialogOption(
                child: new Text("Gallery"),
                onPressed: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
            ],
          ));
      if (result != null) {
        var image = await ImagePicker.pickImage(source: result);
        setState(() {
          _images.add(image);
        });
      }
    }

    Future<File> moveFile(File sourceFile, String newPath) async {
      try {
        // prefer using rename as it is probably faster
        return await sourceFile.rename(newPath);
      } on FileSystemException catch (e) {
        // if rename fails, copy the source file and then delete it
        final newFile = await sourceFile.copy(newPath);
        await sourceFile.delete();
        return newFile;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(_images);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _getImage,
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Slidable(
              actionExtentRatio: 0.15,
              actionPane: SlidableBehindActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  foregroundColor: Colors.white,
                  onTap: () async {
                    setState(() {
                      _images.removeAt(index);
                    });
                  },
                ),
                /*IconSlideAction(
                  caption: 'Rename',
                  color: Colors.yellow,
                  icon: Icons.edit,
                  foregroundColor: Colors.white,
                  onTap: () async {
                    _renameController.text = basename(_images[index].path);
                    var newName = await showDialog<String>(
                      context: context,
                      child: AlertDialog(
                        contentPadding: const EdgeInsets.all(16.0),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                autofocus: true,
                                controller: _renameController,
                                decoration: InputDecoration(
                                  labelText: 'New Name',
                                ),
                              ),
                            )
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                              child: const Text('CANCEL'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          FlatButton(
                            child: const Text('RENAME'),
                            onPressed: () {
                              Navigator.pop(context, _renameController.text);
                            },
                          )
                        ],
                      ),
                    );
                    if(newName != null) {
                      File newFile = await moveFile(_images[index], '${_images[index].parent.path}/${_renameController.text}');
                      setState(() {
                        _images[index] = newFile;
                      });
                    }
                  },
                ),*/
              ],
              child: ListTile(
                title: Text(basename(_images[index].path)),
                leading: Image(
                  image: FileImage(
                    _images[index],
                  ),
                  filterQuality: FilterQuality.low,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Container(
                              child: PhotoView(
                            imageProvider: FileImage(_images[index]),
                          ))));
                },
              ),
            );
          },
          itemCount: _images.length,
        ),
      ),
    );
  }
}

class ImageView extends StatefulWidget {
  final List<File> files;

  ImageView({this.files});

  @override
  State<ImageView> createState() {
    return _ImageView();
  }
}

class _ImageView extends State<ImageView> {
  List<File> _images;
  TextEditingController _renameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _images = widget.files;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(_images);
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Slidable(
              actionExtentRatio: 0.15,
              actionPane: SlidableBehindActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  foregroundColor: Colors.white,
                  onTap: () async {
                    setState(() {
                      _images.removeAt(index);
                    });
                  },
                ),
                /*IconSlideAction(
                  caption: 'Rename',
                  color: Colors.yellow,
                  icon: Icons.edit,
                  foregroundColor: Colors.white,
                  onTap: () async {
                    _renameController.text = basename(_images[index].path);
                    var newName = await showDialog<String>(
                      context: context,
                      child: AlertDialog(
                        contentPadding: const EdgeInsets.all(16.0),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                autofocus: true,
                                controller: _renameController,
                                decoration: InputDecoration(
                                  labelText: 'New Name',
                                ),
                              ),
                            )
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                              child: const Text('CANCEL'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          FlatButton(
                            child: const Text('RENAME'),
                            onPressed: () {
                              Navigator.pop(context, _renameController.text);
                            },
                          )
                        ],
                      ),
                    );
                    if(newName != null) {
                      File newFile = await moveFile(_images[index], '${_images[index].parent.path}/${_renameController.text}');
                      setState(() {
                        _images[index] = newFile;
                      });
                    }
                  },
                ),*/
              ],
              child: ListTile(
                title: Text(basename(_images[index].path)),
                leading: Image(
                  image: FileImage(
                    _images[index],
                  ),
                  filterQuality: FilterQuality.low,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Container(
                              child: PhotoView(
                            imageProvider: FileImage(_images[index]),
                          ))));
                },
              ),
            );
          },
          itemCount: _images.length,
        ),
      ),
    );
  }
}

class NewSedimentaryRock extends StatefulWidget {
  int checkpointId;

  NewSedimentaryRock({this.checkpointId});

  @override
  State<StatefulWidget> createState() {
    return _NewSedimentaryRock();
  }
}

class _NewSedimentaryRock extends State<NewSedimentaryRock> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _code;
  TextEditingController _name;
  TextEditingController _lithology;
  TextEditingController _fossil;
  TextEditingController _otherFossil;
  TextEditingController _dip;
  TextEditingController _strike;
  TextEditingController _structure;
  TextEditingController _grainSize;
  TextEditingController _grainMorphology;
  TextEditingController _desc;
  List<File> images;
  List<String> fossils;
  final FocusNode _codeNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _lithologyNode = FocusNode();
  final FocusNode _otherFossilNode = FocusNode();
  final FocusNode _dipNode = FocusNode();
  final FocusNode _strikeNode = FocusNode();
  final FocusNode _grainSizeNode = FocusNode();
  final FocusNode _structureNode = FocusNode();
  final FocusNode _grainMorphologyNode = FocusNode();
  final FocusNode _descNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _code = TextEditingController();
    _name = TextEditingController();
    _lithology = TextEditingController();
    _fossil = TextEditingController();
    _otherFossil = TextEditingController();
    _dip = TextEditingController();
    _strike = TextEditingController();
    _grainSize = TextEditingController();
    _grainMorphology = TextEditingController();
    _structure = TextEditingController();
    _desc = TextEditingController();
    images = [];
    fossils = [];
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _exitScreen() {
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
        'checkpointId': widget.checkpointId,
        'code': _code.text,
        'name': _name.text,
        'lithology': _lithology.text,
        'fossil': _fossil.text,
        'otherFossil': _otherFossil.text,
        'dip': _dip.text,
        'strike': _strike.text,
        'structure': _structure.text,
        'grainSize': _grainSize.text,
        'grainMorphology': _grainMorphology.text,
        'description': _desc.text,
        'images': images
      };
      int resultId = await TableSedimentaryRockDelegate.save(json);
      print(resultId);
      Navigator.of(context).pop();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Sedimentary Rock'),
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
        ],
      ),
      body: WillPopScope(
        onWillPop: _exitScreen,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Check point code
                Text(
                  'Example Code',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _code,
                  focusNode: _codeNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _codeNode.unfocus();
                    FocusScope.of(context).requestFocus(_nameNode);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Rock Name
                Text(
                  'Example Name',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _name,
                  focusNode: _nameNode,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 20,
                ),
                // Lithology
                Text(
                  'Lithology',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _lithology,
                  focusNode: _lithologyNode,
                  onTap: () async {
                    String litho = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SedimentaryLithologyListView(),
                      ),
                    );
                    _lithology.text = litho;
                    _lithologyNode.unfocus();
                    FocusScope.of(context).requestFocus(_otherFossilNode);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Fossil
                Text(
                  'Fossil',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _fossil,
                  onTap: () async {
                    List newFossils = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SedimentaryFossil(
                          fossils: fossils,
                        ),
                      ),
                    );
                    if (newFossils != null) {
                      setState(() {
                        fossils = newFossils;
                        _fossil.text = fossils.join(',').toString();
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Other Fossil
                Text(
                  'Fossil Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _otherFossil,
                  focusNode: _otherFossilNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _otherFossilNode.unfocus();
                    FocusScope.of(context).requestFocus(_dipNode);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Dip and Strike
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Dip',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _dip,
                            focusNode: _dipNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _dipNode.unfocus();
                              FocusScope.of(context).requestFocus(_strikeNode);
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
                            'Strike',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _strike,
                            focusNode: _strikeNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _strikeNode.unfocus();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // Bed Structure
                Text(
                  'Bed Structure',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Bed Thickness / Bed Characters',
                  style: Theme.of(context).textTheme.display2,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _structure,
                  focusNode: _structureNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Grain Size
                Text(
                  'Grain Size',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _grainSize,
                  focusNode: _grainSizeNode,
                  onTap: () async {
                    String gS = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                SedimentaryGrainSizeListView()));
                    _grainSize.text = gS;
                    _grainSizeNode.unfocus();
                    FocusScope.of(context).requestFocus(_grainMorphologyNode);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Grain Morphology
                Text(
                  'Grain Morphology',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Color / Weathering Color / Origin / Sorting / Roundness / Sphericity / Composite',
                  style: Theme.of(context).textTheme.display2,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _grainMorphology,
                  focusNode: _grainMorphologyNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Other Description
                Text(
                  'Other Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Other Features in Example',
                  style: Theme.of(context).textTheme.display2,
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
                // Pictures

                // Add Button
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
                MaterialButton(
                  onPressed: _save,
                  color: Colors.green,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Add',
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

class NewIgneousRock extends StatefulWidget {
  int checkpointId;
  NewIgneousRock({this.checkpointId});
  @override
  State<StatefulWidget> createState() {
    return _NewIgneousRock();
  }
}

class _NewIgneousRock extends State<NewIgneousRock> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _code;
  TextEditingController _name;
  TextEditingController _lithology;
  TextEditingController _lithologyDesc;
  TextEditingController _fieldRelation;
  TextEditingController _fieldRelationDesc;
  TextEditingController _composition;
  TextEditingController _desc;
  List<File> images;
  final FocusNode _codeNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _lithologyNode = FocusNode();
  final FocusNode _lithologyDescNode = FocusNode();
  final FocusNode _fieldRelationNode = FocusNode();
  final FocusNode _fieldRelationDescNode = FocusNode();
  final FocusNode _compositionNode = FocusNode();
  final FocusNode _descNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _code = TextEditingController();
    _name = TextEditingController();
    _lithology = TextEditingController();
    _lithologyDesc = TextEditingController();
    _fieldRelation = TextEditingController();
    _fieldRelationDesc = TextEditingController();
    _composition = TextEditingController();
    _desc = TextEditingController();
    images = [];
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _exitScreen() {
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
        'checkpointId': widget.checkpointId,
        'code': _code.text,
        'name': _name.text,
        'lithology': _lithology.text,
        'lithologyDescription': _lithologyDesc.text,
        'fieldRelation': _fieldRelation.text,
        'fieldRelationDescription': _fieldRelationDesc.text,
        'composition': _composition.text,
        'description': _desc.text,
        'images': images
      };
      int resultId = await TableIgneousRockDelegate.save(json);
      print(resultId);
      Navigator.of(context).pop();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Igneous Rock'),
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
        ],
      ),
      body: WillPopScope(
        onWillPop: _exitScreen,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Check point code
                Text(
                  'Example Code',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _code,
                  focusNode: _codeNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _codeNode.unfocus();
                    FocusScope.of(context).requestFocus(_nameNode);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Rock Name
                Text(
                  'Example Name',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _name,
                  focusNode: _nameNode,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 20,
                ),
                // Lithology
                Text(
                  'Texture',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _lithology,
                  focusNode: _lithologyNode,
                  onTap: () async {
                    String litho = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => IgneousLithologyListView(),
                      ),
                    );
                    _lithology.text = litho;
                    _lithologyNode.unfocus();
                    FocusScope.of(context).requestFocus(_lithologyDescNode);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Lithology Description
                Text(
                  'Texture Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Groundmass(Matrix) / Phenocryst / Texture Features',
                  style: Theme.of(context).textTheme.display2,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _lithologyDesc,
                  focusNode: _lithologyDescNode,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Field Relation
                Text(
                  'Field Relation',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Extrusive(Volcanic) / Intrusive(Plutonic)',
                  style: Theme.of(context).textTheme.display2,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _fieldRelation,
                  focusNode: _fieldRelationNode,
                ),
                SizedBox(
                  height: 20,
                ),
                // Field Relation Description
                Text(
                  'Field Relation Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _fieldRelationDesc,
                  focusNode: _fieldRelationDescNode,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Mineral Composition
                Text(
                  'Chemical Composition',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Mineral Color / Weathered Color / Grain Size / Grain Shape',
                  style: Theme.of(context).textTheme.display2,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _composition,
                  focusNode: _compositionNode,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Other Description
                Text(
                  'Other Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Other Features in Example',
                  style: Theme.of(context).textTheme.display2,
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
                // Pictures

                // Add Button
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
                MaterialButton(
                  onPressed: _save,
                  color: Colors.green,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Add',
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

class NewMetamorphicRock extends StatefulWidget {
  int checkpointId;
  NewMetamorphicRock({this.checkpointId});
  @override
  State<StatefulWidget> createState() {
    return _NewMetamorphicRock();
  }
}

class _NewMetamorphicRock extends State<NewMetamorphicRock> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _code;
  TextEditingController _name;
  TextEditingController _lithologyDesc;
  TextEditingController _composition;
  TextEditingController _desc;
  TextEditingController _fieldRelationDesc;
  TextEditingController _foliationDesc;
  TextEditingController _cleavageDesc;
  TextEditingController _boudinDesc;
  List<File> images;
  final FocusNode _codeNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _lithologyDescNode = FocusNode();
  final FocusNode _compositionNode = FocusNode();
  final FocusNode _descNode = FocusNode();
  final FocusNode _fieldRelationDescNode = FocusNode();
  final FocusNode _foliationDescNode = FocusNode();
  final FocusNode _cleavageDescNode = FocusNode();
  final FocusNode _boudinDescNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _code = TextEditingController();
    _name = TextEditingController();
    _lithologyDesc = TextEditingController();
    _composition = TextEditingController();
    _desc = TextEditingController();
    _fieldRelationDesc = TextEditingController();
    _foliationDesc = TextEditingController();
    _cleavageDesc = TextEditingController();
    _boudinDesc = TextEditingController();
    images = [];
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _exitScreen() {
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
        'checkpointId': widget.checkpointId,
        'code': _code.text,
        'name': _name.text,
        'lithologyDescription': _lithologyDesc.text,
        'composition': _composition.text,
        'fieldRelationDescription': _fieldRelationDesc.text,
        'foliationDescription': _foliationDesc.text,
        'cleavageDescription': _cleavageDesc.text,
        'boudinDescription': _boudinDesc.text,
        'description': _desc.text,
        'images': images
      };
      int resultId = await TableMetamorphicRockDelegate.save(json);
      print(resultId);
      Navigator.of(context).pop();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Metamorphic Rock'),
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
        ],
      ),
      body: WillPopScope(
        onWillPop: _exitScreen,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Check point code
                Text(
                  'Example Code',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _code,
                  focusNode: _codeNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _codeNode.unfocus();
                    FocusScope.of(context).requestFocus(_nameNode);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Rock Name
                Text(
                  'Example Name',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _name,
                  focusNode: _nameNode,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 20,
                ),
                // Lithology Description
                Text(
                  'Texture Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Color / Grain Size',
                  style: Theme.of(context).textTheme.display2,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _lithologyDesc,
                  focusNode: _lithologyDescNode,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Mineral Composition
                Text(
                  'Chemical Composition',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Mineral Color / Weathered Color / Grain Size / Grain Shape / Percents of Each Major Mineral / Primary Textures',
                  style: Theme.of(context).textTheme.display2,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _composition,
                  focusNode: _compositionNode,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Cross Cutting Relation
                Text(
                  'Cross Cutting Relation',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Fabric elements / Folds',
                  style: Theme.of(context).textTheme.display2,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _fieldRelationDesc,
                  focusNode: _fieldRelationDescNode,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Foliation
                Text(
                  'Foliation Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Foliation Description',
                  style: Theme.of(context).textTheme.display2,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _foliationDesc,
                  focusNode: _foliationDescNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Cleavage
                Text(
                  'Cleavage Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Cleavage Type / Plane Strike',
                  style: Theme.of(context).textTheme.display2,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _cleavageDesc,
                  focusNode: _cleavageDescNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Boudins
                Text(
                  'Boudinage Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Boudinage Structures',
                  style: Theme.of(context).textTheme.display2,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _boudinDesc,
                  focusNode: _boudinDescNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Other Description
                Text(
                  'Other Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Other Features in Example',
                  style: Theme.of(context).textTheme.display2,
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
                // Add Button
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
                MaterialButton(
                  onPressed: _save,
                  color: Colors.green,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Add',
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

class NewStructure extends StatefulWidget {
  int checkpointId;
  NewStructure({this.checkpointId});
  @override
  State<StatefulWidget> createState() {
    return _NewStructure();
  }
}

class _NewStructure extends State<NewStructure> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _code;
  TextEditingController _name;
  TextEditingController _type;
  TextEditingController _strike;
  TextEditingController _dip;
  TextEditingController _plunge;
  TextEditingController _trend;
  TextEditingController _description;
  List<File> images;
  final FocusNode _codeNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _typeNode = FocusNode();
  final FocusNode _strikeNode = FocusNode();
  final FocusNode _dipNode = FocusNode();
  final FocusNode _plungeNode = FocusNode();
  final FocusNode _trendNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _code = TextEditingController();
    _name = TextEditingController();
    _type = TextEditingController();
    _strike = TextEditingController();
    _dip = TextEditingController();
    _plunge = TextEditingController();
    _trend = TextEditingController();
    _description = TextEditingController();
    images = [];
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _exitScreen() {
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
        'checkpointId': widget.checkpointId,
        'code': _code.text,
        'name': _name.text,
        'type': _type.text,
        'description': _description.text,
        'dip': _dip.text,
        'strike': _strike.text,
        'plunge': _plunge.text,
        'trend': _trend.text,
        'images': images
      };
      print(json);
      int resultId = await TableStructureDelegate.save(json);
      Navigator.of(context).pop();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Structure'),
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
        ],
      ),
      body: WillPopScope(
        onWillPop: _exitScreen,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Structure Code
                Text(
                  'Example Code',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _code,
                  focusNode: _codeNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _codeNode.unfocus();
                    FocusScope.of(context).requestFocus(_nameNode);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Structure Name
                Text(
                  'Example Name',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _name,
                  focusNode: _nameNode,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 20,
                ),
                // Type
                Text(
                  'Structure Type',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _type,
                  focusNode: _typeNode,
                  onTap: () async {
                    String type = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StructureType(),
                      ),
                    );
                    _type.text = type;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Dip and Strike
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Dip',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _dip,
                            focusNode: _dipNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _dipNode.unfocus();
                              FocusScope.of(context).requestFocus(_strikeNode);
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
                            'Strike',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _strike,
                            focusNode: _strikeNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _strikeNode.unfocus();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // Plunge and Trend
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Plunge',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _plunge,
                            focusNode: _plungeNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _plungeNode.unfocus();
                              FocusScope.of(context).requestFocus(_trendNode);
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
                            'Trend',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _trend,
                            focusNode: _trendNode,
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
                // Other Description
                Text(
                  'Other Description',
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Detail in your structure feature',
                  style: Theme.of(context).textTheme.display2,
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _description,
                  focusNode: _descriptionNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                SizedBox(
                  height: 20,
                ),
                // Add Button
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
                MaterialButton(
                  onPressed: _save,
                  color: Colors.green,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Add',
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

class SedimentaryRockView extends StatefulWidget {
  int featureId;

  SedimentaryRockView({this.featureId});

  @override
  State<StatefulWidget> createState() {
    return _SedimentaryRockView();
  }
}

class _SedimentaryRockView extends State<SedimentaryRockView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sedimentary Rock'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: TableSedimentaryRockDelegate.get(
                featureId: widget.featureId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Text('Loading ...'),
                  );
                default:
                  Map first = snapshot.data[0];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Check point code
                      Text(
                        'Example Code',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${first['code']}',
                        style: Theme.of(context).textTheme.display3,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Rock Name
                      Text(
                        'Example Name',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${first['name']}',
                        style: Theme.of(context).textTheme.display3,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Lithology
                      Text(
                        'Lithology',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${first['lithology']}',
                        style: Theme.of(context).textTheme.display3,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Fossil
                      Text(
                        'Fossil',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${first['fossil']}',
                        style: Theme.of(context).textTheme.display3,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Other Fossil
                      Text(
                        'Fossil Description',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${first['otherFossil']}',
                        style: Theme.of(context).textTheme.display3,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Dip and Strike
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Dip',
                                  style: Theme.of(context).textTheme.display1,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${first['dip']}',
                                  style: Theme.of(context).textTheme.display3,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Strike',
                                  style: Theme.of(context).textTheme.display1,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${first['strike']}',
                                  style: Theme.of(context).textTheme.display3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Bed Structure
                      Text(
                        'Bed Structure',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Bed Thickness / Bed Characters',
                        style: Theme.of(context).textTheme.display2,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${first['structure']}',
                        style: Theme.of(context).textTheme.display3,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Grain Size
                      Text(
                        'Grain Size',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${first['grainSize']}',
                        style: Theme.of(context).textTheme.display3,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Grain Morphology
                      Text(
                        'Grain Morphology',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Color / Weathering Color / Origin / Sorting / Roundness / Sphericity / Composite',
                        style: Theme.of(context).textTheme.display2,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${first['grainMorphology']}',
                        style: Theme.of(context).textTheme.display3,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Other Description
                      Text(
                        'Other Description',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Other Features in Example',
                        style: Theme.of(context).textTheme.display2,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${first['description']}',
                        style: Theme.of(context).textTheme.display3,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Pictures

                      // Delete Button
                      MaterialButton(
                        onPressed: () async {
                          List imagePaths = await TableFeatureDelegate.getImages(first['featureId']);
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ImageView(files: imagePaths,)
                            ),
                          );
                        },
                        color: Colors.lightBlue,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'View Images',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => EditSedimentaryRock(rock: first,)
                            ),
                          );
                        },
                        color: Colors.amber,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          int count = await TableFeatureDelegate.deleteRock(first);
                          print(count);
                          Navigator.of(context).pop();
                        },
                        color: Colors.red,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class IgneousRockView extends StatefulWidget {
  int featureId;
  IgneousRockView({this.featureId});
  @override
  State<StatefulWidget> createState() {
    return _IgneousRockView();
  }
}

class _IgneousRockView extends State<IgneousRockView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Igneous Rock'),
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: TableIgneousRockDelegate.get(
                  featureId: widget.featureId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: Text('Loading ...'),
                    );
                  default:
                    Map first = snapshot.data[0];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Check point code
                        Text(
                          'Example Code',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['code']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Rock Name
                        Text(
                          'Example Name',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['name']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Lithology
                        Text(
                          'Texture',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['lithology']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Lithology Description
                        Text(
                          'Texture Description',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Groundmass(Matrix) / Phenocryst / Texture Features',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['lithologyDescription']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Field Relation
                        Text(
                          'Field Relation',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Extrusive(Volcanic) / Intrusive(Plutonic)',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['fieldRelation']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Field Relation Description
                        Text(
                          'Field Relation Description',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['fieldRelationDescription']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Mineral Composition
                        Text(
                          'Chemical Composition',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Mineral Color / Weathered Color / Grain Size / Grain Shape',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['composition']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Other Description
                        Text(
                          'Other Description',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Other Features in Example',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['description']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Pictures

                        // Image Button
                        MaterialButton(
                          onPressed: () async {
                            List imagePaths = await TableFeatureDelegate.getImages(
                                first['featureId']);
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ImageView(files: imagePaths,)
                              ),
                            );
                          },
                          color: Colors.lightBlue,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'View Images',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => EditIgneousRock(rock: first,)
                              ),
                            );
                          },
                          color: Colors.amber,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            int count = await TableFeatureDelegate.deleteRock(first);
                            Navigator.of(context).pop();
                          },
                          color: Colors.red,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                }
              },
            )
        ),
      )
    );
  }
}

class MetamorphicRockView extends StatefulWidget {
  int featureId;
  MetamorphicRockView({this.featureId});
  @override
  State<StatefulWidget> createState() {
    return _MetamorphicRockView();
  }
}

class _MetamorphicRockView extends State<MetamorphicRockView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Metamorphic Rock'),
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: TableMetamorphicRockDelegate.get(featureId: widget.featureId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Text('Loading ...'),
                  );
                default:
                  if(snapshot.hasData) {
                    Map first = snapshot.data[0];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Check point code
                        Text(
                          'Example Code',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['code']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Rock Name
                        Text(
                          'Example Name',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['name']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Lithology Description
                        Text(
                          'Texture Description',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Color / Grain Size',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['lithologyDescription']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Mineral Composition
                        Text(
                          'Chemical Composition',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Mineral Color / Weathered Color / Grain Size / Grain Shape / Percents of Each Major Mineral / Primary Textures',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['composition']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Cross Cutting Relation
                        Text(
                          'Cross Cutting Relation',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Fabric elements / Folds',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['fieldRelationDescription']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Foliation
                        Text(
                          'Foliation Description',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Foliation Description',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['foliationDescription']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Cleavage
                        Text(
                          'Cleavage Description',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Cleavage Type / Plane Strike',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['cleavageDescription']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Boudins
                        Text(
                          'Boudinage Description',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Boudinage Structures',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['boudinDescription']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Other Description
                        Text(
                          'Other Description',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Other Features in Example',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['description']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Add Button
                        MaterialButton(
                          onPressed: () async {
                            List imagePaths = await TableFeatureDelegate.getImages(
                                first['featureId']);
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ImageView(files: imagePaths,)
                              ),
                            );
                          },
                          color: Colors.lightBlue,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'View Images',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => EditMetamorphicRock(rock: first,)
                              ),
                            );
                          },
                          color: Colors.amber,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            int count = await TableFeatureDelegate.deleteRock(first);
                            print(count);
                            Navigator.of(context).pop();
                          },
                          color: Colors.red,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text('Loading ...'),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}

class StructureView extends StatefulWidget {
  int featureId;
  StructureView({this.featureId});
  @override
  State<StatefulWidget> createState() {
    return _StructureView();
  }
}

class _StructureView extends State<StructureView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<File> images;

  @override
  void initState() {
    super.initState();
    images = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Structure'),
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: TableStructureDelegate.get(featureId: widget.featureId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Text('Loading ...'),
                  );
                default:
                  if(snapshot.hasData) {
                    Map first = snapshot.data[0];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Structure Code
                        Text(
                          'Example Code',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['code']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Structure Name
                        Text(
                          'Example Name',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['name']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Type
                        Text(
                          'Structure Type',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['type']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Dip and Strike
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Dip',
                                    style: Theme.of(context).textTheme.display1,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${first['dip']}',
                                    style: Theme.of(context).textTheme.display3,
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Strike',
                                    style: Theme.of(context).textTheme.display1,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${first['strike']}',
                                    style: Theme.of(context).textTheme.display3,
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Plunge and Trend
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Plunge',
                                    style: Theme.of(context).textTheme.display1,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${first['plunge']}',
                                    style: Theme.of(context).textTheme.display3,
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Trend',
                                    style: Theme.of(context).textTheme.display1,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${first['trend']}',
                                    style: Theme.of(context).textTheme.display3,
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Other Description
                        Text(
                          'Other Description',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Detail in your structure feature',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${first['description']}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Button
                        MaterialButton(
                          onPressed: () async {
                            List imagePaths = await TableFeatureDelegate.getImages(
                                first['featureId']);
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ImageView(files: imagePaths,)
                              ),
                            );
                          },
                          color: Colors.lightBlue,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'View Images',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => EditStructure(structure: first,)
                              ),
                            );
                          },
                          color: Colors.amber,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            int count = await TableFeatureDelegate.deleteStructure(first);
                            Navigator.of(context).pop();
                          },
                          color: Colors.red,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text('Loading ...'),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}