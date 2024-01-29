import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as lat_long;

class FloatingLineClass {
  String text;
  double width;
  Color color;
  lat_long.LatLng point;

  FloatingLineClass(
    this.text,
    this.width,
    this.color,
    this.point
  );
}

class FloatingLineNotifier {
  ValueNotifier<FloatingLineClass> notifier;

  FloatingLineNotifier(
    this.notifier
  );
}