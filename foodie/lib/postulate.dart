

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/home/drawer_state.dart';

class Postulate extends StatefulWidget
{
  _Postulate createState() => _Postulate();
}

class _Postulate extends State<Postulate>
{
  int group = 0;
  bool terms = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController restaurantCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController foodTypeCtrl = TextEditingController();
  TextEditingController ownerNameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
        title: AppBarTitle(content: Postulate())
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(width: 20.0,),
            Container(
              margin: EdgeInsets.only(right: 40.0, left: 40.0, top: 20.0, bottom: 20.0),
              child: Text(
                "COMPLETA LA INFORMACIÓN",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Quicksand Bold',
                    color: Color.fromRGBO(63, 63, 63, 1),
                    fontSize: 14
                )
              ),
            ),
            SizedBox(width: 20.0,),
            Container(
              margin: EdgeInsets.only(right: 40.0, left: 40.0),
              child: Text(
                "Ingresa la información requerida acerca de tu restaurante para postularlo.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Quicksand Light',
                    color: Color.fromRGBO(63, 63, 63, 1),
                    fontSize: 12
                )
              ),
            ),
            SizedBox(width: 20.0,),
            Container(
              margin: EdgeInsets.only(right: 40.0, left: 40.0, top: 10, bottom: 10),
              child: Text(
                "Nombre del restaurante",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Quicksand Bold',
                    color: Color.fromRGBO(63, 63, 63, 1),
                    fontSize: 12
                )
              ),
            ),
            Container(
              child: TextFormField(
                controller: restaurantCtrl,
                decoration: InputDecoration(
                    hintText: "Nombre del restaurante",
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
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(193, 191, 202, 1),
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(50.0)
                    ),
                    errorStyle: TextStyle(fontSize: 10, color: Colors.red)
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Debes agregar un nombre de restaurante';
                  }
                  return null;
                },
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 70.0,
            ),
            Container(
              margin: EdgeInsets.only(right: 40.0, left: 40.0, top: 10, bottom: 10),
              child: Text(
                "Ciudad",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Quicksand Bold',
                    color: Color.fromRGBO(63, 63, 63, 1),
                    fontSize: 12
                )
              ),
            ),
            Container(
              child: TextFormField(
                  controller: cityCtrl,
                  decoration: InputDecoration(
                    hintText: "Ciudad",
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
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(193, 191, 202, 1),
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(50.0)
                    ),
                    errorStyle: TextStyle(fontSize: 10, color: Colors.red)
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Debes agregar una ciudad';
                    }
                    return null;
                  },
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 70.0,
            ),
            Container(
              margin: EdgeInsets.only(right: 40.0, left: 40.0, top: 10, bottom: 10),
              child: Text(
                "Dirección",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Quicksand Bold',
                    color: Color.fromRGBO(63, 63, 63, 1),
                    fontSize: 12
                )
              ),
            ),
            Container(
              child: TextFormField(
                  controller: addressCtrl,
                  decoration: InputDecoration(
                    hintText: "Dirección",
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
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(193, 191, 202, 1),
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(50.0)
                    ),
                    errorStyle: TextStyle(fontSize: 10, color: Colors.red)
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Debes agregar una dirección';
                    }
                    return null;
                  },
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 70.0,
            ),
            Container(
              margin: EdgeInsets.only(right: 40.0, left: 40.0, top: 10, bottom: 10),
              child: Text(
                "Tipo de comida",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Quicksand Bold',
                  color: Color.fromRGBO(63, 63, 63, 1),
                  fontSize: 12
                )
              ),
            ),
            Container(
              child: TextFormField(
                controller: foodTypeCtrl,
                decoration: InputDecoration(
                  hintText: "Tipo de comida",
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
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(193, 191, 202, 1),
                      width: 1
                    ),
                    borderRadius: BorderRadius.circular(50.0)
                  ),
                  errorStyle: TextStyle(fontSize: 10, color: Colors.red),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Debes agregar una tipo de comida';
                  }
                  return null;
                },
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 70.0,
            ),
            Container(
              margin: EdgeInsets.only(right: 40.0, left: 40.0, top: 10, bottom: 10),
              child: Text(
                "Nombre de dueño",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Quicksand Bold',
                    color: Color.fromRGBO(63, 63, 63, 1),
                    fontSize: 12
                )
              ),
            ),
            Container(
              child: TextFormField(
                controller: ownerNameCtrl,
                decoration: InputDecoration(
                  hintText: "Nombre de dueño",
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
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(193, 191, 202, 1),
                      width: 1
                    ),
                    borderRadius: BorderRadius.circular(50.0)
                  ),
                  errorStyle: TextStyle(fontSize: 10, color: Colors.red)
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Debes agregar un nombre del dueño';
                  }
                  return null;
                },
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 70.0,
            ),
            Container(
              margin: EdgeInsets.only(right: 40.0, left: 40.0, top: 10, bottom: 10),
              child: Text(
                "Teléfono",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Quicksand Bold',
                    color: Color.fromRGBO(63, 63, 63, 1),
                    fontSize: 12
                )
              ),
            ),
            Container(
              child: TextFormField(
                  controller: phoneCtrl,
                  decoration: InputDecoration(
                    hintText: "Teléfono",
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
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(193, 191, 202, 1),
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(50.0)
                    ),
                    errorStyle: TextStyle(fontSize: 10, color: Colors.red)
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Debes agregar un teléfono';
                    }
                    return null;
                  },
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 70.0,
            ),
            Container(
              margin: EdgeInsets.only(right: 40.0, left: 40.0, top: 10, bottom: 10),
              child: Text(
                "Correo",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Quicksand Bold',
                    color: Color.fromRGBO(63, 63, 63, 1),
                    fontSize: 12
                )
              ),
            ),
            Container(
              child: TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                      hintText: "Correo",
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
                      ),
                      errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(193, 191, 202, 1),
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(50.0)
                    ),
                    errorStyle: TextStyle(fontSize: 10, color: Colors.red)
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Debes agregar un correo';
                    }
                    return null;
                  },
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 70.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        "Tiene sistema de reservas web?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            color: Color.fromRGBO(63, 63, 63, 1),
                            fontSize: 11
                        )
                      ),
                    ),
                    flex: 6,
                  ),
                  Expanded(
                    child: Text(
                      "Si"
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Radio(
                    value: 0,
                      groupValue: group,
                      onChanged: (value) {
                        setState(() {
                          group = value;
                          print("Group: ${group.toString()}");
                        });
                      },
                    )
                  ),
                  Expanded(
                    child: Text(
                      "No"
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Radio(
                      value: 1,
                      groupValue: group,
                      onChanged: (value) {
                        setState(() {
                          group = value;
                          print("Group: ${group.toString()}");
                        });
                      },
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Container(
              child: new Center(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          "Al completar este formulario, nos pondremos en contacto contigo para continuar con el proceso de postulación.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(193, 191, 202, 1),
                            fontSize: 12
                          )
                      ),
                    ),
                  ],
                ),
              ),
              margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            ),
            SizedBox(height: 20.0,),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                color: Color.fromRGBO(250, 0, 60, 1),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Enviar postulación",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Fluttertoast.showToast(
                      msg: "Restaurante postulado satisfactoriamente!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 2,
                      backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen()
                      )
                    );
                    return true;
                  } else {
                    return false;
                  }
                },
              ),
            )
          ],
        ),
      ),
      endDrawer: DrawerState(),
      bottomNavigationBar: AppBottomBar(tabSelected: 1,),
    );
  }
}