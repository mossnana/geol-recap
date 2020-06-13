import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  @override
  MenuState get initialState => ProjectsMenu();

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if(event is MenuTabbed) {
      yield event.state;
    }
  }
}

// Event
abstract class MenuEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MenuTabbed extends MenuEvent {
  final MenuState state;
  MenuTabbed({this.state});
}

// State
abstract class MenuState extends Equatable {
  final String title = 'Projects';
  const MenuState();

  @override
  List<Object> get props => [];
}

class ProjectsMenu extends MenuState {
  final String title = 'Projects';
}

class DictionaryMenu extends MenuState {
  final String title = 'Dictionary';
}

class NotesMenu extends MenuState {
  final String title = 'Notes';
}

class SettingMenu extends MenuState {
  final String title = 'Settings';
}