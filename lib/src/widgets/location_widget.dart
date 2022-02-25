import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:novelkaizen/src/theme/app_theme.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:rxdart/subjects.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({Key? key}) : super(key: key);

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  final Set<Marker> _markers = <Marker>{};
  late GoogleMapController mapController;
  late Location location = Location();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geoFire = Geoflutterfire();

  BehaviorSubject<double> radius = BehaviorSubject();
  late Stream<dynamic> query;

  late CameraPosition _userPosition = const CameraPosition(
    target: LatLng(-0.225219, -78.5248),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();
    _initCameraPosition;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return ExpansionTile(
          leading: const Icon(Icons.location_on_outlined),
          title: const Text("Ubicación"),
          children: <Widget>[
            Column(
              children: [
                Stack(children: [
                  SizedBox(
                    height: 400.0,
                    child: GoogleMap(
                      // ignore: prefer_collection_literals
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                        Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer())
                      ].toSet(),
                      mapType: MapType.normal,
                      markers: _markers.toSet(),
                      myLocationEnabled: true,
                      initialCameraPosition: _userPosition,
                      onMapCreated: _onMapCreated,
                    ), /*trailing: Switch(value: mainProvider.mode, onChanged: onChanged)*/
                  ),
                  Positioned(
                    bottom: 12,
                    right: 60,
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: _addMarker,
                      color: Palette.color,
                      child: const Icon(
                        Icons.pin_drop_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  /*Positioned(
                          bottom: 50,
                          left: 10,
                          child: Slider(
                            value: radius.value,
                            activeColor: Palette.color,
                            inactiveColor: Palette.color.withOpacity(0.2),
                            onChanged: _updateQuery,
                          ))*/
                ]),
              ],
            ),
          ],
        );
      }
    );
  }

  _initCameraPosition() async {
    var pos = await location.getLocation();
    setState(() {
      _userPosition = CameraPosition(
        target: LatLng(pos.latitude!, pos.longitude!),
        zoom: 16,
      );
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  _addMarker() async {
    var pos = await location.getLocation();

    var marker = Marker(
      markerId: MarkerId('$pos.latitude' '$pos.longitude'),
      position: LatLng(pos.latitude!, pos.longitude!),
      icon: BitmapDescriptor.defaultMarker,
    );
    setState(() {
      _markers.add(marker);
    });
  }

  Future<DocumentReference> _addGeoPoint() async {
    var pos = await location.getLocation();
    GeoFirePoint point =
        geoFire.point(latitude: pos.latitude!, longitude: pos.longitude!);

    return firestore.collection('locations').add({
      'position': point.data,
    });
  }
}
