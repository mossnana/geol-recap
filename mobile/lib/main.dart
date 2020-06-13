import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolrecap/blocs/MenuBloc.dart';
import 'package:geolrecap/models/Database.dart';
import 'package:geolrecap/screens/NotesView.dart';
import 'package:geolrecap/widgets/Editor.dart';
import 'package:geolrecap/screens/ProjectView.dart';
import 'package:geolrecap/screens/SettingsView.dart';
import 'package:geolrecap/widgets/Drawer.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MenuBloc>(
          create: (context) => MenuBloc(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Geol Recap',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          textTheme: TextTheme(
            display1: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
            display2: TextStyle(
                fontSize: 14, color: Colors.black26),
            display3: TextStyle(
                fontSize: 16, color: Colors.black),
            title: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
          ),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.purpleAccent,
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {'/': (context) => MainScaffold()},
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScaffold();
  }
}

class _MainScaffold extends State<MainScaffold> {
  String title = 'Projects';
  MenuState state;

  @override
  Widget build(BuildContext context) {
    List<Widget> appBarActions() {
      if (state is DictionaryMenu) {
        return [];
      } else if (state is NotesMenu) {
        return [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GRNoteEditor(),
                ),
              );
            },
          ),
        ];
      } else if (state is SettingMenu) {
        return [];
      } else {
        return [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewProjectView(),
                ),
              );
            },
          ),
        ];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        actions: appBarActions(),
      ),
      body: BlocConsumer<MenuBloc, MenuState>(
        listener: (context, state) {
          setState(() {
            this.state = state;
            this.title = state.title;
          });
        },
        builder: (context, state) {
          if (state is DictionaryMenu) {
            return GRTextEditor();
          } else if (state is NotesMenu) {
            return NoteListView();
          } else if (state is SettingMenu) {
            return SettingsView();
          } else {
            return ProjectListView();
          }
        },
      ),
      drawer: GRDrawer(),
    );
  }
}
