import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as lat_long;

class FloatingLineClass {
  Color color;
  List<lat_long.LatLng> points;

  FloatingLineClass(
    this.color,
    this.points
  );
}

class FloatingLineNotifier {
  ValueNotifier<FloatingLineClass> notifier;

  FloatingLineNotifier(
    this.notifier
  );
}