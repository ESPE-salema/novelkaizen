import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;

class LocationWidget extends StatefulWidget {
  const LocationWidget({Key? key}) : super(key: key);

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final Completer<GoogleMapController> _controller = Completer();

  late final CameraPosition _userPosition = const CameraPosition(
    target: LatLng(-0.9333, -78.6185),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.location_on_outlined),
      title: const Text("Ubicación"),
      children: <Widget>[
        Column(
          children: [
            SizedBox(
              height: 400.0,
              child: GoogleMap(
                // ignore: prefer_collection_literals
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer())
                ].toSet(),
                mapType: MapType.normal,
                markers: markers.values.toSet(),
                myLocationEnabled: true,
                initialCameraPosition: _userPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ), /*trailing: Switch(value: mainProvider.mode, onChanged: onChanged)*/
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _checkPermission,
          child: const Text('Verificar permisos'),
        ),
      ],
    );
  }

  Future<void> _checkPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      developer
          .log('Active los servicios de ubicación antes de solicitar permiso.');
      return;
    }

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      developer.log('Permiso concedido.');
    } else if (status == PermissionStatus.denied) {
      developer.log(
          'Permiso denegado. Mostrar un cuadro de diálogo y volver a pedir el permiso.');
    } else if (status == PermissionStatus.permanentlyDenied) {
      developer.log('Lleve al usuario a la página de configuración.');
      await openAppSettings();
    }
  }
}
