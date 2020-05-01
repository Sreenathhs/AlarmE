import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'signup.dart';
import 'dashboard.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final String url = "http://10.0.2.2:5000";
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(url)
      },
      home: new MyHomePage(url),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String url;
  MyHomePage(this.url);
  @override
  _MyHomePageState createState() => new _MyHomePageState(url);
}

class _MyHomePageState extends State<MyHomePage> {
  final _email = TextEditingController();
  final _pswd = TextEditingController();
  String errorText = "";
  int retries = 0;
  String url;
  _MyHomePageState(this.url);

  final borderDecoration = InputDecoration(
      labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.green),
      ));
  bool emailRedUnderLine = false;
  bool pswdRedUnderLine = false;
  bool _loading = true;


  void _login() async {

    String Email = _email.text;
    String Password = _pswd.text;

    Map<String, String> headers = {"Content-type": "application/json"};
    String json ='{'
        '"Email" : "$Email",'
        '"Password" : "$Password"'
    '}';
    Response response = await post(url + "/login",
        headers: headers, body: json).timeout(const Duration(seconds: 3)).catchError( (error) => _onTimeout(error) );
    var data = jsonDecode(response.body);
    bool reqResponse = data['success'];
    String errorInfo = data['error_info'];
    if (reqResponse) {

      setState(() {
        errorText = "";
      });
      String value = "Test Subject";
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard(data: data)
      ));
    }
    else
      {
        if (errorInfo == "Incorrect password")
          {
            setState(() {

              errorText = "Incorrect Password";
              pswdRedUnderLine = true;
              emailRedUnderLine = false;
            });
          }
        else if (errorInfo == "User does not exist")
          {
            setState(() {
              errorText = "The user with this email does not exsist";
              emailRedUnderLine = true;
              pswdRedUnderLine = false;
            });
          }
        else
          {
            setState(() {
              errorText = "Something went wrong. Try loggin in again";
              emailRedUnderLine = false;
              pswdRedUnderLine = false;
            });
          }
      }
  }

  void _onTimeout(error) {
    retries++;
    if (error is TimeoutException)
      {
        if (retries < 3) {
          Toast.show(
              "Unable to connect to server. Trying again...", context, duration: 4,
              gravity: Toast.BOTTOM);
          Future.delayed(const Duration(seconds: 5), () {
            _getSession();
          });
        }
        else
          {
            Toast.show(
                "Failed to connect to server", context, duration: 4,
                gravity: Toast.BOTTOM);
            setState(() {
              _loading = false;
            });
          }
      }
    else
      {
        Toast.show("Something went wrong. Please restart application " + error.toString(), context, duration: 4, gravity: Toast.BOTTOM);
      }
  }

  Future<Response> _onRecieve(data) {
    setState(() {
      _loading = false;
    });
  }

  void _getSession() async {

    Response response = await get(url + '/getsession').timeout(const Duration(seconds: 3)).then((data) => _onRecieve(data)).catchError( (error) => _onTimeout(error) );

    //Session Retrival
  }

  @override
  void initState() {
    super.initState();
    print("GOING TO SESSION");
    _getSession();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: _loading ? SpinKitDualRing(
          color: Colors.green,
          size: 50.0,
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('AlarmE',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(280.0, 110.0, 0.0, 0.0),
                    child: Text('.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                        controller: _email,
                        decoration: emailRedUnderLine
                            ? borderDecoration.copyWith(
                                labelText: "EMAIL",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ))
                            : borderDecoration.copyWith(labelText: "EMAIL")),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: _pswd,
                      decoration: pswdRedUnderLine
                          ? borderDecoration.copyWith(
                              labelText: "PASSWORD",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ))
                          : borderDecoration.copyWith(labelText: "PASSWORD"),
                      obscureText: true,
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            height: 20.0,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    errorText, style: TextStyle(color: Colors.red)))),
                        Container(
                          alignment: Alignment.centerRight,

                          child: InkWell(
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: FlatButton(
                          onPressed: () {
                            if (_email.value.text.isEmpty &&
                                _pswd.value.text.isEmpty) {
                              setState(() {
                                emailRedUnderLine = true;
                                pswdRedUnderLine = true;
                                errorText = "Please enter the details";
                              });
                            } else if (_email.value.text.isEmpty) {
                              setState(() {
                                emailRedUnderLine = true;
                                pswdRedUnderLine = false;
                                errorText = "Please enter an email";
                              });

                            } else if (_pswd.value.text.isEmpty) {
                              setState(() {
                                pswdRedUnderLine = true;
                                emailRedUnderLine = false;
                                errorText = "Please enter password";
                              });

                            } else {
                              setState(() {
                                emailRedUnderLine = false;
                                pswdRedUnderLine = false;
                                errorText = "";
                                _loading = true;
                                _login();
                              });

                            }
                          },
                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 40.0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 10.0),
                            Center(
                              child: Text('Log in with Google',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'New User ?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () async {
                   await Navigator.of(context).pushNamed('/signup');
                    _getSession();
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
