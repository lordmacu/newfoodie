import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodie/views/home/drawer_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie/views/booking/booking_confirmation.dart';

class Runway extends StatefulWidget
{
  final String restaurant;

  Runway({
    Key key,
    this.restaurant
  }) : super(key: key);
  @override
  _Runway createState() => new _Runway();
}

class _Runway extends State<Runway>
{
  Map restaurant;
  int currentStep = 0;
  int groupValue = 5;
  String dropdownValue = 'Tipo documento';

  @override
  void initState() {
    setState(() {
      restaurant = jsonDecode(widget.restaurant);
    });
    super.initState();
  }

  var stepStateOne = StepState.editing;
  var stepStateTwo = StepState.editing;
  var stepStateThree = StepState.editing;

  var stepActiveOne   = false;
  var stepActiveTwo   = false;
  var stepActiveThree = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
        title: Text(""),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Stepper(
                  currentStep: currentStep,
                  onStepTapped: (currentStep) {
                    setState(() {
                      currentStep = currentStep;
                    });
                  },
                  controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                    return Row(
                      children: <Widget>[
                        currentStep < 2
                        ?
                        Container(
                          child: MaterialButton(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "Continuar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (currentStep == 0) {
                                if (nameController.text.toString() == "") {
                                  Fluttertoast.showToast(
                                    msg: "Nombre completo es obligatorio",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIos: 2,
                                    backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                  );
                                  return;
                                }
                                if (dropdownValue.toString() == "Tipo documento") {
                                  Fluttertoast.showToast(
                                    msg: "Tipo documento es obligatorio",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIos: 2,
                                    backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                  );
                                  return;
                                }
                                if (documentController.text.toString() == "") {
                                  Fluttertoast.showToast(
                                    msg: "Documento es obligatorio",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIos: 2,
                                    backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                  );
                                  return;
                                }
                                if (phoneController.text.toString() == "") {
                                  Fluttertoast.showToast(
                                    msg: "Celular es obligatorio",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIos: 2,
                                    backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                  );
                                  return;
                                }
                                if (emailController.text.toString() == "") {
                                  Fluttertoast.showToast(
                                    msg: "Correo es obligatorio",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIos: 2,
                                    backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                  );
                                  return;
                                }
                              }
                              setState(() {
                                currentStep += 1;
                                if (currentStep > 0) {
                                  stepStateOne = StepState.complete;
                                  stepActiveOne = true;
                                  stepActiveTwo = false;
                                  stepActiveThree = false;
                                }
                                if (currentStep > 1) {
                                  stepStateOne = StepState.complete;
                                  stepActiveOne = false;
                                  stepActiveTwo = true;
                                  stepActiveThree = false;
                                }
                                if (currentStep > 2) {
                                  stepStateOne = StepState.complete;
                                  stepActiveOne = false;
                                  stepActiveTwo = false;
                                  stepActiveThree = true;
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            ),
                            color: Color.fromRGBO(250, 0, 60, 1),
                            height: 30,
                          ),
                          margin: EdgeInsets.only(top: 20.0),
                        )
                        :
                        Container(), 
                        Container(
                          child: MaterialButton(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "Volver",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                if (currentStep > 0) {
                                  currentStep -= 1;
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            ),
                            color: Color.fromRGBO(120, 119, 127, 1),
                            height: 30,
                          ),
                          margin: EdgeInsets.only(top: 20.0, left: 10.0),
                        ),
                      ],
                    );
                  },
                  onStepContinue: () {

                  },
                  onStepCancel: () {

                  },
                  steps: [
                    Step(
                      state: stepStateOne,
                      isActive: stepActiveOne,
                      title: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Información de facturación",
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Bold',
                                  color: Color.fromRGBO(63, 67, 77, 1),
                                  fontSize: 14
                              )
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.height * 0.3,
                              child: Text(
                                "Diligencia la información a continuación para completar tu reserva.",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Quicksand regular',
                                    color: Color.fromRGBO(63, 67, 77, 1),
                                    fontSize: 10
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                      content: Column(
                        children: <Widget>[
                          Container(
                            child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    hintText: "Nombre completo",
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
                                ),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                            height: 50.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40.0),
                                  topLeft:  Radius.circular(40.0),
                                  bottomLeft: Radius.circular(40.0),
                                  bottomRight: Radius.circular(40.0)
                              ),
                              border: Border.all(
                                  width: 1, //
                                  color: Color.fromRGBO(193, 191, 202, 1)//              <--- border width here
                              )
                            ),
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
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
                                  fontSize: 14
                              ),
                              /*underline: Container(
                                height: 1,
                                color: Color.fromRGBO(173, 192, 202, 1),
                              ),*/
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>['Tipo documento', 'Cedula', 'Pasaporte']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                            height: 50.0,
                          ),
                          Container(
                            child: TextField(
                                controller: documentController,
                                decoration: InputDecoration(
                                    hintText: "Numero de documento",
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
                                ),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                            height: 50.0,
                          ),
                          Container(
                            child: TextField(
                                controller: phoneController,
                                decoration: InputDecoration(
                                    hintText: "Numero de celular",
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
                                ),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                            height: 50.0,
                          ),
                          Container(
                            child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                    hintText: "Correo electronico",
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
                                ),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                            height: 50.0,
                          )
                        ],
                      ),
                    ),
                    Step(
                      state: stepStateOne,
                      //isActive: stepActiveTwo,
                      title: Text(
                        "Método de pago",
                        maxLines: 2,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 67, 77, 1),
                            fontSize: 14
                        )
                      ),
                      content: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 0,
                                onChanged: (state) {
                                  setState(() {
                                    groupValue = 0;
                                  });
                                },
                                groupValue: groupValue,
                              ),
                              Text(
                                "Tarjeta de crédito",
                                maxLines: 2,
                                style: TextStyle(
                                    fontFamily: 'Quicksand Bold',
                                    color: Color.fromRGBO(63, 67, 77, 1),
                                    fontSize: 14
                                )
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 1,
                                onChanged: (state) {
                                  setState(() {
                                    groupValue = 1;
                                  });
                                },
                                groupValue: groupValue,
                              ),
                              Text(
                                "RedServi",
                                maxLines: 2,
                                style: TextStyle(
                                    fontFamily: 'Quicksand Bold',
                                    color: Color.fromRGBO(63, 67, 77, 1),
                                    fontSize: 14
                                )
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 2,
                                onChanged: (state) {
                                  setState(() {
                                    groupValue = 2;
                                  });
                                },
                                groupValue: groupValue,
                              ),
                              Container(
                                width: 200,
                                child: Text(
                                  "Transferencia o consignación bancaria",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: 'Quicksand Bold',
                                      color: Color.fromRGBO(63, 67, 77, 1),
                                      fontSize: 14
                                  )
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 3,
                                onChanged: (state) {
                                  setState(() {
                                    groupValue = 3;
                                  });
                                },
                                groupValue: groupValue,
                              ),
                              Text(
                                "Pagos PSE",
                                maxLines: 2,
                                style: TextStyle(
                                    fontFamily: 'Quicksand Bold',
                                    color: Color.fromRGBO(63, 67, 77, 1),
                                    fontSize: 14
                                )
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 4,
                                onChanged: (state) {
                                  setState(() {
                                    groupValue = 4;
                                  });
                                },
                                groupValue: groupValue,
                              ),
                              Text(
                                "Brinks Cash-e Commerce",
                                maxLines: 2,
                                style: TextStyle(
                                    fontFamily: 'Quicksand Bold',
                                    color: Color.fromRGBO(63, 67, 77, 1),
                                    fontSize: 14
                                )
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 5,
                                onChanged: (state) {
                                  setState(() {
                                    groupValue = 5;
                                  });
                                },
                                groupValue: groupValue,
                              ),
                              Text(
                                "Reservar sin costo",
                                maxLines: 2,
                                style: TextStyle(
                                    fontFamily: 'Quicksand Bold',
                                    color: Color.fromRGBO(63, 67, 77, 1),
                                    fontSize: 14
                                )
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Step(
                      isActive: stepActiveThree,
                      state: stepStateThree,
                      title: Text(
                              "Confirmación",
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Quicksand Bold',
                                  color: Color.fromRGBO(63, 67, 77, 1),
                                  fontSize: 14
                              )
                            ),
                      content: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      "Restaurante",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Bold',
                                          color: Color.fromRGBO(120, 119, 127, 1),
                                          fontSize: 12
                                      )
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      restaurant["name_restaurant"],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Regular',
                                          color: Color.fromRGBO(120, 119, 127, 1),
                                          fontSize: 12
                                      )
                                  ),
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(193, 191, 202, 1),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      "Lugar",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Bold',
                                          color: Color.fromRGBO(120, 119, 127, 1),
                                          fontSize: 12
                                      )
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      restaurant["address"],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Regular',
                                          color: Color.fromRGBO(120, 119, 127, 1),
                                          fontSize: 12
                                      )
                                  ),
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(193, 191, 202, 1),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      "Fecha",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Bold',
                                          color: Color.fromRGBO(120, 119, 127, 1),
                                          fontSize: 12
                                      )
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      restaurant["booking_date"],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Regular',
                                          color: Color.fromRGBO(120, 119, 127, 1),
                                          fontSize: 12
                                      )
                                  ),
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(193, 191, 202, 1),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      "Hora",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Bold',
                                          color: Color.fromRGBO(120, 119, 127, 1),
                                          fontSize: 12
                                      )
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      restaurant["booking_time"],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Regular',
                                          color: Color.fromRGBO(120, 119, 127, 1),
                                          fontSize: 12
                                      )
                                  ),
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                          ),
                          Container(
                            child: Divider(
                              color: Color.fromRGBO(193, 191, 202, 1),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      "# de personas",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Bold',
                                          color: Color.fromRGBO(120, 119, 127, 1),
                                          fontSize: 12
                                      )
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      restaurant["person_number"],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Regular',
                                          color: Color.fromRGBO(120, 119, 127, 1),
                                          fontSize: 12
                                      )
                                  ),
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      "Valor de reserva",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Bold',
                                          color: Color.fromRGBO(120, 119, 127, 1),
                                          fontSize: 12
                                      )
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      "0",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand Regular',
                                          color: Color.fromRGBO(120, 119, 127, 1),
                                          fontSize: 12
                                      )
                                  ),
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: new MaterialButton(
                  child: Text(
                    "Confirmar y finalizar",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                  onPressed: () async {
                    restaurant["name_owner"] = nameController.text.toString();
                    restaurant["email_owner"] = emailController.text.toString();
                    restaurant["phone_owner"] = phoneController.text.toString();
                    restaurant["document_owner"] = documentController.text.toString();
                    
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String id = prefs.getString("id_user");

                    var response = await Http.post(
                        'http://api.foodie.quality.datia.co/reservations/saveReservation',
                      body: {
                        "id_user": id.toString(),
                        "id_restaurant_reservation": restaurant["id_restaurant"].toString(),
                        "date_reservation": restaurant["booking_date"].toString(),
                        "hour_reservation": "04:05",//restaurant["booking_time"].toString(),
                        "number_people_reservation": restaurant["person_number"].toString(),
                        "total_reservation": "200000"
                      });
                    
                    print(" response reserva " + jsonDecode(response.body).toString());

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingConfirmation(restaurant: jsonEncode(restaurant))),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  color: Color.fromRGBO(250, 0, 60, 1),
                ),
                //),
                margin: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 20.0
                ),
              ),
          ],
        ),
      ),
      endDrawer: DrawerState()
    );
  }
}