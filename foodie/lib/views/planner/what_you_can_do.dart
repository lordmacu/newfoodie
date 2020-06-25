import 'package:flutter/material.dart';
import 'package:foodie/planner.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/planner/planner_list.dart';

class WhatYouCanDo extends StatefulWidget
{
  @override
  _WhatYouCanDo createState() => _WhatYouCanDo();
}

class _WhatYouCanDo extends State<WhatYouCanDo>
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
        title: AppBarTitle(content: WhatYouCanDo()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Spacer(flex: 2,),
          Container(
            width: 180.0,
            child: Text(
              "QUÉ PUEDES HACER EN TU PLANNER?",
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
            width: 180.0,
            child: Text(
              "1",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand Bold',
                color: Color.fromRGBO(250, 0, 60, 1),
                fontSize: 28
              ),
              maxLines: 2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 40.0, left: 40.0),
            child: Text(
              "Puedes guardar cualquier restaurante que encuentres en nuestra plataforma, para luego agendar tu visita cuando desees.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Quicksand REGULAR',
                  color: Color.fromRGBO(63, 63, 63, 1),
                  fontSize: 12
              )
            ),
          ),
          Spacer(flex: 2,),
          Container(
            width: 180.0,
            child: Text(
              "2",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand Bold',
                color: Color.fromRGBO(250, 0, 60, 1),
                fontSize: 28
              ),
              maxLines: 2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 40.0, left: 40.0),
            child: Text(
              "Puedes agendar las visitas a tus restaurantes guardados seleccionando la fecha y horario en que deseas visitarlos (desayuno, almuerzo, cena).",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Quicksand REGULAR',
                  color: Color.fromRGBO(63, 63, 63, 1),
                  fontSize: 12
              )
            ),
          ),
          Spacer(flex: 2,),
          Container(
            width: 180.0,
            child: Text(
              "3",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand Bold',
                color: Color.fromRGBO(250, 0, 60, 1),
                fontSize: 28
              ),
              maxLines: 2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 40.0, left: 40.0),
            child: Text(
              "Puedes recibir recomendaciones sobre lugares que podrías visitar basado en la cercanía a los lugares que ya has agregado a tu agenda.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Quicksand REGULAR',
                  color: Color.fromRGBO(63, 63, 63, 1),
                  fontSize: 12
              )
            ),
          ),
          Spacer(flex: 3,),
          Container(
            margin: EdgeInsets.only(right: 40.0, left: 40.0),
            child: Text(
              "Estás listo para comenzar?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Quicksand Bold',
                  color: Color.fromRGBO(63, 63, 63, 1),
                  fontSize: 14
              )
            ),
          ),
          Spacer(flex: 1,),
          Container(
            child: MaterialButton(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "!Si, quiero comenzar!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PlannerList()
                ));
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
          Spacer(flex: 1,)
        ],
      ),
      bottomNavigationBar: AppBottomBar(tabSelected: 2,)
    );
  }
}