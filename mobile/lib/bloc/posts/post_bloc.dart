import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geol_recap/models/collection.dart';

// BLoC
class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc();

  bool _hasReachedMax(PostState state) => state is PostLoadedSuccess && state.isEnding;

  @override
  PostState get initialState => PostUnloaded();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    final currentState = state;
    if(event is FetchPost && !_hasReachedMax(currentState)) {
      try {
        if(currentState is PostUnloaded) {
        }
      } catch(error) {

      }
    }
    yield null;
  }
}

// Event
abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPost extends PostEvent {
  @override
  String toString() {
    return 'Fetching Posts';
  }
}

// State
abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostUnloaded extends PostState {

  @override
  String toString() {
    return "Post Unloaded State";
  }
}

class PostLoadedSuccess extends PostState {
  final List<Post> posts;
  final bool isEnding;

  const PostLoadedSuccess({this.posts, this.isEnding});

  PostLoadedSuccess copyWith({
    List<Post> posts,
    bool isEnding
  }) => PostLoadedSuccess(
    posts: posts ?? this.posts,
    isEnding: isEnding ?? this.isEnding,
  );

  @override
  String toString() {
    return "Post Loaded Success State";
  }

}

class PostLoadedFailed {
  final String errorMessage;

  const PostLoadedFailed({this.errorMessage});

  @override
  String toString() {
    return "Post Loaded Failed State";
  }
}