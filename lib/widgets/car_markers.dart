import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/car_model.dart';

Future<BitmapDescriptor> _createEmojiMarker(String emoji) async {
  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(pictureRecorder);
  final textPainter = TextPainter(
    text: TextSpan(text: emoji, style: const TextStyle(fontSize: 40)),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(canvas, const Offset(0, 0));
  final img = await pictureRecorder.endRecording().toImage(80, 80);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
}

Future<Set<Marker>> buildCarMarkers(
  List<CarModel> cars,
  void Function(CarModel car) onTap,
) async {
  final Set<Marker> markers = {};

  for (final car in cars) {
    final isMoving = car.status.toLowerCase() == 'moving';
    final emoji = isMoving ? '🟢🛻' : '🟥🛑';
    final icon = await _createEmojiMarker(emoji);

    markers.add(
      Marker(
        markerId: MarkerId(car.id),
        position: LatLng(car.latitude, car.longitude),
        icon: icon,
        infoWindow: InfoWindow(title: car.name),
        onTap: () => onTap(car),
      ),
    );
  }

  return markers;
}
