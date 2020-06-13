import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// BLoC
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  @override
  MenuState get initialState => NewsfeedMenu();

  MenuBloc({MenuState menuState});

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if(event is NavBarTabbed) {
      switch (event.index) {
        case 0:
          yield NewsfeedMenu();
          break;
        case 1:
          yield MoreMenu();
          break;
        case 2:
          yield MoreMenu();
          break;
        default:
          yield NewsfeedMenu();
      }
    }
  }
}

// Event
abstract class MenuEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NavBarInit extends MenuEvent {
  @override
  String toString() {
    return 'NavBarInit';
  }
}

class NavBarTabbed extends MenuEvent {
  final int index;

  NavBarTabbed({
    @required this.index
  });

  @override
  String toString() {
    return 'NavBarTabbed';
  }
}

// State
abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class NewsfeedMenu extends MenuState {
  final int index = 0;
}

class MapMenu extends MenuState {
  final int index = 1;
}

class WriteMenu extends MenuState {
  final int index = 2;
}

class NotificationMenu extends MenuState {
  final int index = 3;
}

class MoreMenu extends MenuState {
  final int index = 4;
}
