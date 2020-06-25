import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodie/home_screen.dart';
import 'package:foodie/views/app_bar/app_bar_title.dart';
import 'package:foodie/views/app_bar/app_bottom_bar.dart';
import 'package:foodie/views/home/drawer_state.dart';

class Pqrs extends StatefulWidget {
  _Pqrs createState() => new _Pqrs();
}

class _Pqrs extends State<Pqrs>
{
  TextEditingController nickCtrl  = new TextEditingController();
  TextEditingController nameCtrl  = new TextEditingController();
  TextEditingController emailCtrl = new TextEditingController();
  TextEditingController documentCtrl  = new TextEditingController();
  TextEditingController cellphoneCtrl = new TextEditingController();
  TextEditingController messageCtrl = new TextEditingController();

  TextStyle textFieldStyle = TextStyle(
    fontSize: 14,
    color: Color.fromRGBO(193, 191, 202, 1)
  );
  
  String dropdownValue = 'Petición';

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
        title: AppBarTitle(content: Pqrs())
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Spacer(flex: 2,),
            Container(
              child: Text(
                "PQRS",
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
              child: Text(
                "Déjanos tu mensaje y te responderemos lo más pronto posible",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Quicksand Bold',
                    color: Color.fromRGBO(120, 119, 127, 1),
                    fontSize: 12
                )
              ),
            ),
            Spacer(),
            Container(
              child: TextField(
                controller: nickCtrl,
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
              height: 50.0,
            ),
            Spacer(),
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
              child: DropdownButtonHideUnderline(
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
                  underline: Container(
                    height: 1,
                    color: Color.fromRGBO(173, 192, 202, 1),
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['Petición', 'Quejas', "Reclamos", "Sugerencias"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              height: 50.0,
            ),
            Spacer(),
            Container(
              child: TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  hintText: "Correo electrónico",
                  hintStyle: TextStyle(
                    fontSize: 14, 
                    color: Color.fromRGBO(193, 191, 202, 1)
                  ),
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
              height: 50.0,
            ),
            Spacer(),
            Container(
              child: TextField(
                controller: cellphoneCtrl,
                decoration: InputDecoration(
                  hintText: "Número de celular (opcional)",
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
              height: 50.0,
            ),
            Spacer(),
            Expanded(
              child: Container(
                child: TextField(
                  controller: messageCtrl,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Tu mensaje",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(193, 191, 202, 1),
                    ),
                    contentPadding: EdgeInsets.all(20.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(193, 191, 202, 1),
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(50.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(250, 0, 60, 1),
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(50.0)
                    )
                  )
                ),
              ),
              flex: 10,
            ),
            Spacer(),
            Container(
              child: MaterialButton(
                child: Text(
                  "Enviar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),
                ),
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: "Pqrs enviado satisfactoriamente!",
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
                height: 50,
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