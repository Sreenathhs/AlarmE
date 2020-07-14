import 'package:galarm/clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:galarm/alarm.dart';
import 'dart:ui';



class FirstTab extends StatefulWidget {

  @override
  _FirstTabState createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab> {


Future<List<Alarm>> listAlarms() async
{
  if (Alarm.getAlarms().length > 0)
    return Alarm.getAlarms();
  else
    return null;
}


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(55),
          child: Clock(),
        ),
        Column(
          children: <Widget>[

            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  style: BorderStyle.solid,
                  width: 1.4
                ),
                borderRadius: BorderRadius.circular(20)
              ),
              padding: EdgeInsets.all(10),
              width: 200,
              height: 50,
              child: Material(
                shadowColor: Colors.blue,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('Refresh',style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12
                  ),),
                  onPressed: () {
                    setState(() {

                    });
                  },
                ),
              ),
            ),
          ]
        ),
        FutureBuilder(
          future: listAlarms(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null)
              {
                return Container(
                  child: Align(alignment: Alignment.center,child: Text('No Alarms set', style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w800),)),
                );
              }
            else {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    title: Text(snapshot.data[index].alarmDescription,style: TextStyle(
                      color: Colors.green,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 5
                    ),),
                    subtitle: Text(snapshot.data[index].timeSet.toString(),style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1
                    ),),
                  );
                },
              );
            }
          },
        )
      ],
    );
  }
}
