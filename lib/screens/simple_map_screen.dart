import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class SimpleMapScreen extends StatefulWidget {
  const SimpleMapScreen({Key? key}) : super(key: key);

  @override
  State<SimpleMapScreen> createState() => _SimpleMapScreenState();
}

class _SimpleMapScreenState extends State<SimpleMapScreen> {

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition initialPosition = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962),zoom: 14.0);

  static const CameraPosition targetPosition = CameraPosition(target: LatLng(37.43296265331129, -122.08832357078792),zoom: 14.0,bearing: 192.0,tilt: 60);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
        centerTitle: true,
      ),
      body: GoogleMap(initialCameraPosition: initialPosition,mapType: MapType.satellite,onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
      },),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          gotoLake();
        },
        label: Text('My Location'),
        icon: Icon(Icons.directions),),
    );
  }

  Future<void> gotoLake() async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(targetPosition));
  }

}
