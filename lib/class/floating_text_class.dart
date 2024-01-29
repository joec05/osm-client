import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as lat_long;

class FloatingTextClass {
  String text;
  TextStyle style;
  lat_long.LatLng point;

  FloatingTextClass(
    this.text,
    this.style,
    this.point
  );
}

class FloatingTextNotifier {
  ValueNotifier<FloatingTextClass> notifier;

  FloatingTextNotifier(
    this.notifier
  );
}