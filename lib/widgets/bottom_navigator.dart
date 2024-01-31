import 'package:flutter/material.dart';
import 'package:osm_client/appdata/global_functions.dart';
import 'package:osm_client/appdata/global_variables.dart';
import 'package:osm_client/class/floating_circle_class.dart';
import 'package:osm_client/class/floating_line_class.dart';
import 'package:osm_client/class/floating_polygon_class.dart';
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
      TextEditingController fontController = TextEditingController(
        text: '14.0'
      );
      double fontSize = 14;
      Color color = Colors.black;
      FontWeight boldValue = FontWeight.w100;

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
                        const Text('Add Text', style: TextStyle(
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
                                fillColor: Color.fromARGB(255, 143, 132, 132),
                                filled: true,
                                border: InputBorder.none,
                                hintText: 'Enter text',
                              )
                            ),
                            SizedBox(
                              height: getScreenHeight() * 0.02
                            ),
                            Text('Select text font value', style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500
                            )),
                            TextField(
                              controller: fontController,
                              readOnly: true,
                              decoration: InputDecoration(
                                counterText: "",
                                contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.0225, horizontal: getScreenWidth() * 0.02),
                                fillColor: Color.fromARGB(255, 143, 132, 132),
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
                                  icon: Icon(Icons.remove)
                                ),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    if(fontSize < 23){
                                      fontSize += 0.5;
                                      fontController.text = fontSize.toString();
                                    }
                                  },
                                  icon: Icon(Icons.add)
                                )
                              )
                            ),
                            SizedBox(
                              height: getScreenHeight() * 0.02
                            ),
                            Text('Select text bold value', style: TextStyle(
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
                            Text('Select text color', style: TextStyle(
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
                                              color: Color.fromARGB(255, 116, 108, 108)
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
                          buttonText: 'Add Text', 
                          onTapped: (){
                            if(textController.text.trim().isNotEmpty){
                              globalData.texts.value = [
                                ...globalData.texts.value,
                                FloatingTextNotifier(
                                  ValueNotifier(
                                    FloatingTextClass(
                                      textController.text,
                                      TextStyle(
                                        fontSize: fontSize,
                                        color: color,
                                        fontWeight: boldValue
                                      ),
                                      lat_long.LatLng(
                                        globalData.latitude, 
                                        globalData.longitude
                                      )
                                    )
                                  )
                                )
                              ];
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

  void showPolygonDialog(){
    if(mounted){
      List<TextEditingController> latitudeControllers = List.generate(3, (i) => TextEditingController());
      List<TextEditingController> longitudeControllers = List.generate(3, (i) => TextEditingController());
      Color borderColor = Colors.black;
      Color color = Colors.black;
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
                                      Text('Side ${i+1}', style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                      )),
                                      IconButton(
                                        icon: Icon(Icons.clear),
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
                                    keyboardType: TextInputType.numberWithOptions(),
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
                                    height: getScreenHeight() * 0.01
                                  ),
                                  TextField(
                                    controller: longitudeControllers[i],
                                    keyboardType: TextInputType.numberWithOptions(),
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
                              Text('Select polygon color', style: TextStyle(
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
                                                color: Color.fromARGB(255, 116, 108, 108)
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
                              Text('Select polygon border color', style: TextStyle(
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
                                                color: Color.fromARGB(255, 116, 108, 108)
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
                                globalData.polygons.value = [
                                  ...globalData.polygons.value,
                                  FloatingPolygonNotifier(
                                    ValueNotifier(
                                      FloatingPolygonClass(
                                        borderColor,
                                        color,
                                        List.generate(
                                          latitudeControllers.length,
                                          (i) => lat_long.LatLng(
                                            double.parse(latitudeControllers[i].text),
                                            double.parse(longitudeControllers[i].text)
                                          )
                                        )
                                      )
                                    )
                                  )
                                ];
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

  void showLineDialog(){
    if(mounted){
      List<TextEditingController> latitudeControllers = List.generate(3, (i) => TextEditingController());
      List<TextEditingController> longitudeControllers = List.generate(3, (i) => TextEditingController());
      Color color = Colors.black;
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
                                      Text('Side ${i+1}', style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                      )),
                                      IconButton(
                                        icon: Icon(Icons.clear),
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
                                    keyboardType: TextInputType.numberWithOptions(),
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
                                    height: getScreenHeight() * 0.01
                                  ),
                                  TextField(
                                    controller: longitudeControllers[i],
                                    keyboardType: TextInputType.numberWithOptions(),
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
                              Text('Select line color', style: TextStyle(
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
                                                color: Color.fromARGB(255, 116, 108, 108)
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
                                globalData.lines.value = [
                                  ...globalData.lines.value,
                                  FloatingLineNotifier(
                                    ValueNotifier(
                                      FloatingLineClass(
                                        color,
                                        List.generate(
                                          latitudeControllers.length,
                                          (i) => lat_long.LatLng(
                                            double.parse(latitudeControllers[i].text),
                                            double.parse(longitudeControllers[i].text)
                                          )
                                        )
                                      )
                                    )
                                  )
                                ];
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

  void showCircleDialog(){
    if(mounted){
      TextEditingController radiusController = TextEditingController();
      Color fillColor = Colors.black;
      Color borderColor = Colors.black;
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
                        const Text('Add Circle', style: TextStyle(
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
                              height: getScreenHeight() * 0.02
                            ),
                            Text('Select circle color', style: TextStyle(
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
                                              color: Color.fromARGB(255, 116, 108, 108)
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
                            Text('Select border color', style: TextStyle(
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
                                              color: Color.fromARGB(255, 116, 108, 108)
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
                          buttonText: 'Add Circle', 
                          onTapped: (){
                            if(double.tryParse(radiusController.text) != null){
                              globalData.circles.value = [
                                ...globalData.circles.value,
                                FloatingCircleNotifier(
                                  ValueNotifier(
                                    FloatingCircleClass(
                                      double.parse(radiusController.text),
                                      fillColor,
                                      borderColor, 
                                      lat_long.LatLng(
                                        globalData.latitude, 
                                        globalData.longitude
                                      )
                                    )
                                  )
                                )
                              ];
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
              onPressed: () => showLineDialog(),
              icon: Icon(Icons.line_style)
            )
          ),
          SizedBox(
            width: getScreenWidth() / 4,
            child: IconButton(
              onPressed: () => showPolygonDialog(),
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