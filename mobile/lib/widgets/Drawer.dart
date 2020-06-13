import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolrecap/blocs/MenuBloc.dart';
import 'package:geolrecap/helpers/DatabaseDelegate.dart';

class GRDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          GRDrawerHeader(),
          ListTile(
            title: Text('Projects'),
            onTap: () {
              BlocProvider.of<MenuBloc>(context)
                  .add(MenuTabbed(state: ProjectsMenu()));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Notes'),
            onTap: () {
              BlocProvider.of<MenuBloc>(context)
                  .add(MenuTabbed(state: NotesMenu()));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              BlocProvider.of<MenuBloc>(context)
                  .add(MenuTabbed(state: SettingMenu()));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class GRDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TableUserDelegate.get(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Text('Loading'),
              );
            default:
              if (snapshot.hasData) {
                if (snapshot.data.length != 0) {
                  return DrawerHeader(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            backgroundColor: Colors.purpleAccent,
                            radius: 40.0,
                            child: Image.asset('assets/images/logo.png'),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${snapshot.data[0]['name']}',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight + Alignment(0, .5),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                '${snapshot.data[0]['role']}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                  );
                } else {
                  return DrawerHeader(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            radius: 50.0,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '-',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight + Alignment(0, .5),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Field Mapper',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                  );
                }
              } else {
                return Center(
                  child: Text('Loading'),
                );
              }
          }
        });
  }
}
