import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolrecap/models/Database.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:geolrecap/helpers/Editor.dart';

// Dictionary
class GRTextEditor extends StatefulWidget {
  GRTextEditor({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GRTextEditor();
  }
}

class _GRTextEditor extends State<StatefulWidget> {
  FocusNode _focusNode;
  ZefyrController _controller;

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final editor = new ZefyrEditor(
      padding: EdgeInsets.all(10),
      focusNode: _focusNode,
      controller: _controller,
      imageDelegate: GRZefyrImageDelegate(),
    );
    return ZefyrScaffold(
      child: Container(
        child: editor,
      ),
    );
  }
}

class GRNoteEditor extends StatefulWidget {
  GRNoteEditor({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GRNoteEditor();
  }
}

class _GRNoteEditor extends State<StatefulWidget> {
  FocusNode _focusNode;
  ZefyrController _controller;
  TextEditingController _title;
  TextEditingController _keyword;

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    _title = TextEditingController();
    _keyword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final editor = new ZefyrEditor(
      padding: EdgeInsets.all(10),
      focusNode: _focusNode,
      controller: _controller,
      imageDelegate: GRZefyrImageDelegate(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              String jsonEn = jsonEncode(_controller.document);
              print(jsonEn);
              print(jsonEn.runtimeType);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              String jsonEn = jsonEncode(_controller.document);
              Map result = await showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text('Set Infomation'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _title,
                          decoration: InputDecoration(hintText: 'Title'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _keyword,
                          decoration: InputDecoration(hintText: 'Keyboard'),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('SET'),
                        onPressed: () {
                          Navigator.of(context).pop(
                              {'title': _title.text, 'keyword': _keyword.text});
                        },
                      )
                    ],
                  ));
              final database = await AppDatabase.db.database;
              int projectId = await database.rawInsert('''
                  INSERT INTO note(
                    createdBy,
                    createdDate,
                    modifiedBy,
                    modifiedDate, 
                    title,
                    content,
                    keyword
                  )
                  VALUES (
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    ?
                  )
                  ''', [
                1,
                DateTime.now().millisecondsSinceEpoch,
                1,
                DateTime.now().millisecondsSinceEpoch,
                result['title'],
                jsonEn,
                result['keyword']
              ]);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: ZefyrScaffold(
        child: Container(
          child: editor,
        ),
      ),
    );
  }
}

class GRNoteViewer extends StatefulWidget {
  final Map note;

  GRNoteViewer({this.note});

  @override
  State<StatefulWidget> createState() {
    return _GRNoteViewer();
  }
}

class _GRNoteViewer extends State<GRNoteViewer> {
  FocusNode _focusNode;
  ZefyrController _controller;

  NotusDocument _loadDocument() {
    print(widget.note['content']);
    final ncontent = jsonDecode(widget.note['content']);
    return NotusDocument.fromJson(ncontent);
  }

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final editor = new ZefyrEditor(
      padding: EdgeInsets.all(10),
      focusNode: _focusNode,
      controller: _controller,
      imageDelegate: GRZefyrImageDelegate(),
      mode: ZefyrMode.select,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.note['title']}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => GRNoteEditing(note: widget.note,)
                )
              );
            },
          )
        ],
      ),
      body: ZefyrScaffold(
        child: Container(
          child: editor,
        ),
      ),
    );
  }
}

class GRNoteEditing extends StatefulWidget {
  final Map note;

  GRNoteEditing({this.note});

  @override
  State<StatefulWidget> createState() {
    return _GRNoteEditing();
  }
}

class _GRNoteEditing extends State<GRNoteEditing> {
  FocusNode _focusNode;
  ZefyrController _controller;
  TextEditingController _title;
  TextEditingController _keyword;

  NotusDocument _loadDocument() {
    final ncontent = jsonDecode(widget.note['content']);
    return NotusDocument.fromJson(ncontent);
  }

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    _title = TextEditingController(text: widget.note['title']);
    _keyword = TextEditingController(text: widget.note['keyword']);
  }

  @override
  Widget build(BuildContext context) {
    final editor = new ZefyrEditor(
      padding: EdgeInsets.all(10),
      focusNode: _focusNode,
      controller: _controller,
      imageDelegate: GRZefyrImageDelegate(),
      mode: ZefyrMode.edit,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              String jsonEn = jsonEncode(_controller.document);
              Map result = await showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text('Set Infomation'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _title,
                          decoration: InputDecoration(hintText: 'Title'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _keyword,
                          decoration: InputDecoration(hintText: 'Keyboard'),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('SET'),
                        onPressed: () {
                          Navigator.of(context).pop(
                              {'title': _title.text, 'keyword': _keyword.text});
                        },
                      )
                    ],
                  ));
              final database = await AppDatabase.db.database;
              int projectId = await database.rawUpdate('''
                  update note set
                    modifiedBy = ?,
                    modifiedDate = ?,
                    title = ?,
                    content = ?,
                    keyword = ?
                  where
                    id = ?
                  ''', [
                1,
                DateTime.now().millisecondsSinceEpoch,
                result['title'],
                jsonEn,
                result['keyword'],
                widget.note['id']
              ]);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: ZefyrScaffold(
        child: Container(
          child: editor,
        ),
      ),
    );
  }
}
