import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/home/drawer_state.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodie/views/experiences/experiences_detail.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchExperiences extends StatefulWidget
{
  final String experiencesSearch;

  SearchExperiences({
    Key key,
    this.experiencesSearch
  }) : super(key: key);

  @override
  _SearchExperiences createState() => new _SearchExperiences();
}

class _SearchExperiences extends State<SearchExperiences>
{
  String startDate = "DD/MM/AA";
  String endDate = "DD/MM/AA";
  List<Widget> results = [];
  List<dynamic> dynamicResults = [];
  String baseImgUrl = "http://foodie.develop.datia.co/";
  final searchController = TextEditingController();
  String dropdownValue = 'Bogotá.dc';
  ScrollController _controller = new ScrollController();
  Map itemExpanded = {};

  @override
  void initState() {
    fetchResults();
    super.initState();
  }

  fetchResults() async {
    Map map;
    Map exp = jsonDecode(widget.experiencesSearch);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (exp["text"].toString() == "") {
      print("searhc search content: " + widget.experiencesSearch);
      var response = await Http.post(
        'http://api.foodie.quality.datia.co/experience/recommendExperience',
        body: {
          "id_city": prefs.getInt("selectedCity").toString()
        });
      map = jsonDecode(response.body);
    } else {
      print("searhc find word");
      var response = await Http.post(
        'http://api.foodie.quality.datia.co/experience/filterexperiencesbywords',
        body: {
          "id_city": prefs.getInt("selectedCity").toString(),
          "word": exp["text"].toString(),
          "date_start": exp["startDate"].toString(),
          "date_end": exp["endDate"].toString(),
          "category_experiences": "1" 
        });
      map = jsonDecode(response.body);
      print("da fuck " + {
          "id_city": prefs.getInt("selectedCity").toString(),
          "word": exp["text"],
          "date_start": exp["startDate"],
          "date_end": exp["endDate"],
          "category_experiences": "1"
        }.toString());
        print("da fuck 2: " + map.toString());
    }

    setState(() {
      List auxMap = [];
      if (map["data"] != null) {
        auxMap = map["data"];
      }
      dynamicResults = auxMap;
      searchController.text = exp["text"];
    });
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Todos';
    return WillPopScope(
      child:  Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return new Container(
                  child: FlatButton(
                    child: Image.asset("images/isotipo.png"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen()
                        ),
                      );
                    },
                  ),
                  margin: EdgeInsets.only(top: 12, bottom: 12)
              );
            },
          ),
          title: AppBarTitle(content: SearchExperiences()),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            child: Text(
                                "Qué paquete estás buscando?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Quicksand Regular',
                                    color: Color.fromRGBO(63, 63, 63, 1),
                                    fontSize: 12
                                ),
                                maxLines: 2,
                            ),
                          margin: EdgeInsets.only(top: 10),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Center(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromRGBO(63, 67, 77, 1),
                              ),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Color.fromRGBO(63, 67, 77, 1),
                                  fontSize: 10
                              ),
                              underline: Container(
                                height: 1,
                                color: Color.fromRGBO(63, 67, 77, 1),
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>['Todos', 'Solo Experiencia', "Experiencia + vuelo", "Experiencia + Vuelo + Hotel"]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          margin: EdgeInsets.only(top: 10),
                        )
                      )
                    ],
                  ),
                ),
                Container(
                  child: Divider(),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                ),
                SizedBox(height: 20.0),
                Container(
                  child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: "Busca una nueva experiencia",
                          hintStyle: TextStyle(fontSize: 14, color: Color.fromRGBO(193, 191, 202, 1)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(193, 191, 202, 1),
                                  width: 1
                              ),
                              borderRadius: BorderRadius.circular(50.0)
                          ),
                          focusColor: Colors.amber,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(250, 0, 60, 1),
                                  width: 1
                              ),
                              borderRadius: BorderRadius.circular(50.0)
                          )
                      )
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20),
                  height: 50.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Text(
                              "Desde",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(250, 0, 60, 1),
                                  fontSize: 12
                              )
                          ),
                        ),
                        margin: EdgeInsets.only(top: 10),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Text(
                              "Hasta",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(250, 0, 60, 1),
                                  fontSize: 12
                              )
                          ),
                        ),
                        margin: EdgeInsets.only(top: 10),
                      )
                    )
                  ],
                ),
                Container(
                  child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: new Center(
                              child: Container(
                                child: MaterialButton(
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      startDate,
                                      style: TextStyle(
                                          color: Color.fromRGBO(193, 191, 202, 1),
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                      DatePicker.showDateTimePicker(
                                        context,
                                        showTitleActions: true,
                                        minTime: DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - 172800),
                                        maxTime: DateTime(2030), 
                                        onChanged: (date) {
                                          print('change $date in time zone ' +
                                          date.timeZoneOffset.inHours.toString());
                                          
                                        },
                                        onConfirm: (date) {
                                          setState(() {
                                            startDate = "${date.day}/${date.month}/${date.year}";
                                          });
                                        },
                                        locale: LocaleType.es
                                      );
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(50.0),
                                      side: BorderSide(color: Color.fromRGBO(193, 191, 202, 1))
                                  ),
                                  height: 50,
                                  minWidth: double.infinity,
                                ),
                                margin: EdgeInsets.only(left: 20, right: 5),
                              )
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: new Center(
                              child: Container(
                                child: MaterialButton(
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      endDate,
                                      style: TextStyle(
                                          color: Color.fromRGBO(193, 191, 202, 1),
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                      DatePicker.showDateTimePicker(
                                        context,
                                        showTitleActions: true,
                                        minTime: DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - 172800),
                                        maxTime: DateTime(2030), 
                                        onChanged: (date) {
                                          print('change $date in time zone ' +
                                          date.timeZoneOffset.inHours.toString());
                                          
                                        },
                                        onConfirm: (date) {
                                          setState(() {
                                            endDate = "${date.day}/${date.month}/${date.year}";
                                          });
                                        },
                                        locale: LocaleType.es
                                      );
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(50.0),
                                      side: BorderSide(color: Color.fromRGBO(193, 191, 202, 1))
                                  ),
                                  height: 50,
                                  minWidth: double.infinity,
                                ),
                                margin: EdgeInsets.only(left: 20, right: 5),
                              )
                          ),
                          flex: 1,
                        ),
                      ]
                  ),
                  margin: EdgeInsets.only(right: 20, top: 10),
                ),
                Container(
                  child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: MaterialButton(
                                  child: Text(
                                    "Buscar",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16
                                    ),
                                  ),
                                  onPressed: () {
                                    String criteria = jsonEncode({
                                      "text": searchController.text.toString(),
                                      "startDate": startDate.toString(),
                                      "endDate": endDate.toString()
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SearchExperiences(experiencesSearch: criteria,)),
                                    );
                                  }, 
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  color: Color.fromRGBO(250, 0, 60, 1),
                                  height: 50,
                                  minWidth: double.infinity,
                                ),
                              )
                          ),
                          flex: 1,
                        )
                      ]
                  ),
                  margin: EdgeInsets.only(left:20, right: 20, top: 10),
                ),
                Container(
                  child: Center(
                    child: Text(
                      "Resultados: ${dynamicResults.length} restaurantes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(63, 67, 77, 1),
                          fontSize: 12
                      ),
                      maxLines: 2,
                    ),
                  ),
                  margin: EdgeInsets.only(top: 20),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 20),
              child: ListView.builder(
                itemBuilder: (context, position) {
                  var item = dynamicResults[position];
                  return Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        )
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: item["image_one"],
                                      //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/19/e6/restaurant-chocolat.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.2
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          child: Text(
                                              item["name_experience"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontFamily: 'Quicksand Bold',
                                                  color: Color.fromRGBO(63, 67, 77, 1),
                                                  fontSize: 14
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                          ),
                                          margin: EdgeInsets.only(top: 5),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                            Image.asset("images/hat.png", height: 15,),
                                            Container(
                                              child: Text(
                                                  item["score_foodie"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Quicksand Regular',
                                                      color: Color.fromRGBO(63, 63, 63, 1),
                                                      fontSize: 12
                                                  )
                                              ),
                                              margin: EdgeInsets.only(right: 20, left: 5),
                                            ),
                                            Image.asset("images/cup.png", height: 15,),
                                            Container(
                                              child: Text(
                                                  item["score_user"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Quicksand Regular',
                                                      color: Color.fromRGBO(63, 63, 63, 1),
                                                      fontSize: 12
                                                  )
                                              ),
                                              margin: EdgeInsets.only(right: 20, left: 5),
                                            )
                                        ],
                                      ),
                                      SizedBox(height: 15.0,),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          SizedBox(width: 5.0,),
                                          Container(
                                            child: Text(
                                                "Desde ",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontFamily: 'Quicksand Regular',
                                                    color: Color.fromRGBO(63, 63, 63, 1),
                                                    fontSize: 10
                                                ),
                                                maxLines: 1,
                                            ),
                                            margin: EdgeInsets.only(top: 15),
                                          ),
                                          Container(
                                            child: Text(
                                                "\$" + item["price"],
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontFamily: 'Quicksand Bold',
                                                    color: Color.fromRGBO(250, 0, 60, 1),
                                                    fontSize: 12
                                                ),
                                                maxLines: 1,
                                            ),
                                            margin: EdgeInsets.only(top: 15),
                                          ),
                                          Container(
                                            child: Text(
                                                "/persona",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontFamily: 'Quicksand Regular',
                                                    color: Color.fromRGBO(63, 63, 63, 1),
                                                    fontSize: 10
                                                ),
                                                maxLines: 1,
                                            ),
                                            margin: EdgeInsets.only(top: 15),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: Icon(
                                                Icons.people,
                                                color: Color.fromRGBO(173, 192, 202, 1),
                                                size: 12,
                                              ),
                                              margin: EdgeInsets.only(top: 5),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                  item["recommendation_numberpeople"],
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontFamily: 'Quicksand Regular',
                                                      color: Color.fromRGBO(63, 63, 63, 1),
                                                      fontSize: 9
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                              ),
                                              margin: EdgeInsets.only(left: 5, top: 5),
                                            ),
                                            flex: 10,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20.0,),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        child: MaterialButton(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "Reservar",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10
                                                ),
                                              ),
                                              Icon(Icons.trending_flat, color: Colors.white,)
                                            ],
                                          ),
                                          onPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ExperiencesDetail(restaurant: jsonEncode(item),)
                                              ),
                                            );
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50)
                                          ),
                                          color: Color.fromRGBO(250, 0, 60, 1),
                                          height: 30,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                flex: 2,
                              )
                            ],
                          ),
                          SingleChildScrollView(
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                child: Container(
                                  height: 50.0,
                                  color: Color.fromRGBO(242, 243, 244, 1),
                                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "Este paquete incluye",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontFamily: ""
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(child: Image.asset("images/bed_01.png",), height: 15.0,),
                                            SizedBox(width: 10.0,),
                                            Container(child: Image.asset("images/plane_01.png",), height: 15.0)
                                          ],
                                        )
                                      )
                                    ],
                                  )
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                },
                itemCount: dynamicResults.length,
                shrinkWrap: true,
                controller: _controller,
              ),
            ),
            /*ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: results,
            )*/
          ]
        ),
        endDrawer: DrawerState(),
        bottomNavigationBar: AppBottomBar(tabSelected: 0,)
      ),
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen()
          ),
        );
        return;
      },
    );
  }
}
