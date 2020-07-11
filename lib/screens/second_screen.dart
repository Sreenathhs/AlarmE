import 'package:flutter/material.dart';
import 'package:galarm/alarm.dart';

class SecondTab extends StatefulWidget {

  @override
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          height: double.maxFinite,
          width: double.maxFinite,
          child: ListView(
            children: <Widget>[
              Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: <Widget>[
                        Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(Icons.group, size: 30,color: Color(0xff2d386b),),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                  child: Text("Group Name", style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                      color: Colors.black
                                  ),)
                              )
                            ]
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Ek chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Dusra chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Theesra chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Chota chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Panchva chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: <Widget>[
                        Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(Icons.group, size: 30,color: Color(0xff2d386b),),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                  child: Text("Group Name", style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                      color: Colors.black
                                  ),)
                              )
                            ]
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Ek chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Dusra chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Theesra chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Chota chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5,bottom: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Panchva chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: <Widget>[
                        Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(Icons.group, size: 30,color: Color(0xff2d386b),),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                  child: Text("Group Name", style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                      color: Colors.black
                                  ),)
                              )
                            ]
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Ek chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Dusra chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Theesra chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Chota chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10,top: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Panchva chutiya",style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        )
    );
  }
}
