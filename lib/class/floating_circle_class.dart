import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as lat_long;

class FloatingCircleClass {
  double radius;
  Color color;
  Color borderColor;
  lat_long.LatLng point;

  FloatingCircleClass(
    this.radius,
    this.color,
    this.borderColor,
    this.point
  );
}

class FloatingCircleNotifier {
  ValueNotifier<FloatingCircleClass> notifier;

  FloatingCircleNotifier(
    this.notifier
  );
}