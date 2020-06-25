
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/home_screen.dart';
import 'package:foodie/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreen createState() => new _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen>
{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _success = "false";
  String _userID = "no logged yet";
  String accessToken = "n/n";
  
  final nameController  = TextEditingController();
  final emailController = TextEditingController();
  final passController  = TextEditingController();

  bool terms = false;
  bool visibility = false;

  @override
  void initState() {
    super.initState();
    terms = false;
  }

  saveOnPreferences(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      'session',
      true
    );
    await prefs.setString(
      'email',
      data["email"]
    );
    await prefs.setString(
      'token',
      data["pass"]
    );
    await prefs.setString(
      'image',
      data["image"]
    );
    await prefs.setString(
      'name',
      data["name"]
    );
    await prefs.setString(
      'id_user',
      data["id_user"].toString()
    );
  }

  signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    var response = await Http.post(
      'http://api.foodie.quality.datia.co/users/loginGoogle',
      body: {
        "pass": googleAuth.idToken.toString()
    });

    setState(() {
      accessToken = googleAuth.idToken.toString();
      if (user != null) {
        _success = true.toString();
        _userID = user.uid;

        Map map = jsonDecode(response.body);
        Map data = map["data"];

        saveOnPreferences({
          "email": data["email"],
          "token": accessToken,
          "image": "",
          "name": data["name"],
          "idUser": data["id_user"]
        });
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        _success = false.toString();
      }
    });
  }

  doFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    await facebookLogin.logOut();

    var result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        String token = result.accessToken.token;
        String userId = result.accessToken.userId;

        final graphResponse = await Http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'
        );

        var profile = jsonDecode(graphResponse.body) as Map;

        Map<String, dynamic> data = {};
        data["urlProfileImg"] = "https://graph.facebook.com/v5.0/${userId}/picture?height=200&width=200";
        data["userData"] = profile;
        data["token"] = token;

        var response = await Http.post(
          'http://api.foodie.quality.datia.co/users/loginFacebook',
          body: {
            "email": profile["email"],
            "pass": token,
            "name": profile["name"],
            "access_type": "0"
        });

        Map map = jsonDecode(response.body);
        await saveOnPreferences({
          "email": profile["email"],
          "pass": token,
          "image": "https://graph.facebook.com/v5.0/${userId}/picture",
          "name": profile["name"]
        });

        return data;
      case FacebookLoginStatus.cancelledByUser:
        return false;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        return false;
    }
    return false;
  }


  registerUser() async {
    if (nameController.text == "") {
      Fluttertoast.showToast(
          msg: "Nombre es obligatorio",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 2,
          backgroundColor: Color.fromRGBO(64, 0, 15, 1),
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }

    if (emailController.text == "") {
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

    if (passController.text == "") {
      Fluttertoast.showToast(
          msg: "Contraseña es obligatorio",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 2,
          backgroundColor: Color.fromRGBO(64, 0, 15, 1),
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }

    if (!terms) {
      Fluttertoast.showToast(
          msg: "Tienes que aceptar los términos y condiciones",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 2,
          backgroundColor: Color.fromRGBO(64, 0, 15, 1),
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }

    var bytes = utf8.encode(passController.text); // data being hashed
    var digest = sha256.convert(bytes);

    var response = await Http.post(
        'http://api.foodie.quality.datia.co/users/registerUser',
        body: {
          "name_user": nameController.text,
          "email": emailController.text,
          "pass": digest.toString(),
          "access_type": "0"
        });

    Map map = jsonDecode(response.body);

    if (!map["return"] && map["status"] == 409) {
      Fluttertoast.showToast(
          msg: map["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Color.fromRGBO(64, 0, 15, 1),
          textColor: Colors.white,
          fontSize: 16.0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LogginScreen()
        ),
      );
    } else {
      print("->-> register " + map["data"].toString());
      await saveOnPreferences(map["data"]);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: null,
        resizeToAvoidBottomPadding: false,
        extendBody: true,
        body: new Column(children: <Widget>[
          Spacer(flex: 6,),
          Expanded(
            child: Container(
              child: Image.asset(
                "images/logo.png",
                width: 180.0,
              ),
            ),
            flex: 11,
          ),
          Spacer(flex: 2,),
          new Container(
            child: new Row(
              children: <Widget>[
                new Expanded(
                    child: new Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(40.0),
                            ),
                            color: Color.fromRGBO(250, 0, 60, 1)
                        ),
                        child: Center(
                          child: Text(
                              "Primera vez en Oh Foodie? Crea tu cuenta",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10
                              )
                          )
                        ),
                        height: 55.0,
                    )
                ),
                new Expanded(
                    child: new Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(40.0),
                          ),
                          border: Border.all(
                            width: 1, //
                            color: Color.fromRGBO(250, 0, 60, 1)//              <--- border width here
                          )
                      ),
                      child: Center(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LogginScreen())
                            );
                          },
                          child: Text(
                              "¡Ya tengo cuenta! Inicia sesión",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(250, 0, 60, 1),
                                  fontSize: 14
                              )
                          ),
                        )
                      ),
                      height: 55.0,
                    )
                )
              ],
            ),
            margin: EdgeInsets.only(left: 20, right: 20),
          ),
          new Container(
              child: Center(
                  child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                            Icons.people,
                            color: Color.fromRGBO(193, 191, 202, 1)
                        ),
                        hintText: "Nombre completo",
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
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color:  Color.fromRGBO(250, 0, 60, 1),
                            ),
                            borderRadius: BorderRadius.circular(50.0)
                        ),
                    )
                  )
              ),
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              height: 50.0,
          ),
          new Container(
            child: Center(
                child: TextField(
                    controller: emailController,
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
                        focusColor: Colors.amber,
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            height: 50.0,
          ),
          new Container(
            child: Center(
                child: TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Color.fromRGBO(193, 191, 202, 1)),
                        hintText: "Contraseña",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            height: 50.0,
          ),
          new Container(
            child: new Center(
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: terms,
                      onChanged: (bool value) {
                        setState(() {
                          terms = value;
                        });
                      },
                  ),
                  Expanded(
                    child: Text(
                        "Acepto los términos y condiciones y la política de privacidad.",
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
          Spacer(flex: 5,),
          new Container(
            //child: new Center(
              child: new MaterialButton(
                child: Text(
                  "Crear Cuenta",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),
                ),
                onPressed: () {
                  registerUser();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                color: Color.fromRGBO(250, 0, 60, 1),
                height: 50,
              ),
            //),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
                left: 20.0,
                right: 20.0
            ),
          ),
          new Container(
            child: Center(
              child: Text(
                  "o creala con",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(193, 191, 202, 1),
                      fontSize: 12
                  )
              ),
            ),
              margin: EdgeInsets.only(top: 20)
          ),
          new Container(
            child: new Center(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        var userData = doFacebookLogin();
                        if (userData != false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        child: Image.asset('images/facebook_icon.png'),
                        width: 70,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: null,
                      child: Container(
                        child: Image.asset('images/google_icon.png'),
                        width: 70,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                    ),
                  )
                ],
              ),
            ),
            margin: EdgeInsets.only(left: 70, right: 70),
          ),
          Spacer(flex: 3,)
      ])
    );
  }
}