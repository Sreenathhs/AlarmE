import 'dart:convert';

import 'package:galarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';

import '../socketconfig.dart';

class GroupAlarm extends StatefulWidget {
  var sdata, data;

  GroupAlarm(this.sdata, this.data);

  @override
  _GroupAlarmState createState() => _GroupAlarmState(this.sdata, this.data);
}

class _GroupAlarmState extends State<GroupAlarm> {
  var sdata, data;
  SocketIO socketIO;

  _GroupAlarmState(this.sdata, this.data);

  void initState() {
    String URL = data['server'];
    super.initState();
    socketIO = SocketIOManager().createSocketIO(URL, "/test");

    //call init socket before doing anything
    socketIO.init();

    //connect socket
    socketIO.connect();
    socketIO.subscribe("group_" + sdata.id.toString(), rebuildAlarmList);
  }

  void dispose() {
    super.dispose();
    socketIO.unSubscribe("group_" + sdata.id.toString());
  }

  void rebuildAlarmList(dynamic message) {
    print("Me ninja hatodi");
    setState(() {

    });
  }

  Future<Null> selectTime(BuildContext context, int helloAlarmID) async {
    TextEditingController alarmDesc = new TextEditingController();
    TimeOfDay _time = TimeOfDay.now();
    DateTime _date = DateTime.now();
    _date = await showDatePicker(context: context, initialDate: _date, firstDate: _date, lastDate: DateTime(2222));
    if (_date != null) {
      _time = await showTimePicker(context: context, initialTime: _time);
      if (_time != null) {
        _date = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
        await showDialog(context: context,barrierDismissible: false,builder: (context){
          return AlertDialog(
            title: Text('Purpose of Alarm:'),
            content: TextField(
              controller: alarmDesc,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop(alarmDesc.text.toString());
                },
              )
            ],
          );
        });
        print(alarmDesc.text.toString());
        String URL = data['server'];
        int id = sdata.id;
        String alarmdesc = alarmDesc.text.toString();
        Map<String, String> headers = {"Content-type": "application/json"};
        String json = '{'
            '"groupID" : "$id",'
        '"alarmTime" : "$_date",'
        '"description" : "$alarmdesc"'
            '}';
        socketIO.sendMessage("add_alarm_event", json);
        print("Sent");
      }
    }
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
                return Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'No Alarms set',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                        )),
                  ]
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.alarm),
        backgroundColor: Colors.green,
        onPressed: () {
          selectTime(context, Alarm.alarmIDcount++);
        },
      ),
    );
  }
}
