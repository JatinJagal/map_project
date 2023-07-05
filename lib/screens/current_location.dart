import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {

  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPotion = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962),zoom: 14);

  Set<Marker> marker = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Location'),
        centerTitle: true,
      ),
      body: GoogleMap(initialCameraPosition: initialCameraPotion,markers: marker,zoomControlsEnabled: false,
        mapType: MapType.satellite,
        onMapCreated: (GoogleMapController controller){
          googleMapController = controller;
        },),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()async{
        Position position = await _diterminePosition();

        googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 14)));

        marker.clear();
        
        marker.add(Marker(markerId: MarkerId('current location'),position: LatLng(position.latitude, position.longitude)));

        setState(() {
        });
      },
          label: Text('My Location')),
    );
  }

  Future<Position> _diterminePosition() async{

    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled){
      return Future.error('Location services are disable');
    }

    var permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){

      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied){
          return Future.error("Location permission denied");
      }
    }

    if(permission == LocationPermission.deniedForever){

      return Future.error("Permently denied");

    }

    Position position = await Geolocator.getCurrentPosition();

    return position;

  }

}

