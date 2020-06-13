import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolrecap/helpers/DatabaseDelegate.dart';
import 'package:geolrecap/models/Database.dart';
import 'package:geolrecap/widgets/Editor.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_porter/utils/csv_utils.dart';

class NoteListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoteListView();
  }
}

class _NoteListView extends State<NoteListView> {
  TextEditingController _searchController = TextEditingController();
  List<Map> _notes = [];

  Future<List<Map>> _getNotes() async {
    if(_searchController.text.isNotEmpty || _searchController.text != '') {
      return _notes;
    } else {
      List<Map> notes = await TableNoteDelegate.get();
      return notes;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _getNotes(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List<Map> notes = snapshot.data;
            if (notes.length == 0 && _searchController.text.isEmpty) {
              return Center(
                child: Text('Click + to add new note'),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(0),
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                          helperText: _searchController.text == null || _searchController.text == "" ? '' : 'You are searching for ${_searchController.text}'
                      ),
                      onFieldSubmitted: (value) async {
                        final database = await AppDatabase.db.database;
                        var result = await database.rawQuery(''' 
                                SELECT *
                                FROM note
                                WHERE keyword LIKE '%${_searchController.text}%' OR title LIKE '%${_searchController.text}%'
                              ''', []);
                        setState(() {
                          _notes = result;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: screenSize.height * 0.9 - 60,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        Map note = notes[index];
                        return Slidable(
                          actionExtentRatio: 0.15,
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              foregroundColor: Colors.white,
                              onTap: () async {
                                await TableNoteDelegate.delete(id: note['id']);
                                setState((){});
                              },
                            ),
                          ],
                          actionPane: SlidableBehindActionPane(),
                          child: ListTile(
                            title: Text('${note['title']}'),
                            subtitle: Text(
                                '${DateTime.fromMillisecondsSinceEpoch(note['createdDate']).toAppDate()}'),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GRNoteViewer(
                                    note: note,
                                  )));
                            },
                          ),
                        );
                      },
                      itemCount: notes.length,
                    ),
                  )
                ],
              ),
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

class NoteListWithScaffoldView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: NoteListView(),
    );
  }

}

extension on DateTime {
  String toAppDate() {
    var formatter = DateFormat('d MMMM y HH:mm');
    return '${formatter.format(this)}';
  }
}
