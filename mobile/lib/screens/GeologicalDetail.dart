// Sedimentary Rock
import 'package:flutter/material.dart';
import 'package:geolrecap/models/Geology.dart';
import 'package:geolrecap/screens/NotesView.dart';

class SedimentaryLithologyListView extends StatelessWidget {
  List lithologies = sedimentaryLithology;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lithology'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => NoteListWithScaffoldView()
                  )
              );
            },
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(lithologies[index]['name']),
            subtitle: Text(lithologies[index]['description']),
            onTap: () {
              Navigator.of(context).pop(lithologies[index]['name']);
            },
          );
        },
        itemCount: lithologies.length,
      ),
    );
  }

}

class IgneousLithologyListView extends StatelessWidget {
  List lithologies = igneousLithology;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Texture'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => NoteListWithScaffoldView()
                  )
              );
            },
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(lithologies[index]['name']),
            subtitle: Text(lithologies[index]['description']),
            onTap: () {
              Navigator.of(context).pop(lithologies[index]['name']);
            },
          );
        },
        itemCount: lithologies.length,
      ),
    );
  }

}

class SedimentaryGrainSizeListView extends StatelessWidget {
  List sGz = grainSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grain Size'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => NoteListWithScaffoldView()
                  )
              );
            },
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(sGz[index]['name']),
            subtitle: Text(sGz[index]['description']),
            onTap: () {
              Navigator.of(context).pop(sGz[index]['name']);
            },
          );
        },
        itemCount: sGz.length,
      ),
    );
  }

}

class SedimentaryFossil extends StatefulWidget {
  List<String> fossils;

  SedimentaryFossil({this.fossils});

  @override
  State<StatefulWidget> createState() {
    return _SedimentaryFossil();
  }

}

class _SedimentaryFossil extends State<SedimentaryFossil> {
  List<String> selectedFossil;
  List<String> fossilList;
  List<String> searchResult;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fossilList = initFossils;
    selectedFossil = widget.fossils;
    searchResult = fossilList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fossils'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => NoteListWithScaffoldView()
                  )
              );
            },
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if(index == 0) {
            return Column(
              children: <Widget>[
                TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search fossil'
                  ),
                  onFieldSubmitted: (value) {
                    setState(() {
                      searchResult = fossilList.where((each) {
                        return each.toLowerCase().contains(value.toLowerCase());
                      }).toList();
                    });
                  },
                ),
                ListTile(
                  title: Text(searchResult[index]),
                  onTap: () {
                    Navigator.of(context).pop(selectedFossil.add(searchResult[index]));
                  },
                )
              ],
            );
          }
          return ListTile(
            title: Text(searchResult[index]),
            onTap: () {
              selectedFossil.add(searchResult[index]);
              Navigator.of(context).pop(selectedFossil);
            },
          );
        },
        itemCount: searchResult.length,
      ),
    );
  }

}

class StructureType extends StatefulWidget {
  @override
  State<StructureType> createState() {
    return _StructureType();
  }

}

class _StructureType extends State<StructureType> {
  TextEditingController _searchController;
  List _allResult;
  List _searchResult;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _allResult = structureType;
    _searchResult = structureType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Structures'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => NoteListWithScaffoldView()
                  )
              );
            },
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if(index == 0) {
            return Column(
              children: <Widget>[
                TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search structure'
                  ),
                  onFieldSubmitted: (value) {
                    setState(() {
                      _searchResult = _allResult.where((each) {
                        return each['title'].toLowerCase().contains(value.toLowerCase());
                      }).toList();
                    });
                  },
                ),
              ],
            );
          }
          if(_searchResult[index]['level'] == 1) {
            return ListTile(
              title: Text(_searchResult[index]['title'], style: TextStyle(fontWeight: FontWeight.w700),),
              onTap: () {},
            );
          } else if(_searchResult[index]['level'] == 2) {
            return ListTile(
              title: Text(_searchResult[index]['title'], style: TextStyle(fontWeight: FontWeight.w700),),
              contentPadding: EdgeInsets.only(left: 30),
              onTap: () {},
            );
          } else  {
            return ListTile(
              title: Text(_searchResult[index]['title']),
              contentPadding: EdgeInsets.only(left: 50),
              onTap: () {
                Navigator.of(context).pop(_searchResult[index]['title']);
              },
            );
          }
        },
        itemCount: _searchResult.length,
      ),
    );
  }

}