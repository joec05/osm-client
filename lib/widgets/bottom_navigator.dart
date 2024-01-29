import 'package:flutter/material.dart';
import 'package:osm_client/appdata/global_functions.dart';
import 'package:osm_client/class/floating_circle_class.dart';
import 'package:osm_client/class/floating_text_class.dart';
import 'package:osm_client/class/global_data.dart';
import 'package:osm_client/widgets/custom_button.dart';
import 'package:latlong2/latlong.dart' as lat_long;

class BottomActionsWidget extends StatefulWidget {
  const BottomActionsWidget({super.key});

  @override
  BottomActionsWidgetState createState() => BottomActionsWidgetState();
}

class BottomActionsWidgetState extends State<BottomActionsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showTextDialog(){
    if(mounted){
      TextEditingController textController = TextEditingController();
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            title: const Text('Add Text'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
                    fillColor: Color.fromARGB(255, 143, 132, 132),
                    filled: true,
                    border: InputBorder.none,
                    hintText: 'Enter text',
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.025
                ),
                CustomButton(
                  width: getScreenWidth() * 0.6, 
                  height: getScreenHeight() * 0.07, 
                  buttonColor: Colors.orange, 
                  buttonText: 'Add Text', 
                  onTapped: (){
                    if(textController.text.trim().isNotEmpty){
                      globalData.texts.value = [
                        ...globalData.texts.value,
                        FloatingTextNotifier(
                          ValueNotifier(
                            FloatingTextClass(
                              textController.text,
                              TextStyle(fontSize: 14),
                              lat_long.LatLng(
                                globalData.latitude, 
                                globalData.longitude
                              )
                            )
                          )
                        )
                      ];
                    }else{
                      showSnackBar(context, 'Text cannot be empty');
                    }
                  }, 
                  setBorderRadius: true
                )
              ]
            )
          );
        }
      );
    }
  }

  void showPolygonDialog(){
    
  }

  void showCircleDialog(){
    if(mounted){
      TextEditingController radiusController = TextEditingController();
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            title: const Text('Add Circle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: radiusController,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
                    fillColor: Color.fromARGB(255, 143, 132, 132),
                    filled: true,
                    border: InputBorder.none,
                    hintText: 'Enter radius',
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.025
                ),
                CustomButton(
                  width: getScreenWidth() * 0.6, 
                  height: getScreenHeight() * 0.07, 
                  buttonColor: Colors.orange, 
                  buttonText: 'Add Circle', 
                  onTapped: (){
                    if(double.tryParse(radiusController.text) != null){
                      globalData.circles.value = [
                        ...globalData.circles.value,
                        FloatingCircleNotifier(
                          ValueNotifier(
                            FloatingCircleClass(
                              double.parse(radiusController.text),
                              Colors.red,
                              Colors.cyan, 
                              lat_long.LatLng(
                                globalData.latitude, 
                                globalData.longitude
                              )
                            )
                          )
                        )
                      ];
                    }else{
                      showSnackBar(context, 'Invalid value');
                    }
                  }, 
                  setBorderRadius: true
                )
              ]
            )
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenHeight() * 0.1,
      color: Colors.blueGrey,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
            width: getScreenWidth() / 4,
            child: IconButton(
              onPressed: () => showTextDialog(),
              icon: Icon(Icons.text_format)
            )
          ),
          SizedBox(
            width: getScreenWidth() / 4,
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.line_style)
            )
          ),
          SizedBox(
            width: getScreenWidth() / 4,
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.rectangle)
            )
          ),
          SizedBox(
            width: getScreenWidth() / 4,
            child: IconButton(
              onPressed: () => showCircleDialog(),
              icon: Icon(Icons.circle)
            )
          ),
        ],
      ),
    );
  }
}