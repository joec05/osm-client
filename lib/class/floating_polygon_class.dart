import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as lat_long;

class FloatingPolygonClass {
  String text;
  Size size;
  Color color;
  lat_long.LatLng point;

  FloatingPolygonClass(
    this.text,
    this.size,
    this.color,
    this.point
  );
}

class FloatingPolygonNotifier {
  ValueNotifier<FloatingPolygonClass> notifier;

  FloatingPolygonNotifier(
    this.notifier
  );
}