
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/views/home/drawer_state.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodie/views/experiences/experiences_detail.dart';
import 'package:foodie/views/experiences/search_experiences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExperiencesHome extends StatefulWidget
{
  @override
  _ExperiencesHome createState() => new _ExperiencesHome();
}

class _ExperiencesHome extends State<ExperiencesHome>
{
  final searchController = TextEditingController();

  final PageController pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.5
  );

  final PageController pageCityController = PageController(
      initialPage: 0,
      viewportFraction: 0.5
  );

  final PageController pageOptionsController = PageController(
      initialPage: 0,
      viewportFraction: 0.3
  );

  final PageController pageFavoriteController = PageController(
      initialPage: 0,
      viewportFraction: 0.4
  );

  List<String> cities = [
    "Bogotá.dc",
    "Barranquilla",
    "Medellin"
  ];

  List<String> options = [
    "Cena romántica",
    "Con amigos",
    "Fast food",
    "Comida árabe",
    "De pesca"
  ];

  String startDate = "DD/MM/AA";
  String endDate = "DD/MM/AA";
  String baseImgUrl = "https://foodie.quality.datia.co/";

  List xp = [];
  String dropdownValue = 'Todos';
  List<dynamic> restaurants = [];
  List<dynamic> listOne = [];
  List<dynamic> listTwo = [];
  List<dynamic> listThree = [];
  List<dynamic> listFour = [];
  List<dynamic> listFive = [];
  List<Widget> favoriteItems = [];
  

  var favoriteColoreSelected  = Color.fromRGBO(250, 0, 60, 1);
  var favoriteColoredDisabled = Color.fromRGBO(193, 191, 202, 1);
  var favoritePosition = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    var response = await Http.post(
      'http://api.foodie.quality.datia.co/restaurant/restaurantList',
      body: {
        "id_city": prefs.getInt("selectedCity").toString()
      });

    Map map = jsonDecode(response.body);

    listOne   = map["listone"];
    listTwo   = map["listtwo"];
    listThree = map["listthree"];
    listFour  = map["listfour"];
    listFive  = map["listfive"];

    var responseXp = await Http.post(
        'http://api.foodie.quality.datia.co/experience/recommendExperience',
        body: {
          "id_city": prefs.getInt("selectedCity").toString()
        });

    Map mapXp = jsonDecode(responseXp.body);

    setState(() {
      restaurants = map["restaurants"];
      xp = mapXp["data"];
      pageController.jumpToPage(3);
      pageFavoriteController.jumpToPage(2);
      fetchFavorites(listOne, 0);
    });
  }

  fetchFavorites(List<dynamic> list, int position) {
    List<Widget> auxFavoriteWidgets = [];
    list.forEach((item) => auxFavoriteWidgets.add(Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.white,
      child: Center(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)
                  ),
                  child: CachedNetworkImage(
                    imageUrl: baseImgUrl + item["image_one"],
                    //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/19/e6/restaurant-chocolat.jpg",
                    width: 200,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.white,
                    ),
                    tooltip: 'Increase volume by 10',
                    onPressed: () {

                    },
                  ),
                )
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 8.0,
            ),
            Center(
              child: Text(
                  item["name_restaurant"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Quicksand Bold',
                      color: Color.fromRGBO(63, 63, 63, 1),
                      fontSize: 10
                  )
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 8.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("images/hat.png", height: 13,),
                Container(
                  child: Text(
                      item["score_foodie"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Quicksand Regular',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 10
                      )
                  ),
                  margin: EdgeInsets.only(right: 20, left: 5),
                ),
                Image.asset("images/cup.png", height: 13,),
                Container(
                  child: Text(
                      item["score_user"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Quicksand Regular',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 10
                      )
                  ),
                  margin: EdgeInsets.only(right: 20, left: 5),
                )
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 8.0,
            ),
          ],
        ),
      ),
    )));

    setState(() {
      favoriteItems = auxFavoriteWidgets;
      favoritePosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return new Container(
                child: Image.asset("images/isotipo.png"),
                margin: EdgeInsets.only(top: 12, bottom: 12)
            );
          },
        ),
        title: AppBarTitle(content: ExperiencesHome()),
      ),
      body: WillPopScope(
        //Wrap out body with a `WillPopScope` widget that handles when a user is cosing current route
        onWillPop: () async {
          Future.value(false); //return a `Future` with false value so this route cant be popped or closed.
          return;
        },
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Text(
                        "Que nunca falte una buena cerveza",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 67, 77, 1),
                            fontSize: 16
                        )
                    ),
                  ),
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                ),
                Container(
                  child: Center(
                    child: Text(
                        "Y si te vas de tour?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 12
                        )
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 20),
                ),
                Container(
                  child: Divider(),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                ),
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
                                    //color: Color.fromRGBO(63, 63, 63, 1),
                                    color: Colors.grey,
                                    fontSize: 12
                                ),
                                maxLines: 2,
                            ),
                          margin: EdgeInsets.only(top: 10),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            right: 10.0,
                            left: 10.0
                          ),
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
                                fontSize: 8,
                                fontFamily: "Quicksand Bold"
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
                                  fontFamily: 'Quicksand Bold',
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
                                  fontFamily: 'Quicksand Bold',
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
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Center(
                              child: Container(
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
                    color: Colors.white,
                    child: Image.asset("images/banner2.png"),
                    margin: EdgeInsets.only(top: 30.0)
                ),
                Container(
                  child: Center(
                    child: Text(
                        "PROMOCIÓN DEL DÍA",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(193, 191, 202, 1),
                            fontSize: 14
                        )
                    ),
                  ),
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                ),
                Container(
                    child: Image.asset("images/promocion.png"),
                    margin: EdgeInsets.only(left: 20, right: 20)
                ),
                Container(
                  child: Center(
                    child: Text(
                        "NUESTRAS RECOMENDACIONES",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(193, 191, 202, 1),
                            fontSize: 14
                        )
                    ),
                  ),
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Container(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount:  xp.length,
                      itemBuilder: (context, position) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0)
                                      ),
                                      child: Container(
                                        child: CachedNetworkImage(
                                          imageUrl: baseImgUrl + restaurants[position]["image_one"],
                                          //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/19/e6/restaurant-chocolat.jpg",
                                          height: 90,
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 10.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset("images/hat.png", height: 12,),
                                    Container(
                                      child: Text(
                                          restaurants[position]["score_foodie"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Quicksand Regular',
                                              color: Color.fromRGBO(63, 63, 63, 1),
                                              fontSize: 10
                                          )
                                      ),
                                      margin: EdgeInsets.only(right: 20, left: 5),
                                    ),
                                    Image.asset("images/cup.png", height: 12,),
                                    Container(
                                      child: Text(
                                          restaurants[position]["score_user"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Quicksand Regular',
                                              color: Color.fromRGBO(63, 63, 63, 1),
                                              fontSize: 10
                                          )
                                      ),
                                      margin: EdgeInsets.only(right: 20, left: 5),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 10.0,
                                ),
                                Center(
                                  child: Container(
                                    height: 27.0,
                                    child: Text(
                                        xp[position]["name_experience"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Quicksand Bold',
                                            color: Color.fromRGBO(63, 63, 63, 1),
                                            fontSize: 10
                                        ),
                                        overflow: TextOverflow.clip,
                                    ),
                                    margin: EdgeInsets.only(right: 10, left: 10),
                                  )
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Center(
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "Desde",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontFamily: 'Quicksand Regular',
                                                color: Color.fromRGBO(63, 63, 63, 1),
                                                fontSize: 10
                                            )
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "\$" + xp[position]["price"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Quicksand Bold',
                                                color: Color.fromRGBO(250, 0, 60, 1),
                                                fontSize: 11
                                            )
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "/persona",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: 'Quicksand Regular',
                                                color: Color.fromRGBO(63, 63, 63, 1),
                                                fontSize: 10
                                            )
                                          ),
                                        )
                                      ],
                                    ),
                                    margin: EdgeInsets.only(right: 10, left: 10),
                                  )
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 5.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.people,
                                          color: Color.fromRGBO(173, 192, 202, 1),
                                          size: 15,
                                        ),
                                      ),
                                      flex: 3,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            xp[position]["recommendation_numberpeople"],
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontFamily: 'Quicksand Regular',
                                                color: Color.fromRGBO(63, 63, 63, 1),
                                                fontSize: 9
                                            )
                                        ),
                                      ),
                                      flex: 7,
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(""),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Este paquete incluye:",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontFamily: 'Quicksand Regular',
                                                color: Color.fromRGBO(63, 63, 63, 1),
                                                fontSize: 9
                                            )
                                        ),
                                      ),
                                      flex: 6,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.flight,
                                          color: Color.fromRGBO(250, 0, 60, 1),
                                          size: 15,
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.home,
                                          color: Color.fromRGBO(250, 0, 60, 1),
                                          size: 15,
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Text(""),
                                      flex: 1,
                                    )
                                  ],
                                ),
                                Divider(),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.24,
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
                                        Container(
                                          child: Icon(Icons.arrow_forward, color: Colors.white, size: 15.0,),
                                        )
                                      ],
                                    ),
                                    onPressed: () async {
                                     
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ExperiencesDetail(restaurant: jsonEncode(xp[position]),)
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
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                        "TE PUEDE INTERESAR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(193, 191, 202, 1),
                            fontSize: 14
                        )
                    ),
                  ),
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                ),
                Container(
                  child: Divider(
                    color: Color.fromRGBO(193, 191, 202, 1),
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 170,
                  child: Container(
                    child: PageView(
                      controller: pageFavoriteController,
                      children:   favoriteItems,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      endDrawer: DrawerState(),
      bottomNavigationBar: AppBottomBar(tabSelected: 0,)
    );
  }
}
