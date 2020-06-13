import 'package:flutter/widgets.dart';

class NewsfeedNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height * 0.79,
      child: Image.asset('assets/images/newsfeed/not_found.png',
      fit: BoxFit.fitWidth),
    );
  }
}