import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geol_recap/bloc/menu/menu_bloc.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/models/delegate.dart';
import 'package:geol_recap/screens/notification_screen.dart';
import 'package:geol_recap/widgets/loading_widget.dart';
import 'package:geol_recap/widgets/main_menu_view.dart';
import 'package:geol_recap/widgets/newsfeed/newsfeed.dart';

class HomeScreen extends StatefulWidget {
  final User _userRepository;

  HomeScreen({
    Key key,
    @required User userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  int _navBarMenuIndex = 0;
  MenuBloc _menuBloc;
  User _user = User.init();

  Future<User> getUser() async {
    String uid = widget._userRepository.uid;
    User user = await UserDelegate.getUserFromUid(uid: uid);
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _menuBloc = BlocProvider.of<MenuBloc>(context);
    getUser();
  }

  void onTabTapped(int index) {
    _menuBloc.add(NavBarTabbed(index: index));
    setState(() {
      _navBarMenuIndex = index;
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Do you want to exit ?',
          style: TextStyle(fontSize: 15),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            color: Colors.blue,
            child: Text(
              "No",
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(height: 16),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              "Yes",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    Widget newsfeedFragment() {
      if(_user.isInit) {
        return LoadingWidget();
      } else {
        return NewsfeedFragment(userRepository: _user);
      }
    }
    Widget settingFragment() {
      if(_user.isInit) {
        return LoadingWidget();
      } else {
        return MainMenuView(userRepository: _user);
      }
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer(
            bloc: _menuBloc,
            listener: (context, state) {
              return;
            },
            builder: (context, state) {
              if (state is NewsfeedMenu) {
                // Newsfeed Fragment
                return newsfeedFragment();
              } else if (state is NotificationMenu) {
                // Notification Fragment
                return NotificationScreen(user: _user,);
                // Setting Fragment
              } else {
                return settingFragment();
              }
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _navBarMenuIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
                size: screenSize.width * 0.06,
              ),
              title: Text('NEWSFEED'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.more_horiz,
                size: screenSize.width * 0.06,
              ),
              title: Text('MORE'),
            ),
          ],
        ),
      ),
    );
  }
}
