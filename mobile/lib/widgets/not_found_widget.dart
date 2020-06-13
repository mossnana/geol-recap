import 'package:flutter/material.dart';

class NotFoundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Icon(Icons.sentiment_dissatisfied, size: 30,),
          Text('Can not connect to server')
        ],
      ),
    );
  }
}