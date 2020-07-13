import 'dart:convert';
import 'dart:ffi';
import 'package:galarm/groupinfo.dart';


import 'group_alarm_screen.dart';
import 'package:flutter/material.dart';
import 'package:galarm/alarm.dart';
import 'package:http/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SecondTab extends StatefulWidget {

  var data;

  SecondTab(this.data);

  @override
  _SecondTabState createState() => _SecondTabState(this.data);
}

class _SecondTabState extends State<SecondTab> {

  var data;
  bool flag=true;
  _SecondTabState(this.data);


  Future<List> _fillGroups() async {
    String URL = data['server'];
    int id = data['user_details']['id'];
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{'
        '"id" : "$id"'
        '}';
    Response response = await post(URL + "/fetchgroups",
        headers: headers, body: json)
        .timeout(const Duration(seconds: 5));
    List group_list = jsonDecode(response.body);
    List<GroupInfo> groups= [];

    List<String> members_name = [];
    if (group_list.length > 0)
    {
      for (int i=0;i<group_list.length;i++)
        {
          GroupInfo group = new GroupInfo();
          group.gname = group_list[i]['gname'];
          group.id = group_list[i]['groupID'];
          print("yaha?");
          for(int j=0;j<group_list[i]['members'].length;j++)
            {
              members_name.add(group_list[i]['members'][j]);
              group.members.add(group_list[i]['members'][j]);
            }
          groups.add(group);
        }
      return groups;
    }
    else {
      flag=false;
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 2, 0, 10),
          height: double.maxFinite,
          width: double.maxFinite,
          child: ListView(
            children: <Widget>[
              FutureBuilder(
                future: _fillGroups(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null && flag) {
                    return SpinKitDualRing(
                      color: Colors.green,
                      size: 50,
                    );
                  }
                  else if (snapshot.data== null)
                    {
                      return Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                child: Text(
                                  'You are currently not in any group',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                          ]);
                    }
                  else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        return Card(
                            elevation: 5,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, new MaterialPageRoute(builder: (context) => new GroupAlarm(snapshot.data[index],data)));
                              },
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
                                            child: Text(snapshot.data[index].gname, style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15,
                                                color: Colors.black
                                            ),)
                                        )
                                      ]
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data[index].members.length,
                                    itemBuilder: (BuildContext context, int ind){
                                      return Padding(
                                        padding: EdgeInsets.only(left: 10,top: 5,bottom: 4),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(snapshot.data[index].members[ind],style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600
                                            ),
                                            )
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            )
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}
