import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geol_recap/bloc/authentication/authentication_bloc.dart';
import 'package:geol_recap/bloc/menu/menu_bloc.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/screens/splash_screen.dart';
import 'package:geol_recap/screens/home_screen.dart';
import 'package:geol_recap/screens/login_screen.dart';
import 'package:geol_recap/bloc/dictionary/dictionary_bloc.dart';

void main() {
  // Call latest instance app.
  WidgetsFlutterBinding.ensureInitialized();
  // Declare new user repository in init app.
  final UserRepository userRepository = UserRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
              userRepository: userRepository
          )..add(AppStarted()),
        ),
        BlocProvider<DictionaryBloc>(
          create: (context) => DictionaryBloc(),
        ),
      ],
      child: GeolRecap(userRepository: userRepository,),
    )
  );
}

class GeolRecap extends StatelessWidget {
  final UserRepository _userRepository;

  GeolRecap({
    Key key,
    @required UserRepository userRepository
  }) : assert(userRepository != null), _userRepository = userRepository, super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        backgroundColor: Colors.white,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700
          ),
          subtitle: TextStyle(
              color: Colors.black45,
              fontSize: 14,
          ),
          button: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          headline: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20
            )
          )
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(10.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black45,
              width: 1.0,
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Unauthenticated) {
              return LoginScreen(userRepository: _userRepository);
            }
            if (state is Authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<MenuBloc>(
                    create: (context) => MenuBloc(),
                  )
                ],
                child: state is Unauthenticated ? LoginScreen(userRepository: _userRepository) : HomeScreen(userRepository: state.userRepository,),
              );
            }
            return SplashScreen();
          },
        ),
      },
    );
  }
}
