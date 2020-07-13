import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class GroupAlarm extends StatefulWidget {
  var sdata, data;

  GroupAlarm(this.sdata, this.data);

  @override
  _GroupAlarmState createState() => _GroupAlarmState(this.sdata, this.data);
}

class _GroupAlarmState extends State<GroupAlarm> {
  var sdata, data;

  _GroupAlarmState(this.sdata, this.data);

  void initState() {
    super.initState();
  }

  Future<List> _fillAlarms() async {
    String URL = data['server'];
    int id = sdata.id;
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{'
        '"groupID" : "$id"'
        '}';
    Response response =
        await post(URL + "/fetchgroupalarms", headers: headers, body: json)
            .timeout(const Duration(seconds: 5));
    List alarms_info = jsonDecode(response.body);
    print(alarms_info[0]['description']);
    return alarms_info;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 10,
        title: Container(
          child: Text(sdata.gname),
        ),
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
            future: _fillAlarms(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No Alarms set',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      )),
                );
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children:<Widget>[
                        ListTile(
                          title: Text(
                            snapshot.data[index]['description'],
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2),
                          ),
                          subtitle: Text(
                            snapshot.data[index]['timeset'].toString(),
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1),
                          ),
                        ),
                        Divider(
                          thickness: 3,
                        ),
                      ]
                    );
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}
