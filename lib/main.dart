import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as lat_long;
import 'package:osm_client/appdata/global_functions.dart';
import 'package:osm_client/appdata/global_variables.dart';
import 'package:osm_client/class/floating_circle_class.dart';
import 'package:osm_client/class/floating_line_class.dart';
import 'package:osm_client/class/floating_polygon_class.dart';
import 'package:osm_client/class/floating_text_class.dart';
import 'package:osm_client/class/global_data.dart';
import 'package:osm_client/icons/coordinate_point.dart';
import 'package:osm_client/widgets/bottom_navigator.dart';
import 'package:osm_client/widgets/custom_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Maps',
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

  void editTextDialog(int index, FloatingTextNotifier data){
    if(mounted){
      TextEditingController textController = TextEditingController(
        text: data.notifier.value.text
      );
      TextEditingController fontController = TextEditingController(
        text: data.notifier.value.style.fontSize.toString()
      );
      double fontSize = data.notifier.value.style.fontSize!;
      Color color = data.notifier.value.style.color!;
      FontWeight boldValue = data.notifier.value.style.fontWeight!;

      showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setState){
              return Dialog(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: getScreenWidth() * 0.02
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: getScreenHeight() * 0.015
                        ),
                        const Text('Edit Text', style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700
                        )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: getScreenHeight() * 0.02
                            ),
                            TextField(
                              controller: textController,
                              decoration: InputDecoration(
                                counterText: "",
                                contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
                                fillColor: const Color.fromARGB(255, 143, 132, 132),
                                filled: true,
                                border: InputBorder.none,
                                hintText: 'Enter text',
                              )
                            ),
                            SizedBox(
                              height: getScreenHeight() * 0.02
                            ),
                            const Text('Select text font value', style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500
                            )),
                            TextField(
                              controller: fontController,
                              readOnly: true,
                              decoration: InputDecoration(
                                counterText: "",
                                contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
                                fillColor: const Color.fromARGB(255, 143, 132, 132),
                                filled: true,
                                border: InputBorder.none,
                                hintText: 'Enter font size',
                                prefixIcon: IconButton(
                                  onPressed: (){
                                    if(fontSize > 14){
                                      fontSize -= 0.5;
                                      fontController.text = fontSize.toString();
                                    }
                                  },
                                  icon: const Icon(Icons.remove)
                                ),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    if(fontSize < 23){
                                      fontSize += 0.5;
                                      fontController.text = fontSize.toString();
                                    }
                                  },
                                  icon: const Icon(Icons.add)
                                )
                              )
                            ),
                            SizedBox(
                              height: getScreenHeight() * 0.02
                            ),
                            const Text('Select text bold value', style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500
                            )),
                            DropdownButton( 
                              // Initial Value 
                              value: boldValue, 
                              // Down Arrow Icon 
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: List<DropdownMenuItem>.from(FontWeight.values.map((FontWeight items) { 
                                return DropdownMenuItem<FontWeight>( 
                                  value: items, 
                                  child: Text(items.value.toString()), 
                                ); 
                              }).toList()),
                              onChanged: (newValue) {  
                                print(newValue);
                                setState(() => boldValue = newValue); 
                              }, 
                            ), 
                            SizedBox(
                              height: getScreenHeight() * 0.02
                            ),
                            const Text('Select text color', style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500
                            )),
                            SizedBox(
                              height: getScreenHeight() * 0.075,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: colorsList.length,
                                itemBuilder: (context, index){
                                  return Container(
                                    padding: EdgeInsets.only(
                                      right: getScreenWidth() * 0.015
                                    ),
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() => color = colorsList[index]);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorsList[index],
                                          border: color == colorsList[index] ?
                                            Border.all(
                                              width: 2,
                                              color: const Color.fromARGB(255, 116, 108, 108)
                                            )
                                          : null
                                        ),
                                        width: getScreenWidth() * 0.1,
                                        height: getScreenWidth() * 0.1
                                      ),
                                    )
                                  );
                                },
                              )
                            ),
                            SizedBox(
                              height: getScreenHeight() * 0.02
                            ),
                          ],
                        ),
                        CustomButton(
                          width: getScreenWidth() * 0.6, 
                          height: getScreenHeight() * 0.07, 
                          buttonColor: Colors.orange, 
                          buttonText: 'Edit Text', 
                          onTapped: (){
                            if(textController.text.trim().isNotEmpty){
                              List<FloatingTextNotifier> texts = [...globalData.texts.value];
                              globalData.texts.value[index].notifier.value = FloatingTextClass(
                                textController.text, 
                                TextStyle(
                                  fontSize: fontSize,
                                  color: color,
                                  fontWeight: boldValue
                                ), 
                                texts[index].notifier.value.point
                              );
                              Navigator.of(dialogContext).pop();
                            }else{
                              showSnackBar(context, 'Text cannot be empty');
                            }
                          }, 
                          setBorderRadius: true
                        ),
                        SizedBox(
                          height: getScreenHeight() * 0.015
                        ),
                      ]
                    ),
                  ),
                )
              );
            }
          );
        }
      );
    }
  }

  void editCircleDialog(int index, FloatingCircleNotifier data){
    if(mounted){
      TextEditingController radiusController = TextEditingController(
        text: data.notifier.value.radius.toString()
      );
      Color fillColor = data.notifier.value.color;
      Color borderColor = data.notifier.value.borderColor;
      showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setState){
              return Dialog(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: getScreenWidth() * 0.02
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: getScreenHeight() * 0.015
                        ),
                        const Text('Edit Circle', style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700
                        )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: getScreenHeight() * 0.02
                            ),
                            TextField(
                              controller: radiusController,
                              keyboardType: const TextInputType.numberWithOptions(),
                              decoration: InputDecoration(
                                counterText: "",
                                contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
                                fillColor: const Color.fromARGB(255, 143, 132, 132),
                                filled: true,
                                border: InputBorder.none,
                                hintText: 'Enter radius',
                              )
                            ),
                            SizedBox(
                              height: getScreenHeight() * 0.02
                            ),
                            const Text('Select circle color', style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500
                            )),
                            SizedBox(
                              height: getScreenHeight() * 0.075,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: colorsList.length,
                                itemBuilder: (context, index){
                                  return Container(
                                    padding: EdgeInsets.only(
                                      right: getScreenWidth() * 0.015
                                    ),
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() => fillColor = colorsList[index]);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorsList[index],
                                          border: fillColor == colorsList[index] ?
                                            Border.all(
                                              width: 2,
                                              color: const Color.fromARGB(255, 116, 108, 108)
                                            )
                                          : null
                                        ),
                                        width: getScreenWidth() * 0.1,
                                        height: getScreenWidth() * 0.1
                                      ),
                                    )
                                  );
                                },
                              )
                            ),
                            SizedBox(
                              height: getScreenHeight() * 0.02
                            ),
                            const Text('Select border color', style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500
                            )),
                            SizedBox(
                              height: getScreenHeight() * 0.075,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: colorsList.length,
                                itemBuilder: (context, index){
                                  return Container(
                                    padding: EdgeInsets.only(
                                      right: getScreenWidth() * 0.015
                                    ),
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() => borderColor = colorsList[index]);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorsList[index],
                                          border: borderColor == colorsList[index] ?
                                            Border.all(
                                              width: 2,
                                              color: const Color.fromARGB(255, 116, 108, 108)
                                            )
                                          : null
                                        ),
                                        width: getScreenWidth() * 0.1,
                                        height: getScreenWidth() * 0.1
                                      ),
                                    )
                                  );
                                },
                              )
                            ),
                            SizedBox(
                              height: getScreenHeight() * 0.02
                            ),
                          ]
                        ),
                        CustomButton(
                          width: getScreenWidth() * 0.6, 
                          height: getScreenHeight() * 0.07, 
                          buttonColor: Colors.orange, 
                          buttonText: 'Edit Circle', 
                          onTapped: (){
                            if(double.tryParse(radiusController.text) != null){
                              List<FloatingCircleNotifier> circles = [...globalData.circles.value];
                              globalData.circles.value[index].notifier.value = FloatingCircleClass(
                                double.parse(radiusController.text),
                                fillColor, 
                                borderColor, 
                                circles[index].notifier.value.point
                              );
                              Navigator.of(dialogContext).pop();
                            }else{
                              showSnackBar(context, 'Invalid value');
                            }
                          }, 
                          setBorderRadius: true
                        ),
                        SizedBox(
                          height: getScreenHeight() * 0.015
                        ),
                      ]
                    )
                  )
                )
              );
            }
          );
        }
      );
    }
  }
  
  void editPolygonDialog(int index, FloatingPolygonNotifier data){
    if(mounted){
      List<TextEditingController> latitudeControllers = data.notifier.value.points.map((e) => TextEditingController(
        text: e.latitude.toString()
      )).toList();
      List<TextEditingController> longitudeControllers = data.notifier.value.points.map((e) => TextEditingController(
        text: e.longitude.toString()
      )).toList();
      Color borderColor = data.notifier.value.borderColor;
      Color color = data.notifier.value.color;
      showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setState){
              return Dialog(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: getScreenWidth() * 0.02
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getScreenHeight() * 0.015
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Add Polygon', style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: getScreenHeight() * 0.02
                              ),
                              for(int i = 0; i < latitudeControllers.length; i++)
                              Column(
                                children: [
                                  SizedBox(
                                    height: getScreenHeight() * 0.015
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Side ${i+1}', style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                      )),
                                      IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: (){
                                          setState((){
                                            latitudeControllers.removeAt(i);
                                            longitudeControllers.removeAt(i);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  TextField(
                                    controller: latitudeControllers[i],
                                    keyboardType: const TextInputType.numberWithOptions(),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
                                      fillColor: const Color.fromARGB(255, 143, 132, 132),
                                      filled: true,
                                      border: InputBorder.none,
                                      hintText: 'Enter latitude',
                                    )
                                  ),
                                  SizedBox(
                                    height: getScreenHeight() * 0.01
                                  ),
                                  TextField(
                                    controller: longitudeControllers[i],
                                    keyboardType: const TextInputType.numberWithOptions(),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
                                      fillColor: const Color.fromARGB(255, 143, 132, 132),
                                      filled: true,
                                      border: InputBorder.none,
                                      hintText: 'Enter longitude',
                                    )
                                  )
                                ],
                              ),
                            ]
                          ),
                          SizedBox(
                            height: getScreenHeight() * 0.02
                          ),
                          CustomButton(
                            width: getScreenWidth() * 0.6, 
                            height: getScreenHeight() * 0.07, 
                            buttonColor: Colors.orange, 
                            buttonText: 'Add Side', 
                            onTapped: (){
                              setState((){
                                latitudeControllers.add(TextEditingController());
                                longitudeControllers.add(TextEditingController());
                              });
                            }, 
                            setBorderRadius: true
                          ),
                          SizedBox(
                            height: getScreenHeight() * 0.02
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select polygon color', style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500
                              )),
                              SizedBox(
                                height: getScreenHeight() * 0.075,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: colorsList.length,
                                  itemBuilder: (context, index){
                                    return Container(
                                      padding: EdgeInsets.only(
                                        right: getScreenWidth() * 0.015
                                      ),
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() => color = colorsList[index]);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colorsList[index],
                                            border: color == colorsList[index] ?
                                              Border.all(
                                                width: 2,
                                                color: const Color.fromARGB(255, 116, 108, 108)
                                              )
                                            : null
                                          ),
                                          width: getScreenWidth() * 0.1,
                                          height: getScreenWidth() * 0.1
                                        ),
                                      )
                                    );
                                  },
                                )
                              ),
                              SizedBox(
                                height: getScreenHeight() * 0.02
                              ),
                              const Text('Select polygon border color', style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500
                              )),
                              SizedBox(
                                height: getScreenHeight() * 0.075,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: colorsList.length,
                                  itemBuilder: (context, index){
                                    return Container(
                                      padding: EdgeInsets.only(
                                        right: getScreenWidth() * 0.015
                                      ),
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() => borderColor = colorsList[index]);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colorsList[index],
                                            border: borderColor == colorsList[index] ?
                                              Border.all(
                                                width: 2,
                                                color: const Color.fromARGB(255, 116, 108, 108)
                                              )
                                            : null
                                          ),
                                          width: getScreenWidth() * 0.1,
                                          height: getScreenWidth() * 0.1
                                        ),
                                      )
                                    );
                                  },
                                )
                              ),
                              SizedBox(
                                height: getScreenHeight() * 0.02
                              ),
                            ]
                          ),
                          CustomButton(
                            width: getScreenWidth() * 0.6, 
                            height: getScreenHeight() * 0.07, 
                            buttonColor: Colors.orange, 
                            buttonText: 'Add Polygon', 
                            onTapped: (){
                              bool latitudesNotEmpty = latitudeControllers.where((e) => e.text.trim().isNotEmpty).toList().isNotEmpty;
                              bool longitudesNotEmpty = longitudeControllers.where((e) => e.text.trim().isNotEmpty).toList().isNotEmpty;
                              if(latitudesNotEmpty && longitudesNotEmpty){
                                globalData.polygons.value[index].notifier.value = FloatingPolygonClass(
                                  borderColor,
                                  color,
                                  List.generate(
                                    latitudeControllers.length,
                                    (i) => lat_long.LatLng(
                                      double.parse(latitudeControllers[i].text),
                                      double.parse(longitudeControllers[i].text)
                                    )
                                  )
                                );
                                Navigator.of(dialogContext).pop();
                              }else{
                                showSnackBar(context, 'Fields cannot be empty');
                              }
                            }, 
                            setBorderRadius: true
                          ),
                        ]
                      ),
                    ),
                  )
                )
              );
            }
          );
        }
      );
    }
  }

  void editLineDialog(int index, FloatingLineNotifier data){
    if(mounted){
      List<TextEditingController> latitudeControllers = data.notifier.value.points.map((e) => TextEditingController(
        text: e.latitude.toString()
      )).toList();
      List<TextEditingController> longitudeControllers = data.notifier.value.points.map((e) => TextEditingController(
        text: e.longitude.toString()
      )).toList();
      Color color = data.notifier.value.color;
      showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setState){
              return Dialog(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: getScreenWidth() * 0.02
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getScreenHeight() * 0.015
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Add Line', style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: getScreenHeight() * 0.02
                              ),
                              for(int i = 0; i < latitudeControllers.length; i++)
                              Column(
                                children: [
                                  SizedBox(
                                    height: getScreenHeight() * 0.015
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Side ${i+1}', style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                      )),
                                      IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: (){
                                          setState((){
                                            latitudeControllers.removeAt(i);
                                            longitudeControllers.removeAt(i);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  TextField(
                                    controller: latitudeControllers[i],
                                    keyboardType: const TextInputType.numberWithOptions(),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
                                      fillColor: const Color.fromARGB(255, 143, 132, 132),
                                      filled: true,
                                      border: InputBorder.none,
                                      hintText: 'Enter latitude',
                                    )
                                  ),
                                  SizedBox(
                                    height: getScreenHeight() * 0.01
                                  ),
                                  TextField(
                                    controller: longitudeControllers[i],
                                    keyboardType: const TextInputType.numberWithOptions(),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
                                      fillColor: const Color.fromARGB(255, 143, 132, 132),
                                      filled: true,
                                      border: InputBorder.none,
                                      hintText: 'Enter longitude',
                                    )
                                  )
                                ],
                              ),
                            ]
                          ),
                          SizedBox(
                            height: getScreenHeight() * 0.02
                          ),
                          CustomButton(
                            width: getScreenWidth() * 0.6, 
                            height: getScreenHeight() * 0.07, 
                            buttonColor: Colors.orange, 
                            buttonText: 'Add Side', 
                            onTapped: (){
                              setState((){
                                latitudeControllers.add(TextEditingController());
                                longitudeControllers.add(TextEditingController());
                              });
                            }, 
                            setBorderRadius: true
                          ),
                          SizedBox(
                            height: getScreenHeight() * 0.02
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select line color', style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500
                              )),
                              SizedBox(
                                height: getScreenHeight() * 0.075,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: colorsList.length,
                                  itemBuilder: (context, index){
                                    return Container(
                                      padding: EdgeInsets.only(
                                        right: getScreenWidth() * 0.015
                                      ),
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() => color = colorsList[index]);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colorsList[index],
                                            border: color == colorsList[index] ?
                                              Border.all(
                                                width: 2,
                                                color: const Color.fromARGB(255, 116, 108, 108)
                                              )
                                            : null
                                          ),
                                          width: getScreenWidth() * 0.1,
                                          height: getScreenWidth() * 0.1
                                        ),
                                      )
                                    );
                                  },
                                )
                              ),
                              SizedBox(
                                height: getScreenHeight() * 0.02
                              ),
                            ]
                          ),
                          CustomButton(
                            width: getScreenWidth() * 0.6, 
                            height: getScreenHeight() * 0.07, 
                            buttonColor: Colors.orange, 
                            buttonText: 'Add Line', 
                            onTapped: (){
                              bool latitudesNotEmpty = latitudeControllers.where((e) => e.text.trim().isNotEmpty).toList().isNotEmpty;
                              bool longitudesNotEmpty = longitudeControllers.where((e) => e.text.trim().isNotEmpty).toList().isNotEmpty;
                              if(latitudesNotEmpty && longitudesNotEmpty){
                                globalData.lines.value[index].notifier.value = FloatingLineClass(
                                  color,
                                  List.generate(
                                    latitudeControllers.length,
                                    (i) => lat_long.LatLng(
                                      double.parse(latitudeControllers[i].text),
                                      double.parse(longitudeControllers[i].text)
                                    )
                                  )
                                );
                                Navigator.of(dialogContext).pop();
                              }else{
                                showSnackBar(context, 'Fields cannot be empty');
                              }
                            }, 
                            setBorderRadius: true
                          ),
                        ]
                      ),
                    ),
                  )
                )
              );
            }
          );
        }
      );
    }
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
                  print(position.global.dx);
                  print(position.global.dy);
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
                          key: UniqueKey(),
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
                          child: ValueListenableBuilder(
                            valueListenable: textsList[i].notifier,
                            builder: (context, textData, child){
                              return GestureDetector(
                                onTap: () => editTextDialog(i, textsList[i]),
                                child: Text(
                                  textData.text,
                                  style: textData.style
                                ),
                              );
                            }
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
                          borderStrokeWidth: 20,
                        )
                      ],
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: globalData.polygons,
                  builder: (context, polygonsList, child){
                    return PolygonLayer(
                      polygonCulling: false,
                      polygons: [
                        for(int i = 0; i < polygonsList.length; i++)
                        Polygon(
                          points: polygonsList[i].notifier.value.points,
                          color: polygonsList[i].notifier.value.color,
                          borderStrokeWidth: 2,
                          borderColor: polygonsList[i].notifier.value.borderColor,
                          isFilled: true
                        ),
                      ],
                    );
                  }
                ),
                ValueListenableBuilder(
                  valueListenable: globalData.lines,
                  builder: (context, linesList, child){
                    return PolylineLayer(
                      polylines: [
                        for(int i = 0; i < linesList.length; i++)
                        Polyline(
                          points: linesList[i].notifier.value.points,
                          color: linesList[i].notifier.value.color,
                          strokeWidth: 2,
                        ),
                      ],
                    );
                  }
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
                      keyboardType: const TextInputType.numberWithOptions(),
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
                        fillColor: const Color.fromARGB(255, 143, 132, 132),
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
                      keyboardType: const TextInputType.numberWithOptions(),
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
                        fillColor: const Color.fromARGB(255, 143, 132, 132),
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