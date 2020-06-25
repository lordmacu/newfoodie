import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crypto/crypto.dart';
import 'package:loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as Http;
import 'package:foodie/home_screen.dart';
import 'package:foodie/forget_password.dart';
import 'package:foodie/register_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LogginScreen extends StatefulWidget {
  @override
  _LogginScreen createState() => _LogginScreen();
}

class _LogginScreen extends State<LogginScreen>
{
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _success = "false";
  String _userID = "no logged yet";
  String accessToken = "n/n";

  bool visibility = false;

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

    Map map = jsonDecode(response.body);
    Map data = map["data"];

    await saveOnPreferences({
      "email": data["email"],
      "token": accessToken,
      "image": "",
      "name": data["name"],
      "id_user": data["id_user"]
    });

    print("la login " + {
      "email": data["email"],
      "token": accessToken,
      "image": "",
      "name": data["name"],
      "idUser": data["id_user"]
    }.toString());

    setState(() {
      accessToken = googleAuth.idToken.toString();
      if (user != null) {
        _success = true.toString();
        _userID = user.uid;

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

  doLogin() async {
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

    var bytes = utf8.encode(passController.text); // data being hashed
    var digest = sha256.convert(bytes);

    var response = await Http.post(
        'http://api.foodie.quality.datia.co/users/loginUser',
        body: {
          "email": emailController.text,
          "pass": digest.toString(),
          "access_type": "0"
        });

    Map map = jsonDecode(response.body);

    setState(() {
      visibility = false;
    });

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
    } else {
      await saveOnPreferences(map["data"]);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
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

        print("token -> " + token.toString());
        print("userId -> " + userId.toString());
        print("graph -> " + profile.toString());

        var response = await Http.post(
          'http://api.foodie.quality.datia.co/users/loginFacebook',
          body: {
            "email": profile["email"],
            "pass": userId.toString(),
            "name": profile["name"]
        });

        Map map = jsonDecode(response.body);

        print("payload response: " + {
            "email": profile["email"],
            "pass": token.toString(),
            "userId": userId.toString(),
            "name": profile["name"]
        }.toString());

        print("da response -> " + map.toString());

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: null,
        resizeToAvoidBottomInset: false,
        body: Column(children: <Widget>[
          Spacer(flex: 8,),
          Expanded(
            child: Container(
              child: Image.asset(
                "images/logo.png",
                width: 180.0,
              ),
              margin: EdgeInsets.only(top: 30),
            ),
            flex: 12,
          ),
          Spacer(flex: 1,),
          Expanded(
            child: Visibility(
              child: Container(
                child: Loading(
                  indicator: BallPulseIndicator(),
                  color: Color.fromRGBO(193, 191, 202, 1),
                ),
              ),
              visible: visibility,
            ),
            flex: 6,
          ),
          Spacer(flex: 1,),
          Container(
            child: new Row(
              children: <Widget>[
                new Expanded(
                    child: new Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(40.0),
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
                                    MaterialPageRoute(builder: (context) => RegisterScreen())
                                );
                              },
                              child: Text(
                                "Primera vez en Oh Foodie? Crea tu cuenta",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(250, 0, 60, 1),
                                    fontSize: 10
                                )
                              )
                          )
                      ),
                    )
                ),
                new Expanded(
                    child: new Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(40.0),
                        ),
                        color: Color.fromRGBO(250, 0, 60, 1)
                      ),
                      child: Center(
                        child: Text(
                          "¡Ya tengo cuenta! Inicia sesión",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10
                          ),
                          maxLines: 2,
                        ),
                      ),
                    )
                )
              ],
            ),
            margin: EdgeInsets.only(right: 20, left: 20),
            height: 60.0,
          ),
          Spacer(flex: 4,),
          Container(
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
            ),
            margin: EdgeInsets.only(left: 20, right: 20),
            height: 50.0,
          ),
          Spacer(flex: 1,),
          Container(
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
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            margin: EdgeInsets.only(left: 20, right: 20),
            height: 50.0,
          ),
          Spacer(flex: 1,),
          Expanded(
            child: Container(
              child: new Center(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgetPassword()),
                          );
                        },
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
                  ],
                ),
              ),
            ),
            flex: 6,
          ),
          Spacer(flex: 12,),
          Container(
            //child: new Center(
            child: new MaterialButton(
              child: Text(
                "Inicia sesión",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
                ),
              ),
              onPressed: () {
                doLogin();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
              ),
              color: Color.fromRGBO(250, 0, 60, 1),
              minWidth: double.infinity,
            ),
            height: 50.0,
            margin: EdgeInsets.only(left: 20, right: 20),
          ),
          Spacer(flex: 1,),
          Expanded(
            child: new Container(
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
            ),
            flex: 3,
          ),
          Spacer(flex: 3,),
          Expanded(
            child: Container(
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
                              new MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          child: Image.asset('images/facebook_icon.png'),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          signInWithGoogle();
                        },
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
            flex: 10,
          ),
          Spacer(
            flex: 4,
          )
        ])
    );
  }
}