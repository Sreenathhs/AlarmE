import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pswd = TextEditingController();
  final _phno = TextEditingController();

  final borderDecoration = InputDecoration(
    labelStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        color: Colors.grey),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.green),
    ),
  );
  String errorText = '';

  bool nameRedUnderLine = false;
  bool emailRedUnderLine = false;
  bool paswdRedUnderLine = false;
  bool phoneRedUnderLine = false;

  bool _loader = false;

  void _tester() {
    print("Thats it");
  }

  void _runMe() async {
    setState(() {
      _loader = true;
    });

    String name = _name.text;
    String email = _email.text;
    String pswd = _pswd.text;
    String phno = _phno.text;

    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{'
        '"Name": "$name", '
        '"Email": "$email",'
        '"Password" : "$pswd",'
        '"Phone": "$phno"'
        '}';

    Response response = await post("http://10.0.2.2:5000/register",
        headers: headers, body: json);
    setState(() {
      _loader = false;
    });
    var data = jsonDecode(response.body);

    bool reqResponse = data['success'];
    String errorInfo = data['error_info'];
    if (reqResponse) {
      setState(() {
        errorText = "";
      });
      setState(() {
        Navigator.of(context).pop();
      });
    } else {
      switch (errorInfo) {
        case 'Duplicate':
          emailRedUnderLine = true;
          setState(() {
            errorText = "The user is already registered";
          });
          break;
        default:
          setState(() {
            errorText = "Something went wrong. Try again";
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: _loader ? SpinKitDualRing(
          color: Colors.green,
          size: 50.0,
        ): Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(310.0, 115.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      TextField(
                        inputFormatters: [
                         new WhitelistingTextInputFormatter(RegExp("[a-zA-Z|\\ |\\.]"))
                        ],
                          controller: _name,
                          decoration: nameRedUnderLine
                              ? borderDecoration.copyWith(
                                  labelText: "Name",
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                )
                              : borderDecoration.copyWith(labelText: "Name")),
                      TextField(
                        controller: _email,
                        decoration: emailRedUnderLine
                            ? borderDecoration.copyWith(
                                labelText: "Email",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              )
                            : borderDecoration.copyWith(labelText: "Email"),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: _pswd,
                        decoration: paswdRedUnderLine
                            ? borderDecoration.copyWith(
                                labelText: "Password",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              )
                            : borderDecoration.copyWith(labelText: "Password"),
                        obscureText: true,
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        inputFormatters: [
                          new WhitelistingTextInputFormatter(RegExp("[0-9]"))
                        ],
                        controller: _phno,
                        decoration: phoneRedUnderLine
                            ? borderDecoration.copyWith(
                                labelText: "Phone",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              )
                            : borderDecoration.copyWith(labelText: "Phone"),
                      ),
                      Container(
                          height: 50.0,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                errorText,
                                style: TextStyle(color: Colors.red),
                              ))),
                      Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.greenAccent,
                            color: Colors.green,
                            elevation: 7.0,
                            child: FlatButton(
                              onPressed: () {
                                bool flag = false;
                                if (_name.value.text.isEmpty) {
                                  setState(() {
                                    nameRedUnderLine = true;
                                    flag = true;
                                  });
                                } else
                                  setState(() {
                                    nameRedUnderLine = false;
                                  });
                                if (_email.value.text.isEmpty) {
                                  setState(() {
                                    emailRedUnderLine = true;
                                    flag = true;
                                  });
                                } else
                                  setState(() {
                                    emailRedUnderLine = false;
                                  });
                                if (_pswd.value.text.isEmpty) {
                                  setState(() {
                                    paswdRedUnderLine = true;
                                    flag = true;
                                  });
                                } else
                                  setState(() {
                                    paswdRedUnderLine = false;
                                  });
                                if (_phno.value.text.isEmpty) {
                                  setState(() {
                                    phoneRedUnderLine = true;
                                    flag = true;
                                  });
                                } else
                                  setState(() {
                                    phoneRedUnderLine = false;
                                  });

                                if (flag == true) {
                                  setState(() {
                                    errorText =
                                        "The field(s) marked in Red need to be filled";
                                  });
                                } else {
                                  setState(() {
                                    if (_email.value.text.contains("@") && _email.value.text.contains(".")) {
                                      nameRedUnderLine = false;
                                      emailRedUnderLine = false;
                                      paswdRedUnderLine = false;
                                      phoneRedUnderLine = false;
                                      _runMe();
                                    }
                                    else
                                      {
                                        emailRedUnderLine = true;
                                        errorText = "Please enter a valid email";
                                      }
                                  });
                                }
                              },
                              child: Center(
                                child: Text(
                                  'SIGNUP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          )),
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
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text('Go Back',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              // SizedBox(height: 15.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Text(
              //       'New to Spotify?',
              //       style: TextStyle(
              //         fontFamily: 'Montserrat',
              //       ),
              //     ),
              //     SizedBox(width: 5.0),
              //     InkWell(
              //       child: Text('Register',
              //           style: TextStyle(
              //               color: Colors.green,
              //               fontFamily: 'Montserrat',
              //               fontWeight: FontWeight.bold,
              //               decoration: TextDecoration.underline)),
              //     )
              //   ],
              // )
            ]));
  }
}
