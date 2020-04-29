import 'package:flutter/material.dart';
import 'screens/first_screen.dart';
import 'screens/second_screen.dart';

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  var data;
  Dashboard({this.data});
  @override
  _DashboardState createState() => _DashboardState(data);
}

class _DashboardState extends State<Dashboard> {

  var data;
  _DashboardState(this.data);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Clock',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new AppClock(data),
    );
  }
}

class AppClock extends StatefulWidget {
  var data;
  AppClock(this.data);
  @override
  _AppClockState createState() => _AppClockState(data);
}

class _AppClockState extends State<AppClock> {
  var data;
  _AppClockState(this.data);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 600,
        width: double.infinity,
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
                bottomNavigationBar: BottomBar(),
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(55),
                    child: Container(
                      color: Colors.transparent,
                      child: SafeArea(
                        child: Column(
                          children: <Widget>[
                            TabBar(
                                indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        color: Color(0xff00FF00), width: 4.0),
                                    insets: EdgeInsets.fromLTRB(
                                        40.0, 20.0, 40.0, 0)),
                                indicatorWeight: 15,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelColor: Color(0xff2d386b),
                                labelStyle: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.3,
                                    fontWeight: FontWeight.w500),
                                unselectedLabelColor: Colors.black26,
                                tabs: [
                                  Tab(
                                    text: "ALARMS",
                                    icon: Icon(Icons.alarm, size: 40),
                                  ),
                                  Tab(
                                    text: "GROUP ALARMS",
                                    icon: Icon(Icons.group, size: 40),
                                  ),
                                  Tab(
                                    text: "SETTINGS",
                                    icon: Icon(Icons.settings,
                                        size: 40),
                                  ),
                                ])
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    Center(
                      child: FirstTab(),
                    ),
                    Center(
                      child: SecondTab(),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(data['user_details']['name']),
                          ),
                        ),
                        Divider(),
                        Text('same')
                      ],
                    ),
                  ],
                ))));
  }
}

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(50, 0, 50, 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //****************JUST IN CASE TO ADD EXTRA BUTTON IN MAIN UI**************************//
          /*  FlatButton(
            child: Text(
              "EDIT ALARMS",
              style: TextStyle(letterSpacing: 1.5),
            ),
            color: Color(0xffff5e92),
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {},
          ),*/
          //****************JUST IN CASE TO ADD EXTRA BUTTON IN MAIN UI**************************//

          FloatingActionButton(
            child: Text(
              "+",
              style: TextStyle(
                  color: Color(0xff253165),
                  fontWeight: FontWeight.w700,
                  fontSize: 25),
            ),
            onPressed: () {},
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 5,
            highlightElevation: 3,
          )
        ],
      ),
    );
  }
}
