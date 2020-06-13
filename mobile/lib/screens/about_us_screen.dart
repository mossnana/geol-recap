import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage('https://avatars2.githubusercontent.com/u/38369861?s=460&v=4'),
                radius: 50,
              ),
              SizedBox(height: 20,),
              Text('Permpoon Chaowanaphunphon')
            ],
          ),
        ),
      ),
    );
  }
}