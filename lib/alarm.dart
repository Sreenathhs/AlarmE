class Alarm {
  int alarmID;
  DateTime timeSet;
  String alarmDescription;
  static List<Alarm> alarms = new List();
  static int alarmIDcount = 0;

  static void addAlarm(int id, DateTime setTime, String description)
  {
    Alarm addAlarm = Alarm(id,setTime,description);
    Alarm.alarms.add(addAlarm);
  }

  static List<Alarm> getAlarms()
  {
    return alarms;
  }
  Alarm(this.alarmID,this.timeSet,this.alarmDescription);
}