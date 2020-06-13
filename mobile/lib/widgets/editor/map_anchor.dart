import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapAnchor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapAnchor();
  }
}

class _MapAnchor extends State<MapAnchor> {
  final Map<String, Marker> _markers = {};
  GoogleMapController mapController;
  CameraPosition centerPosition;

  // Get Location
  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 20.0,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              onCameraMove: (position) {
                setState(() {
                  centerPosition = position;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(13.748812, 100.501277),
                zoom: _markers == null ? 11 : 17,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              myLocationEnabled: true,
            ),
            Center(
              child: Image.asset(
                'assets/images/editor/pin.png',
                width: 50,
              ),
            ),
            Positioned(
              bottom: screenSize.height * 0.1,
              left: screenSize.width * 0.3,
              child: Opacity(
                opacity: 0.7,
                child: FlatButton(
                  color: Colors.red,
                  padding: EdgeInsets.all(20),
                  child: Text('Select this location', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                  onPressed: () {
                    Navigator.of(context).pop(centerPosition);
                  },
                ),
              ),
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'Get Location',
        child: Icon(Icons.pin_drop),
      ),
    );
  }
}
