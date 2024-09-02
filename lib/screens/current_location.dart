import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  MapType type = MapType.normal;

  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPotion = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  Set<Marker> marker = {};

  //new
  String? _address;
  void _handleTap(LatLng tappedPoint) async {
    setState(() {
      marker = {};
      marker.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          infoWindow: InfoWindow(
            title: 'New Marker',
            snippet: '${tappedPoint.latitude}, ${tappedPoint.longitude}',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        tappedPoint.latitude,
        tappedPoint.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _address =
              " ${place.street}"; //${place.street}, ${place.subLocality},
        });
        print(_address); // Print the address to console
      }
    } catch (e) {
      print("Failed to get address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _address != null ? Text(_address!) : const Text("Location"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPotion,
        markers: marker,
        mapToolbarEnabled: false,
        indoorViewEnabled: true,
        zoomControlsEnabled: false,
        mapType: type, //MapType.satellite
        fortyFiveDegreeImageryEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        onTap: _handleTap,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  type = MapType.satellite;
                });
              },
              child: const Text("Setellite")),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  type = MapType.normal;
                });
              },
              child: const Text("Normal")),
          FloatingActionButton.extended(
              onPressed: () async {
                Position position = await _diterminePosition();

                googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 14)));

                marker.clear();

                marker.add(Marker(
                    markerId: const MarkerId('current location'),
                    position: LatLng(position.latitude, position.longitude)));

                setState(() {});
              },
              label: const Text('My Location')),
        ],
      ),
    );
  }

  Future<Position> _diterminePosition() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disable');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Permently denied");
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
