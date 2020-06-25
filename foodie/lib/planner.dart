import 'package:flutter/material.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/planner/planner_list.dart';
import 'package:foodie/views/planner/what_you_can_do.dart';

class Planner extends StatefulWidget
{
  @override
  _Planner createState() => _Planner();
}

class _Planner extends State<Planner>
{

  String dropdownValue = 'Bogotá.dc';
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return new Container(
                child: Image.asset("images/isotipo.png"),
                margin: EdgeInsets.only(top: 12, bottom: 12)
            );
          },
        ),
        title: AppBarTitle(content: Planner()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Spacer(flex: 2,),
          Container(
            child: Center(
              child: Image.asset("images/icon_intro_planner.png", width: 100,),
            )
          ),
          Spacer(flex: 1,),
          Container(
            width: 180.0,
            child: Text(
              "BIENVENIDO A TU PLANNER!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand Bold',
                color: Color.fromRGBO(250, 0, 60, 1),
                fontSize: 16
              ),
              maxLines: 2,
            ),
          ),
          Spacer(flex: 1,),
          Container(
            margin: EdgeInsets.only(right: 40.0, left: 40.0),
            child: Text(
              "El espacio donde organizar y programar tus visitas a los mejores restaurantes está siempre en tu bolsillo.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Quicksand REGULAR',
                  color: Color.fromRGBO(63, 63, 63, 1),
                  fontSize: 16
              )
            ),
          ),
          Spacer(flex: 2,),
          Container(
            child: MaterialButton(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "Que puedo hacer aquí?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WhatYouCanDo()
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              ),
              color: Color.fromRGBO(250, 0, 60, 1),
              height: 50,
              minWidth: double.infinity,
            ),
            margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
          ),
          Container(
            margin: EdgeInsets.only(right: 20.0, left: 20.0),
            child: MaterialButton(
              child: Text(
                "¡Quiero ir ahora a mi planner!",
                style: TextStyle(
                  color: Color.fromRGBO(250, 0, 60, 1),
                  fontSize: 16
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PlannerList()
                ));
              },
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(50.0),
                side: BorderSide(color: Color.fromRGBO(250, 0, 60, 1))
              ),
              height: 50,
              minWidth: double.infinity,
            ),
          ),
          Spacer(flex: 2,)
        ],
      ),
      bottomNavigationBar: AppBottomBar(tabSelected: 2,)
    );
  }
}