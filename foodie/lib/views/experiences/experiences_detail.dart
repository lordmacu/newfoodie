
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/booking/booking.dart';
import 'package:foodie/views/home/drawer_state.dart';
import 'package:http/http.dart' as Http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodie/home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';

class ExperiencesDetail extends StatefulWidget
{
  final String restaurant;

  ExperiencesDetail({
    Key key,
    this.restaurant
  }) : super(key: key);

  @override
  _ExperiencesDetail createState() => new _ExperiencesDetail();
}

class _ExperiencesDetail extends State<ExperiencesDetail> 
{
  String baseImgUrl = "http://foodie.develop.datia.co/";
  
  PageController _pageController = PageController(
    initialPage: 0,
  );

  List<Widget> elipses = [];
  String elipseEnable  = "images/elipse127.png";
  String elipseDisable = "images/elipse128.png";

  var experience;
  var detail;
  var hotel = [];
  var flights = [];
  List itinerary = [];

  @override
  initState() {
    
    _pageController = PageController(
      initialPage: 0,
    );

    setState(() {
      experience = jsonDecode(widget.restaurant);
    });

    getRestaurantDetail();
    super.initState();
  }

  getRestaurantDetail() async {
    var response = await Http.post(
      'http://api.foodie.quality.datia.co/experience/experienceById',
      body: {
        "id_experience": experience["id"].toString()
      });
    var map = jsonDecode(response.body);
    print("experience detail : " + experience["id"].toString()+" / " + map["hotel"].toString());
    List itineraryRaw = map["itinerary"] != null ? map["itinerary"] : [];
    Map groupedMap = {}; 
    for (int i = 0; i < itineraryRaw.length; i++) {
      if (groupedMap[itineraryRaw[i]["day_itinerary"]] == null) {
        groupedMap[itineraryRaw[i]["day_itinerary"]] = [];
      }
      groupedMap[itineraryRaw[i]["day_itinerary"]].add(itineraryRaw[i]);
    }

    setState(() {
      detail    = map;
      flights   = map["flights"];
      hotel     = map["hotel"];
      groupedMap.forEach((key, value) => itinerary.add(value));
      print("la itinerary:" + itinerary.toString());
    });
  }

  String dropdownValue = '2';

  final personController = TextEditingController();
  String dateText     = "DD/MM/AA";
  String timeText     = "00:00 pm";
  bool isFavorite     = false;
  Color favoriteColor = Color.fromRGBO(193, 191, 202, 1);

  showMenu() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Haz tu reserva",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Quicksand Bold',
                      color: Color.fromRGBO(63, 63, 63, 1),
                      fontSize: 18
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              SizedBox(height: 20.0,),
              Divider(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Expanded(
                        child: Container(
                          child: Text(
                            "Inicio de experiencia",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                              fontFamily: 'Quicksand Bold',
                              color: Color.fromRGBO(63, 63, 63, 1),
                              fontSize: 12
                            ),
                          ),
                        )
                      ),
                      new Expanded(
                        child: Container(
                          child: Text(
                            "Fin de la experiencia",
                            textAlign: TextAlign.center,
                             style: TextStyle(
                              fontFamily: 'Quicksand Bold',
                              color: Color.fromRGBO(63, 63, 63, 1),
                              fontSize: 12
                            ),
                          ),
                        )
                      )
                    ],
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Expanded(
                        child: new Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: MaterialButton(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    dateText,
                                    style: TextStyle(
                                        color: Color.fromRGBO(193, 191, 202, 1),
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  DatePicker.showDatePicker(
                                    context,
                                    showTitleActions: true,
                                    minTime: DateTime.fromMillisecondsSinceEpoch(
                                      DateTime.now().millisecondsSinceEpoch - 172800
                                    ),
                                    maxTime: DateTime(2030), 
                                    onChanged: (date) {},
                                    onConfirm: (date) {
                                      setState(() {
                                        dateText = date.day.toString() + "/" + date.month.toString() + "/" + date.year.toString();
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
                      new Expanded(
                        child: new Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: MaterialButton(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    timeText,
                                    style: TextStyle(
                                        color: Color.fromRGBO(193, 191, 202, 1),
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                    DatePicker.showTimePicker(
                                      context,
                                      showTitleActions: true,
                                      onChanged: (date) {},
                                      onConfirm: (date) {
                                        setState(() {
                                          String h = date.hour.toString();
                                          String type = " AM";
                                          if (date.hour > 12) {
                                            h = (date.hour - 12).toString();
                                            type = " PM";
                                          }
                                          timeText = h + ":" + date.minute.toString() + type;
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
                margin: EdgeInsets.only(left: 5, right: 20, top: 10),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Expanded(
                        child: Container(
                          child: Text(
                            "Duración experiencia 3 días.",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                              fontFamily: 'Quicksand Bold',
                              //color: Color.fromRGBO(231, 231, 231, 1),
                              fontSize: 10
                            ),
                          ),
                        )
                      ),
                      new Expanded(
                        child: Container(
                          child: Text(
                            "Cupo máximo 5 personas",
                            textAlign: TextAlign.center,
                             style: TextStyle(
                              fontFamily: 'Quicksand Bold',
                              //color: Color.fromRGBO(231, 231, 231, 1),
                              fontSize: 10
                            ),
                          ),
                        )
                      )
                    ],
                )
              ),
              Divider(),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10.0),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Expanded(
                        child: Container(
                          child: Text(
                            "Tu reserva actual es para 3 personas.",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                              fontFamily: 'Quicksand Bold',
                              //color: Color.fromRGBO(231, 231, 231, 1),
                              fontSize: 10
                            ),
                          ),
                        )
                      ),
                    ],
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Reservar",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.white,)
                    ],
                  ),
                  onPressed: () {
                    if (timeText == "00:00 pm") {
                      Fluttertoast.showToast(
                          msg: "La hora es obligatoria",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 2,
                          backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      return;
                    }
                    
                    if (dateText == "DD/MM/AA") {
                      Fluttertoast.showToast(
                          msg: "La fecha es obligatoria",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 2,
                          backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      return;
                    }

                    Map mapRestaurant = experience;
                    mapRestaurant["name_restaurant"] = experience["name_experience"];
                    mapRestaurant["address"] = "";
                    mapRestaurant["booking_date"] = dateText;
                    mapRestaurant["booking_time"] = timeText;
                    mapRestaurant["person_number"] = dropdownValue;

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Booking(restaurant: jsonEncode(mapRestaurant))),
                    );

                    /*Fluttertoast.showToast(
                        msg: "Reserva realizada correctamente",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 2,
                        backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                        textColor: Colors.white,
                        fontSize: 16.0
                    );*/
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  color: Color.fromRGBO(250, 0, 60, 1),
                  height: 50,
                  minWidth: double.infinity,
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 10.0, bottom: 10),
              ),
              Container(
                //width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10.0, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: FlatButton(
                        child: Container(
                          child: Image.asset(
                            "images/boton_favoritos.png",
                            height: 40,
                          ),
                        ),
                        onPressed: () async {
                          Fluttertoast.showToast(
                            msg: "Agregado a favoritos",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 2,
                            backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                            textColor: Colors.white,
                            fontSize: 16.0
                          );

                        },
                      ),
                    ),
                    Container(
                      child: FlatButton(
                        child: Container(
                          child: Image.asset(
                            "images/boton_compartir.png",
                            height: 40,
                          ),
                        ),
                        onPressed: () {
                          Share.share('check out my website https://example.com');
                        },
                      ),
                    ),
                  ],
                )
              )
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return new Container(
                    child: Image.asset("images/isotipo.png"),
                    margin: EdgeInsets.only(top: 12, bottom: 12)
                );
              },
            ),
            title: AppBarTitle(content: ExperiencesDetail()),
          ),
          body: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: PageView.builder(
                      controller:  _pageController,
                      itemCount: 1,
                      itemBuilder: (context, position) {
                        return CachedNetworkImage(
                          imageUrl: experience["image_one"],
                          //imageUrl: "https://media-cdn.tripadvisor.com/media/photo-f/0e/cc/0e/db/terras-restaurant-chocolat.jpg",
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.cover
                        );
                      },
                      onPageChanged: (current) {
                        
                      },
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: 0.0,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0)
                            ),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: elipses,
                              ),
                              width: MediaQuery.of(context).size.width * 0.3,
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                            ),
                          )
                        ],
                      ),
                    )
                  )
                ],
              ),
              SizedBox(height: 12,),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          experience["name_experience"],
                          style: TextStyle(
                            color: Color.fromRGBO(250, 0, 60, 1),
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        margin: EdgeInsets.only(right: 20.0),
                      ),
                    ),
                    Container(
                      child: Text(
                        "",
                        style: TextStyle(
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 12
                        ),
                        textAlign: TextAlign.start,
                      ),
                      margin: EdgeInsets.only(left: 5, top: 5),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20)
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/hat.png", height: 15,),
                              Container(
                                child: Text(
                                    "4.5",
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
                        ),
                        flex: 3
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "FOODIE PRO",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'Quicksand Regular',
                                //color: Color.fromRGBO(250, 0, 60, 1),
                                fontSize: 8
                            )
                          ),
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/cup.png", height: 15,),
                              Container(
                                child: Text(
                                    "4.2",
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
                        ),
                        flex: 3
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "COMENSALES",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'Quicksand Regular',
                                //color: Color.fromRGBO(250, 0, 60, 1),
                                fontSize: 8
                            )
                          ),
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            child: Text(
                                "Ver calificaciones",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Quicksand Regular',
                                    color: Color.fromRGBO(250, 0, 60, 1),
                                    fontSize: 10
                                )
                            ),
                            margin: EdgeInsets.only(right: 20, left: 5),
                          ),
                        ),
                        flex: 5
                      )
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              SizedBox(height: 20.0,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0)
                  ),
                  border: Border.all(
                    width: 1, //
                    color: Color.fromRGBO(231, 231, 231, 1)//              <--- border width here
                  )
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Desde: ",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'Quicksand Regular',
                              //color: Color.fromRGBO(250, 0, 60, 1),
                              fontSize: 14
                          )
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "\$" + experience["price"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Quicksand Bold',
                              color: Color.fromRGBO(250, 0, 60, 1),
                              fontSize: 20
                          )
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "/persona",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'Quicksand Regular',
                              //color: Color.fromRGBO(250, 0, 60, 1),
                              fontSize: 14
                          )
                        ),
                      )
                    ],
                  )
                ),
                margin: EdgeInsets.only(left: 20, right: 20),
                width: 100.0,
                height: 50.0,
              ),
              Container(
                child: Text(
                  "Descripción",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Quicksand Bold',
                      color: Color.fromRGBO(63, 63, 63, 1),
                      fontSize: 18
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              Container(
                child: Text(
                    experience["description"],
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Quicksand Regular',
                        color: Color.fromRGBO(63, 63, 63, 1),
                        fontSize: 10
                    ),
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.people,
                      color: Color.fromRGBO(173, 192, 202, 1),
                      size: 15,
                    ),
                    SizedBox(width: 5.0,),
                    Text(
                      "Experiencia recomendada para un grupo de entre " + experience["recommendation_numberpeople"],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontFamily: 'Quicksand Regular',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 10
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              SizedBox(height: 20),
              Container(
                child: Text(
                  "Detalle de experiencia",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Quicksand Bold',
                      color: Color.fromRGBO(63, 63, 63, 1),
                      fontSize: 14
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              SizedBox(height: 20),
              Divider(height: 1.0,),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Duración: ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 12
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0,),
                    Text(
                      experience["experience_duration"].toString() + " Días",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontFamily: 'Quicksand Regular',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 10
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15.0)
              ),
              Divider(height: 1.0,),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Temporada experiencia: ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 12
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0,),
                    Text(
                      "Del " + experience["season_experience_start"].toString() + " al " + experience["season_experience_end"].toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontFamily: 'Quicksand Regular',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 10
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15.0)
              ),
              Divider(height: 1.0,),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Horarios actividad: ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 12
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0,),
                    Text(
                      "Del " + experience["activity_schedules_start"].toString() + " a " + experience["activity_schedules_end"].toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontFamily: 'Quicksand Regular',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 10
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15.0)
              ),
              Divider(height: 1.0,),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Transporte local: ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 12
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0,),
                    Text(
                      experience["local_transportation"].toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontFamily: 'Quicksand Regular',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 10
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15.0)
              ),
              Divider(height: 1.0,),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Acompañamiento: ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 12
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0,),
                    Text(
                      experience["accompaniment"].toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontFamily: 'Quicksand Regular',
                          color: Color.fromRGBO(63, 63, 63, 1),
                          fontSize: 10
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15.0)
              ),
              Divider(),
              SizedBox(height: 20),
              Container(
                child: Text(
                  "Servicios incluidos",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Quicksand Bold',
                      color: Color.fromRGBO(63, 63, 63, 1),
                      fontSize: 16
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15.0)
              ),
              SizedBox(height: 20),
              Visibility(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Image.asset("images/plane_01.png", height: 15.0,),
                          SizedBox(width: 5.0,),
                          Text(
                            "Vuelo",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Bold',
                                color: Color.fromRGBO(250, 0, 60, 1),
                                fontSize: 16
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15.0)
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Descripción",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Bold',
                                  fontSize: 10
                              )
                            ),
                            flex: 4,
                          ),
                          Expanded(
                            child: Text(
                              "Origen y destino",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Bold',
                                  fontSize: 10
                              )
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: Text(
                              "Fecha vuelo",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Bold',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text(
                              "Clase vuelo",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Bold',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15)
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              flights.length > 0 ? flights[0]["description_flight"] : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 4,
                          ),
                          Expanded(
                            child: Text(
                              flights.length > 0 ? flights[0]["origin_destination"] : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: Text(
                              flights.length > 0 ? flights[0]["flight_date"] : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text(
                              flights.length > 0 ? flights[0]["flight_class"] : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15)
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              flights.length == 2 ? flights[1]["description_flight"] : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 4,
                          ),
                          Expanded(
                            child: Text(
                              flights.length == 2 ? flights[1]["origin_destination"] : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: Text(
                              flights.length == 2 ? flights[1]["flight_date"] : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text(
                              flights.length == 2 ? flights[1]["flight_class"] : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15)
                    )
                  ],
                ),
                visible: experience["service_include"] >= 3 ? true : false,
              ),
              SizedBox(height: 20.0,),
              Visibility(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Image.asset("images/bed_01.png", height: 15.0,),
                          SizedBox(width: 5.0,),
                          Text(
                            "Hotel",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Quicksand Bold',
                                color: Color.fromRGBO(250, 0, 60, 1),
                                fontSize: 16
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15)
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Hotel",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Bold',
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text(
                              "Hospedaje",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Bold',
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text(
                              "Check in",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Bold',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text(
                              "Check out",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Bold',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text(
                              "# de personas",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Bold',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15)
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              hotel.length > 0 ? hotel[0]["name_hotel"] : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text(
                              hotel.length > 0 ? hotel[0]["lodging"].toString() : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text(
                              hotel.length > 0 ? hotel[0]["checkin"] : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text(
                              hotel.length > 0 ?  hotel[0]["checkout"] : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text(
                              hotel.length > 0 ? hotel[0]["number_people"] : "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Regular',
                                  color: Color.fromRGBO(63, 63, 63, 1),
                                  fontSize: 10
                              )
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15)
                    ),
                  ],
                ),
                visible: experience["service_include"] >= 2 ? true : false,
              ),
              SizedBox(height: 30.0,),
              Container(
                child: Text(
                  "Itinerario experiencia",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Quicksand Bold',
                      color: Color.fromRGBO(63, 63, 63, 1),
                      fontSize: 16
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              SizedBox(height: 30.0,),
              Divider(height: 1.0,),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: itinerary.length,
                  itemBuilder: (context, position) {
                    List itineraryItem = itinerary[position];
                    List<Widget> items = [];
                    itineraryItem.forEach((item) => items.add(Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset("images/check.png", height: 10, width: 10),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Text(
                            item["description"],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Quicksand Bold',
                              color: Color.fromRGBO(63, 67, 77, 1),
                              fontSize: 11
                            ),
                            overflow: TextOverflow.clip
                          ),
                        )
                      ],
                    )));

                    return Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Image.asset("images/elipse127.png", height: 10, width: 10),
                                    SizedBox(width: 10,),
                                    Text(
                                      "Day ${itineraryItem[0]["day_itinerary"]}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: 'Quicksand Bold',
                                        color: Color.fromRGBO(63, 67, 77, 1),
                                        fontSize: 11
                                      )
                                    ),
                                  ],
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Column(
                                  children: items,
                                ),
                                flex: 5
                              )
                            ],
                          )
                        ),
                        Divider(height: 1.0,)
                      ],
                    );
                  }
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 15)
              ),
              SizedBox(height: 30.0,),
              SizedBox(height: 20.0,),
              Container(
                margin: EdgeInsets.only(right: 20.0, left: 20.0),
                child: Image.asset("images/options.png")
              ),
              Container(
                margin: EdgeInsets.only(right: 20.0, left: 20.0),
                child: Image.asset("images/rate1.png")
              ),
              Container(
                margin: EdgeInsets.only(right: 20.0, left: 20.0),
                child: Image.asset("images/rate.png")
              ),
              SizedBox(height: 20.0,),
              Container(
                margin: EdgeInsets.only(right: 20.0, left: 20.0),
                child: Image.asset("images/comment.png")
              ),
              SizedBox(height: 20.0,),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 8.0, bottom: 8.0),
            child: Container(
              child: RaisedButton(
                color: Color.fromRGBO(250, 0, 60, 1),
                textColor: Colors.white,
                child: Text(
                  "hacer mi reserva",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                onPressed: showMenu,
              ),
              height: 50.0,
            ),
          ),
          endDrawer: DrawerState(),
        ),
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen()
            ),
          );
          return;
        },
    );
  }
}