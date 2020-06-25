import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPassword extends StatefulWidget
{
  @override
  _ForgetPassword createState() => _ForgetPassword();
}

class _ForgetPassword extends State<ForgetPassword>
{
  TextEditingController mailCtrl = TextEditingController();

  doForgetPassword() async {
    var response = await Http.post(
      'http://api.foodie.quality.datia.co/users/forgotpassword',
      body: {
        "email": mailCtrl.text.toString(),
        "route": "0"
      });
  }

  @override
  Widget build(BuildContext context) {
    showArrivePopUp() {
      showDialog(
        context: context,
        builder: (ctx) {
          return Container(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20)
                )
              ),
              content: Container(
                height: 220.0,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          "images/mail_safe.png"
                        ),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "¡Lo tenemos!",
                          style: TextStyle(
                            color: Color.fromRGBO(250, 0, 60, 1),
                            fontSize: 16
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Descubre los mejores restaurantes y platos a tu alrededor.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(120, 119, 120, 1),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Spacer(flex: 1,),
                    Expanded(
                      child: Container(
                        child: MaterialButton(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "¡Listo!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LogginScreen()),
                            );
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          color: Color.fromRGBO(250, 0, 60, 1),
                          height: 50,
                          minWidth: double.infinity,
                        ),
                        //margin: EdgeInsets.only(left: 20, right: 5),
                      ),
                      flex: 2,
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                
              ],
            ),
          );
        }
      );
    }

    return new Scaffold(
      appBar: null,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Spacer(flex: 10,),
          Center(
            child: new Container(
              child: Image.asset("images/logo.png"),
              height: 55.0,
            ),
          ),
          Spacer(flex: 3,),
          Center(
            child: new Container(
              child: Image.asset("images/pass_icon.png"),
              height: 80.0,
            ),
          ),
          Spacer(flex: 3),
          Center(
            child: new Container(
              child: Text(
                  "Olvidaste tu contraseña?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(250, 0, 60, 1),
                      fontSize: 14
                  )
              ),
            ),
          ),
          Spacer(flex: 2,),
          Center(
            child: new Container(
              child: Text(
                  "Ingresa tu correo electrónico para poder restablecerla.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Quicksand Regular',
                      color: Color.fromRGBO(63, 63, 63, 1),
                      fontSize: 14
                  )
              ),
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
            ),
          ),
          Spacer(flex: 2,),
          Container(
            child: Center(
              child: TextField(
                controller: mailCtrl,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail, color: Color.fromRGBO(193, 191, 202, 1)),
                  hintText: "Correo electrónico",
                  hintStyle: TextStyle(fontSize: 14, color: Color.fromRGBO(193, 191, 202, 1)),
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
              )
            ),
            margin: EdgeInsets.only(left: 20, right: 20),
            height: 50.0,
          ),
          Spacer(flex: 10,),
          new Container(
            child: new MaterialButton(
              child: Text(
                "Recuperar Contraseña",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
              onPressed: () async {
                if (mailCtrl.text.toString() == "") {
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
                await doForgetPassword();
                showArrivePopUp();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              ),
              color: Color.fromRGBO(250, 0, 60, 1),
              height: 50,
            ),
            margin: EdgeInsets.only(
                left: 20.0,
                right: 20.0
            ),
            width: MediaQuery.of(context).size.width,
          ),
          Spacer(flex: 1,),
          new Container(
            //child: new Center(
            child: new MaterialButton(
              child: Text(
                "Regresar al inicio de sesión",
                style: TextStyle(
                    color: Color.fromRGBO(250, 0, 60, 1),
                    fontSize: 16
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogginScreen()),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                  side: BorderSide(color: Color.fromRGBO(250, 0, 60, 1))
              ),
              height: 50,
              
            ),
            //),
            margin: EdgeInsets.only(
                left: 20.0,
                right: 20.0
            ),
            width: MediaQuery.of(context).size.width,
          ),
          Spacer(flex: 6,)
        ],
      ),
    );
  }
}