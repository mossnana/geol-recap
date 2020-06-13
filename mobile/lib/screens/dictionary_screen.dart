import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geol_recap/bloc/dictionary/dictionary_bloc.dart';
import 'package:geol_recap/models/collection.dart';

class DictionaryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DictionaryScreen();
  }
}

class _DictionaryScreen extends State<DictionaryScreen> {
  String _keyword;
  DictionaryBloc _dictionaryBloc;

  void _onSearch(string) {
    setState(() {
      _keyword = string;
    });
    if (string == "") {
      _dictionaryBloc.add(ReadAll());
    } else {
      _dictionaryBloc.add(SearchWord(keyword: string));
    }
  }

  void _onCancel() {
    if (_keyword == '') {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _keyword = '';
      });
      _dictionaryBloc.add(ReadAll());
    }
  }

  @override
  void initState() {
    super.initState();
    _keyword = '';
    _dictionaryBloc = BlocProvider.of<DictionaryBloc>(context)
      ..add(LoadWords());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: screenSize.height,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                hintText: 'Search',
                                filled: true,
                                fillColor: Colors.black12,
                                prefixIcon: Icon(Icons.search),
                              ),
                              onFieldSubmitted: _onSearch,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          AnimatedOpacity(
                            opacity: _keyword != "" ? 1.0 : 0.5,
                            duration: Duration(milliseconds: 500),
                            child: GestureDetector(
                              onTap: _onCancel,
                              child: Text(
                                _keyword != "" ? 'Cancel' : 'Close',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  _keyword != null || _keyword == '' ? 'Dictionary' : 'Suggested',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              BlocBuilder(
                bloc: _dictionaryBloc,
                builder: (context, state) {
                  if (state is DictionaryLoadedSuccess) {
                    return Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: state.words.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DictionaryDetailScreen(
                                    word: state.words[index],
                                  ),
                                ),
                              );
                            },
                            title: Text('${state.words[index].key}'),
                          );
                        },
                      ),
                    );
                  } else {
                    return Container(
                      height: screenSize.height * 0.8,
                      color: Colors.grey,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Loading ...',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DictionaryDetailScreen extends StatefulWidget {
  Dictionary word;

  DictionaryDetailScreen({this.word});

  @override
  State<StatefulWidget> createState() {
    return _DictionaryDetailScreen();
  }
}

class _DictionaryDetailScreen extends State<DictionaryDetailScreen> {
  Dictionary _word;

  @override
  void initState() {
    super.initState();
    _word = widget.word;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('${_word.key}'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          height: screenSize.height,
          child: Column(
            children: <Widget>[
              Container(
                width: screenSize.width,
                child: Image.network(
                  'https://geology.com/${_word.imageUrl}',
                  fit: BoxFit.fitWidth,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.white,
                height: screenSize.height * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _word.key,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '        ${_word.value}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
