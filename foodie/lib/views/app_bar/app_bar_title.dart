import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:shared_preferences/shared_preferences.dart';

class AppBarTitle extends StatefulWidget {

  final String city = "BOGOTÁ";
  final content;

  AppBarTitle({
    Key key,
    @required
    this.content
  }) : super(key: key);

  @override
  _AppBarTitle createState() => new _AppBarTitle();
}

class _AppBarTitle extends State<AppBarTitle> {

  List citiesFromService = [];
  String dropdownValue = 'BOGOTÁ';
  List<DropdownMenuItem<String>> citiesList = [];
  
  @override
  void initState() {
    _getCities();
    super.initState();
  }

  _getCities() async {
    var response = await Http.post(
      'http://api.foodie.quality.datia.co/city/allCitysWithRestaurants',
      body: {}
    );

    Map data = jsonDecode(response.body);
    List<DropdownMenuItem<String>> aux = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      dropdownValue = prefs.getString("selectedCityName");
      citiesFromService = data["data"];
      citiesFromService.forEach((item) => aux.add(DropdownMenuItem<String>(
        value: item["city"],
        child: Text(item["city"]),
      )));
      citiesList = aux;
    });
  }

  _saveSelectedCity(int city, String cityName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("selectedCity", city);
    pref.setString("selectedCityName", cityName);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            border: Border.all(
              width: 1, //
              color: Color.fromRGBO(193, 191, 202, 1)//              <--- border width here
            )
        ),
        child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                          Icons.place,
                          color: Color.fromRGBO(173, 192, 202, 1)
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "A que ciudad vas a viajar?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(173, 192, 202, 1),
                            fontSize: 7
                        ),
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
                flex: 1,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Image.asset("images/flag.png"),
                      margin: EdgeInsets.only(
                          top: 10,
                          bottom: 10
                      ),
                    ),
                    Container(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromRGBO(173, 192, 202, 1),
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: Color.fromRGBO(173, 192, 202, 1),
                            fontSize: 10
                        ),
                        underline: Container(
                          height: 1,
                          color: Color.fromRGBO(173, 192, 202, 1),
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            for (int i = 0; i < citiesFromService.length; i++) {
                              var item = citiesFromService[i];
                              if (item["city"] == newValue) {
                                _saveSelectedCity(item["id"], item["city"]);
                                break;
                              }
                            }
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => widget.content
                            ));
                          });
                        },
                        items: citiesList,
                      ),
                    )
                  ],
                ),
                flex: 2,
              ),
            ]
        ),
        margin: EdgeInsets.only(top: 8, bottom: 8),
      );
  }
}