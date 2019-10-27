import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hello_lbs_flutter/city.dart';

class MapScreen extends StatefulWidget {

  final List<City> cities;

  MapScreen(this.cities);

  @override
  State<MapScreen> createState() => MapState();
}

class MapState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> citiesMarkers = Set();
  
  static const platform = const MethodChannel('flutter.dev/geolocation');

  Future<void> _geolocation() async {
  try {
    final String result = await platform.invokeMethod('getLocation');
    List<String> positions = result.split(",");

    CameraPosition myLocation = CameraPosition(
      target: LatLng(
        double.parse(positions[0]),
        double.parse(positions[1])
      ),
      zoom: 14.4746,
    );

    final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(myLocation));
    } on PlatformException catch (e) {
      print("recebeu erro ${e.message}'.");
    }
  }


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
        onPressed: (){
          _geolocation();
        },
        child: Icon(Icons.gps_fixed),
      ),
    );
  }

}
