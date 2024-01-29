import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as lat_long;
import 'package:osm_client/appdata/global_functions.dart';
import 'package:osm_client/class/global_data.dart';
import 'package:osm_client/icons/coordinate_point.dart';
import 'package:osm_client/widgets/bottom_navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController latitudeTextController = TextEditingController();
  TextEditingController longitudeTextController = TextEditingController();
  List polygons = [];
  List polylines = [];
  List circles = [];

  @override
  void initState(){
    super.initState();
    globalData.mapController = MapController();
    initializeMapPosition();
  }

  void initializeMapPosition() async{
    Position pos = await _determinePosition();
    setState(() {
      globalData.latitude = pos.latitude;
      globalData.longitude = pos.longitude;
    });
    globalData.mapController.move(
      lat_long.LatLng(
        globalData.latitude, 
        globalData.longitude
      ), 
      globalData.mapZoom
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  

  @override
  Widget build(BuildContext context) {
    print(globalData.latitude);
    print(globalData.longitude);
    return Scaffold(
      bottomNavigationBar: const BottomActionsWidget(),
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: globalData.mapController,
              options: MapOptions(
                initialCenter: const lat_long.LatLng(0, 0),
                initialZoom: globalData.mapZoom,
                onTap: (position, latLng){
                  print(position);
                  print(latLng.latitude);
                  print(latLng.longitude);
                  setState((){
                    globalData.latitude = latLng.latitude;
                    globalData.longitude = latLng.longitude;
                  });
                }
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                ValueListenableBuilder(
                  valueListenable: globalData.texts,
                  builder: (context, textsList, child){
                    return MarkerLayer(
                      markers: [
                        for(int i = 0; i < textsList.length; i++)
                        Marker(
                          point: lat_long.LatLng(
                            textsList[i].notifier.value.point.latitude, 
                            textsList[i].notifier.value.point.longitude
                          ),
                          width: getTextSize(
                            textsList[i].notifier.value.text, 
                            textsList[i].notifier.value.style
                          ).width,
                          height: getTextSize(
                            textsList[i].notifier.value.text, 
                            textsList[i].notifier.value.style
                          ).height,
                          child: Text(
                            textsList[i].notifier.value.text,
                            style: textsList[i].notifier.value.style
                          )
                        ),
                      ]
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: globalData.circles,
                  builder: (context, circlesList, child){
                    return CircleLayer(
                      circles: [
                        for(int i = 0; i < circlesList.length; i++)
                        CircleMarker(
                          point: lat_long.LatLng(
                            circlesList[i].notifier.value.point.latitude,
                            circlesList[i].notifier.value.point.longitude
                          ),
                          radius: circlesList[i].notifier.value.radius,
                          useRadiusInMeter: true,
                          color: circlesList[i].notifier.value.color,
                          borderColor: circlesList[i].notifier.value.borderColor,
                          borderStrokeWidth: 2,
                        )
                      ],
                    );
                  },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: lat_long.LatLng(
                        globalData.latitude, 
                        globalData.longitude
                      ),
                      width: 25,
                      height: 25,
                      child: Transform.translate(
                        offset: const Offset(
                          -15,
                          -15
                        ),
                        child: CustomPaint(painter: CoordinatePoint())
                      ),
                    ),
                  ],
                ),
                /*
                PolygonLayer(
                  polygonCulling: false,
                  polygons: [
                    Polygon(
                      points: [
                        lat_long.LatLng(36.95, -9.5),
                        lat_long.LatLng(42.25, -9.5),
                        lat_long.LatLng(42.25, -6.2),
                      ],
                      color: Colors.red.withOpacity(0.5),
                      borderStrokeWidth: 2,
                      borderColor: Colors.blue,
                      isFilled: true
                    ),
                  ],
                )
                */
              ],
            ),
            Positioned(
              top: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getScreenWidth() * 0.025,
                  vertical: getScreenHeight() * 0.02
                ),
                width: getScreenWidth(),
                color: Colors.teal,
                child: Column(
                  children: [
                    TextField(
                      controller: latitudeTextController,
                      keyboardType: TextInputType.numberWithOptions(),
                      onEditingComplete: (){
                        if(double.tryParse(latitudeTextController.text) != null){
                          double newLatitude = double.parse(latitudeTextController.text);
                          if(newLatitude > -90 && newLatitude < 90){
                            setState(() => globalData.latitude = newLatitude);
                            globalData.mapController.move(
                              lat_long.LatLng(
                                globalData.latitude, 
                                globalData.longitude
                              ), 
                              globalData.mapZoom
                            );
                          }else{
                            showSnackBar(context, 'Latitude should be between -90 and 90');
                          }
                        }else{
                          showSnackBar(context, 'Invalid value');
                        }
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
                        fillColor: Color.fromARGB(255, 143, 132, 132),
                        filled: true,
                        border: InputBorder.none,
                        hintText: 'Enter latitude',
                      )
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.015
                    ),
                    TextField(
                      controller: longitudeTextController,
                      keyboardType: TextInputType.numberWithOptions(),
                      onEditingComplete: (){
                        if(double.tryParse(longitudeTextController.text) != null){
                          double newLongitude = double.parse(longitudeTextController.text);
                          if(newLongitude > -180 && newLongitude < 180){
                            setState(() => globalData.longitude = newLongitude);
                            globalData.mapController.move(
                              lat_long.LatLng(
                                globalData.latitude, 
                                globalData.longitude
                              ), 
                              globalData.mapZoom
                            );
                          }else{
                            showSnackBar(context, 'Latitude should be between -90 and 90');
                          }
                        }else{
                          showSnackBar(context, 'Invalid value');
                        }
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
                        fillColor: Color.fromARGB(255, 143, 132, 132),
                        filled: true,
                        border: InputBorder.none,
                        hintText: 'Enter longitude',
                      )
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}