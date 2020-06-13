import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/models/database.dart';
import 'package:geol_recap/models/dictionary.dart';

// BLoC
class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  @override
  DictionaryState get initialState => DictionaryUnloaded();

  @override
  Stream<DictionaryState> mapEventToState(DictionaryEvent event) async* {
    final database = await OfflineDatabase.db.database;
    if (event is ReadAll) {
      yield DictionaryLoading();
      var result = await database.query('dictionary');
      List<Dictionary> words =
          result.map<Dictionary>((word) => Dictionary.fromJson(word)).toList();
      yield DictionaryLoadedSuccess(words: words);
    } else if (event is SearchWord) {
      yield DictionaryLoading();
      var result = await database.query('dictionary');
      List<Dictionary> words = result
          .map<Dictionary>((word) => Dictionary.fromJson(word))
          .where((word) {
        return word.key.toLowerCase().contains(event.keyword);
      }).toList();
      yield DictionaryLoadedSuccess(words: words);
    } else if (event is LoadWords) {
      yield DictionaryLoading();
      var result = await database.query('dictionary');
      if (result.length == 0) {
        var deleteResult = await database.rawDelete('DELETE FROM dictionary');
        for (var sourceWord in sourceWords) {
          var id = await database.rawInsert(sourceWord);
          print(id);
        }
        result = await database.query('dictionary');
        List<Dictionary> words = result
            .map<Dictionary>((word) => Dictionary.fromJson(word))
            .toList();
        yield DictionaryLoadedSuccess(words: words);
      } else {
        List<Dictionary> words = result
            .map<Dictionary>((word) => Dictionary.fromJson(word))
            .toList();
        yield DictionaryLoadedSuccess(words: words);
      }
    } else if (event is DeleteAll) {
      yield DictionaryLoading();
      var result = await database.rawDelete('DELETE FROM dictionary');
      print(result);
      yield DictionaryUnloaded();
    }
  }
}

// Event
abstract class DictionaryEvent extends Equatable {
  const DictionaryEvent();

  @override
  List<Object> get props => [];
}

class LoadWords extends DictionaryEvent {
  const LoadWords();

  @override
  String toString() {
    return 'First Load Dictionary';
  }
}

class ReadAll extends DictionaryEvent {
  const ReadAll();

  @override
  String toString() {
    return 'Read All Words';
  }
}

class SearchWord extends DictionaryEvent {
  final String keyword;

  const SearchWord({@required this.keyword});

  @override
  String toString() {
    return "Search Word";
  }
}

class DeleteAll extends DictionaryEvent {
  const DeleteAll();

  @override
  String toString() {
    return "Delete Dictionary Table";
  }
}

// State
abstract class DictionaryState extends Equatable {
  const DictionaryState();

  @override
  List<Object> get props => [];
}

class DictionaryUnloaded extends DictionaryState {
  @override
  String toString() {
    return "Dictionary Unloaded State";
  }
}

class DictionaryLoading extends DictionaryState {
  const DictionaryLoading();

  @override
  String toString() {
    return 'Dictionary Loading State';
  }
}

class DictionaryLoadedSuccess extends DictionaryState {
  final List<Dictionary> words;

  const DictionaryLoadedSuccess({this.words});

  @override
  String toString() {
    return "Dictionary Loaded Success State";
  }
}

class DictionaryLoadedFailed {
  final String errorMessage;

  const DictionaryLoadedFailed({this.errorMessage});

  @override
  String toString() {
    return "Dictionary Loaded Failed State";
  }
}
