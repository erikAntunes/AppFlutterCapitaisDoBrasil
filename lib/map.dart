import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'City.dart';


class MapScreen extends StatefulWidget {
  final List<City> cities;

  MapScreen(this.cities);

  @override
  State<MapScreen> createState() => MapState();
}

class MapState extends State<MapScreen> {

  Set<Marker> citiesMarkers = Set();

  @override
  void initState() {
    for (City city in widget.cities){
      citiesMarkers.add(
          Marker(
            markerId: MarkerId(city.name),
            position: LatLng(
              city.latitude,
              city.longitude,
            ),
            infoWindow: InfoWindow(
                title: city.name,
                snippet: city.state),
          ));
    }

    super.initState();
  }

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kFiap = CameraPosition(
    target: LatLng(-23.595439, -46.685302),
    zoom: 14.4746,
  );



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kFiap,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: citiesMarkers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},

        child: Icon(Icons.gps_fixed),
      ),
    );
  }

}
