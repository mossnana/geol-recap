import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolrecap/helpers/DatabaseDelegate.dart';
import 'package:geolrecap/screens/FeatureView.dart';
import 'package:geolrecap/screens/GeologicalDetail.dart';
import 'package:geolrecap/screens/NotesView.dart';

class EditSedimentaryRock extends StatefulWidget {
  final Map rock;

  EditSedimentaryRock({this.rock});

  @override
  State<StatefulWidget> createState() {
    return _EditSedimentaryRock();
  }
}

class _EditSedimentaryRock extends State<EditSedimentaryRock> {
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
    _code = TextEditingController(text: widget?.rock['code']);
    _name = TextEditingController(text: widget?.rock['name']);
    _lithology = TextEditingController(text: widget?.rock['lithology']);
    _fossil = TextEditingController(text: widget?.rock['fossil']);
    _otherFossil = TextEditingController(text: widget?.rock['otherFossil']);
    _dip = TextEditingController(text: '${widget?.rock['dip']}');
    _strike = TextEditingController(text: '${widget?.rock['strike']}');
    _grainSize = TextEditingController(text: widget?.rock['grainSize']);
    _grainMorphology = TextEditingController(text: widget?.rock['grainMorphology']);
    _structure = TextEditingController(text: widget?.rock['structure']);
    _desc = TextEditingController(text: widget?.rock['description']);
    images = [];
    fossils = [];
    getImages();
  }

  void getImages() async {
    List result = await TableFeatureDelegate.getImages(widget?.rock['featureId']);
    setState(() {
      images = result;
    });
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
        'checkpointId': widget.rock['checkpointId'],
        'featureId': widget.rock['featureId'],
        'rockId': widget.rock['rockId'],
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
      int resultId = await TableSedimentaryRockDelegate.update(json);
      Navigator.of(context).pop();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Sedimentary Rock'),
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
                    List<File> newImages = await Navigator.of(context).push(MaterialPageRoute(
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
                      'Edit Images',
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
                      'Edit',
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

class EditIgneousRock extends StatefulWidget {
  final Map rock;
  EditIgneousRock({this.rock});
  @override
  State<StatefulWidget> createState() {
    return _EditIgneousRock();
  }
}

class _EditIgneousRock extends State<EditIgneousRock> {
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
    _code = TextEditingController(text: widget.rock['code']);
    _name = TextEditingController(text: widget.rock['name']);
    _lithology = TextEditingController(text: widget.rock['lithology']);
    _lithologyDesc = TextEditingController(text: widget.rock['lithologyDescription']);
    _fieldRelation = TextEditingController(text: widget.rock['fieldRelation']);
    _fieldRelationDesc = TextEditingController(text: widget.rock['fieldRelationDescription']);
    _composition = TextEditingController(text: widget.rock['composition']);
    _desc = TextEditingController(text: widget.rock['description']);
    images = [];
    getImages();
  }

  void getImages() async {
    List result = await TableFeatureDelegate.getImages(widget?.rock['featureId']);
    setState(() {
      images = result;
    });
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
        'checkpointId': widget.rock['checkpointId'],
        'featureId': widget.rock['featureId'],
        'rockId': widget.rock['rockId'],
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
      int resultId = await TableIgneousRockDelegate.update(json);
      print(resultId);
      Navigator.of(context).pop();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Igneous Rock'),
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
                    List<File> newImages = await Navigator.of(context).push(MaterialPageRoute(
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
                      'Edit Images',
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
                      'Edit',
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

class EditMetamorphicRock extends StatefulWidget {
  final Map rock;
  EditMetamorphicRock({this.rock});
  @override
  State<StatefulWidget> createState() {
    return _EditMetamorphicRock();
  }
}

class _EditMetamorphicRock extends State<EditMetamorphicRock> {
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
    _code = TextEditingController(text: widget.rock['code']);
    _name = TextEditingController(text: widget.rock['name']);
    _lithologyDesc = TextEditingController(text: widget.rock['lithologyDescription']);
    _fieldRelationDesc = TextEditingController(text: widget.rock['fieldRelationDescription']);
    _composition = TextEditingController(text: widget.rock['composition']);
    _desc = TextEditingController(text: widget.rock['description']);
    _foliationDesc = TextEditingController(text: widget.rock['foliationDescription']);
    _cleavageDesc = TextEditingController(text: widget.rock['cleavageDescription']);
    _boudinDesc = TextEditingController(text: widget.rock['boudinDescription']);
    images = [];
    getImages();
  }

  void getImages() async {
    List result = await TableFeatureDelegate.getImages(widget?.rock['featureId']);
    setState(() {
      images = result;
    });
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
        'checkpointId': widget.rock['checkpointId'],
        'featureId': widget.rock['featureId'],
        'rockId': widget.rock['rockId'],
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
      int resultId = await TableMetamorphicRockDelegate.update(json);
      Navigator.of(context).pop();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Metamorphic Rock'),
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
                      'Edit Images',
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
                      'Edit',
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

class EditStructure extends StatefulWidget {
  final Map structure;
  EditStructure({this.structure});
  @override
  State<StatefulWidget> createState() {
    return _EditStructure();
  }
}

class _EditStructure extends State<EditStructure> {
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
    _code = TextEditingController(text: widget.structure['code']);
    _name = TextEditingController(text: widget.structure['name']);
    _type = TextEditingController(text: widget.structure['type']);
    _strike = TextEditingController(text: widget.structure['strike']);
    _dip = TextEditingController(text: widget.structure['dip']);
    _plunge = TextEditingController(text: widget.structure['plunge']);
    _trend = TextEditingController(text: widget.structure['trend']);
    _description = TextEditingController(text: widget.structure['description']);
    images = [];
  }

  void getImages() async {
    List result = await TableFeatureDelegate.getImages(widget?.structure['featureId']);
    setState(() {
      images = result;
    });
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
        'checkpointId': widget.structure['checkpointId'],
        'featureId': widget.structure['featureId'],
        'structureId': widget.structure['structureId'],
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
        title: Text('Edit Structure'),
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
                      'Edit Images',
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
                      'Edit',
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