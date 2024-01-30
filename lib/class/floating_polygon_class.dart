import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as lat_long;

class FloatingPolygonClass {
  Color color;
  Color borderColor;
  List<lat_long.LatLng> points;

  FloatingPolygonClass(
    this.borderColor,
    this.color,
    this.points
  );
}

class FloatingPolygonNotifier {
  ValueNotifier<FloatingPolygonClass> notifier;

  FloatingPolygonNotifier(
    this.notifier
  );
}