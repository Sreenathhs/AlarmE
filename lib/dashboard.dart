import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/first_screen.dart';
import 'screens/second_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'main.dart';

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
  String textValue = "";
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    firebaseMessaging.configure(
        onLaunch: (Map<String, dynamic> msg){
          print("onLaunch");
          return null;
        },
        onResume: (Map<String, dynamic> msg){
          print("onResume");
          return null;
        },
        onMessage: (Map<String, dynamic> msg){
          print("onMessage");
          return null;
        }
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true,
            alert: true,
            badge: true
        )
    );
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings){
      print('IoS Settings registered');
    });
    firebaseMessaging.getToken().then((token){
      update(token);
    });
  }
  update (String token) {
    print(token);
    textValue = token;
    setState(() {

    });
  }
  void _removeDeviceId() async {
    print("NOW INSIDE");
    int userID = data['user_details']['id'];
    String URL = data['server'];
    print(URL);
    print(userID);
    Map<String, String> headers = {"Content-type": "application/json"};
    String json ='{'
        '"ID" : "$userID"'
        '}';
    Response response = await post(URL + '/logout',headers: headers, body: json).timeout(const Duration(seconds: 3)).catchError( (error) => (error) {Toast.show("Application could not connect to the internet. Quitting without logout", context, duration: 4, gravity:  Toast.BOTTOM);setState(() {
      _loading = true;
    }); } );
  }

  Future<bool> _confirmation() {
    return showDialog(
        context: context,
      builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('You will be logged out. Do you wish to continue?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () async{
                    print("GOING IN");
                    await _removeDeviceId();
                    Navigator.of(context).pop(false);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
                  },
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            );
      });
  }
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmation,
      child: _loading ? SpinKitDualRing(
        color: Colors.green,
        size: 50.0,
      ) : Container(
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
                          Text(textValue),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 20),
                                height: 50,
                                width:  100,
                                child: FlatButton(
                                  color: Colors.lightGreen,
                                  child: Text('Logout'),
                                  onPressed: () {
                                    _confirmation();
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )))),
    );
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
//            FlatButton(
//            child: Text(
//              "EDIT ALARMS",
//              style: TextStyle(letterSpacing: 1.5),
//            ),
//            color: Color(0xffff5e92),
//            textColor: Colors.white,
//            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
//            shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(50),
//            ),
//            onPressed: () {},
//          ),
          //****************JUST IN CASE TO ADD EXTRA BUTTON IN MAIN UI**************************//
        ],
      ),
    );
  }
}
