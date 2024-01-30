import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:osm_client/class/floating_circle_class.dart';
import 'package:osm_client/class/floating_line_class.dart';
import 'package:osm_client/class/floating_polygon_class.dart';
import 'package:osm_client/class/floating_text_class.dart';

class GlobalDataClass {
  late MapController mapController;
  double latitude = 0;
  double longitude = 0;
  double mapZoom = 12.5;
  ValueNotifier<List<FloatingTextNotifier>> texts = ValueNotifier([]);
  ValueNotifier<List<FloatingCircleNotifier>> circles = ValueNotifier([]);
  ValueNotifier<List<FloatingPolygonNotifier>> polygons = ValueNotifier([]);
  ValueNotifier<List<FloatingLineNotifier>> lines = ValueNotifier([]);
}

final globalData = GlobalDataClass();