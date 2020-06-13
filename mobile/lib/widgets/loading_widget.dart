import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: FlareActor(
          'assets/animations/loading.flr',
          alignment: Alignment.center,
          fit: BoxFit.cover,
          animation: 'active',
        ),
      ),
    );
  }
}