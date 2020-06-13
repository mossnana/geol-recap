import 'package:flutter/material.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/models/delegate.dart';
import 'package:geol_recap/widgets/loading_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExploreFragment extends StatefulWidget {
  User userRepository;
  ExploreFragment({this.userRepository});
  @override
  State<StatefulWidget> createState() {
    return _ExploreFragment();
  }
}

class _ExploreFragment extends State<ExploreFragment> {
  LatLng _center = const LatLng(13.824147, 100.554139);
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: MapDelegate.getAllPostPosition(context: context, user: widget.userRepository),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done:
              return GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers: snapshot.data,
              );
            default:
              return LoadingWidget();
          }
        },
      ),
    );
  }
}