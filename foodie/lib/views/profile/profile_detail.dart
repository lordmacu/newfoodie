import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/home/drawer_state.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetail extends StatefulWidget {
  _ProfileDetail createState() => new _ProfileDetail();
}

class _ProfileDetail extends State<ProfileDetail>
{
  TextStyle textFieldStyle = TextStyle(
    fontSize: 13,
    color: Color.fromRGBO(193, 191, 202, 1)
  );

  TextEditingController nickCtrl  = new TextEditingController();
  TextEditingController nameCtrl  = new TextEditingController();
  TextEditingController emailCtrl = new TextEditingController();
  TextEditingController idCtrl = new TextEditingController();
  TextEditingController celCtrl = new TextEditingController();
  TextEditingController passCtrl = new TextEditingController();

  var _image;

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = FileImage(image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        title: AppBarTitle(content: ProfileDetail())
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Spacer(flex: 2),
            Container(
              child: Text(
                "PERFIL",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: 'Quicksand Bold',
                    color: Color.fromRGBO(120, 119, 127, 1),
                    fontSize: 16
                )
              ),
            ),
            Spacer(),
            Container(
              child: CircleAvatar(
                backgroundImage: _image == null ? AssetImage(
                  "images/man.png"
                ) : _image,
                radius: 40.0,
              )
            ),
            Spacer(flex: 2,),
            Container(
              width: 120.0,
              child: MaterialButton(
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "images/camara_01.png",
                      width: 15.0,
                      color: Colors.white,
                    ),
                    Spacer(),
                    Text(
                      "cambiar foto",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  print("what the bleed do we know");
                  getImage();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                color: Color.fromRGBO(250, 0, 60, 1),
                height: 30,
                minWidth: double.infinity,
              ),
            ),
            Spacer(),
            Container(
              child: TextField(
                controller: nickCtrl,
                decoration: InputDecoration(
                  hintText: "Nick de usuario",
                  hintStyle: textFieldStyle,
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
              height: 45.0,
            ),
            Spacer(),
            Container(
              child: TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  hintText: "Nombre de usuario",
                  hintStyle: textFieldStyle,
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
              height: 45.0,
            ),
            Spacer(),
            Container(
              child: TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  hintText: "Correo electrónico",
                  hintStyle: textFieldStyle,
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
              height: 45.0,
            ),
            Spacer(),
            Container(
              child: TextField(
                controller: idCtrl,
                decoration: InputDecoration(
                  hintText: "Número de documento",
                  hintStyle: textFieldStyle,
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
              height: 45.0,
            ),
            Spacer(),
            Container(
              child: TextField(
                controller: celCtrl,
                decoration: InputDecoration(
                  hintText: "Número de celular",
                  hintStyle: textFieldStyle,
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
              height: 45.0,
            ),
            Spacer(),
            Container(
              child: TextField(
                  controller: passCtrl,
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: textFieldStyle,
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
                  obscureText: true,
              ),
              height: 45.0,
            ),
            Spacer(),
            Container(
              child: MaterialButton(
                child: Text(
                  "Guardar Cambios",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),
                ),
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "Perfil guardado exitosamente",
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
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                color: Color.fromRGBO(250, 0, 60, 1),
                height: 45.0,
                minWidth: double.infinity,
              ),
            ),
            Spacer()
          ],
        ),
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
      ),
      endDrawer: DrawerState(),
      bottomNavigationBar: AppBottomBar(tabSelected: 3,)
    );
  }
}