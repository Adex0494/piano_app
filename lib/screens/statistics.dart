import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/day_bar.dart';
import '../utils/database_helper.dart';
import '../models/use.dart';
import '../main.dart';

enum Range {
  FirstDay,
  LastDay,
}

class StatisticsPage extends StatefulWidget {
  final Function saveTime;

  StatisticsPage(this.saveTime);
  @override
  _StatisticsPageState createState() => _StatisticsPageState(this.saveTime);
}

class _StatisticsPageState extends State<StatisticsPage> {
  final Function saveTime;

  _StatisticsPageState(this.saveTime);
  //Function saveTime = widget.saveTime;
  String mode = 'Por periodo';
  String period = 'Semanal';
  DateTime _firstSelectedDate;
  DateTime _lastSelectedDate;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Use> useList=List<Use>();
  int totalUseInMinutes = 0;
  List<int> minutesUsed=[0,0,0,0,0,0,0];
  List<DateTime> range=[DateTime.now(),DateTime.now()];
  DateTime selectedDate = DateTime.now();
  Use todayUse = Use(1, 0, DateTime.now().toString());
  bool gotTodayUse = false;
  @override
  initState() {
    getUse(selectedDate);
    super.initState();

  }

  void getTodayUse() async{
    Use auxTodayUse = await databaseHelper.getUseFromUserAndDate(1, getDateStringFromDateTime(DateTime.now()));
    if (auxTodayUse!=null){
      setState(() {
        this.todayUse=auxTodayUse;
      });
    }
  }

  String timeInMinutesOrHours(int minutes){
    if(minutes<60) return '$minutes' +' m';
    else {
     return ((minutes/60).round().toString() + ' h');
    }
  }
  
  int distanceFromSunday(String day){
    switch(day){
      case 'Sunday': return 0;
      case 'Monday': return 1;
      case 'Tuesday': return 2;
      case 'Wednesday': return 3;
      case 'Thursday': return 4;
      case 'Friday': return 5;
      case 'Saturday': return 6;
      default: return -1;
    }
  }

  List<DateTime> dateRangeFromWeek(DateTime date){
    int theDistanceFromSunday = distanceFromSunday(DateFormat('EEEE').format(date));
    DateTime rangeStart = date.add(Duration(days: -theDistanceFromSunday));
    DateTime rangeEnd = date.add(Duration(days: -theDistanceFromSunday+6));
    List<DateTime> range = [rangeStart,rangeEnd];
    return range;
  }

  String getMonthOrDayString(int number){
    String theString;
    if (number<10) theString='0$number';
    else theString= number.toString();
    return theString; 
  }

  String getDateStringFromDateTime(DateTime theDateTime){
    return theDateTime.year.toString()+'-'+getMonthOrDayString(theDateTime.month)+'-'+getMonthOrDayString(theDateTime.day);
  }

  double getHeightFactor(int theMinutesUsed){
    if (totalUseInMinutes==0) return 0.0;
    else {return theMinutesUsed/totalUseInMinutes;
  }
  }

  void getUse(DateTime dateTime) async{
    List<int> auxMinutesUsed=List<int>();
    int auxTotalUseInMinutes=0;

     //PianoApp.stopwatch.stop();
    if(PianoApp.stopwatch.elapsedMilliseconds > 30000)
      await saveTime();

    if(!gotTodayUse)
    {
      getTodayUse();
      gotTodayUse = true;
    }
    //Getting range
    List<DateTime> auxrange = dateRangeFromWeek(dateTime);
    //adding the use of each day in range
    for(int i=0;i<=auxrange[1].difference(auxrange[0]).inDays;i++){
      Use auxUse = (await databaseHelper.getUseFromUserAndDate(1,getDateStringFromDateTime(auxrange[0].add(Duration(days:i)))));
      if (auxUse!=null)
      {
        auxMinutesUsed.add(auxUse.minutes);
        auxTotalUseInMinutes+=auxUse.minutes;
      }
      else{auxMinutesUsed.add(0);}      
    }
    setState(() {
      this.totalUseInMinutes=auxTotalUseInMinutes;
      this.minutesUsed=auxMinutesUsed;
      this.range=auxrange;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
        title: Text('Estadística', style: TextStyle(color: Colors.white)));
    double totalAvailableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    Widget periodOrRangeRadio(String text) {
      return Container(
          child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            child: Radio(
                activeColor: Colors.black,
                value: text,
                groupValue: mode,
                onChanged: (String value) {
                  setState(() {
                    mode = value;
                    getUse(selectedDate);
                  });
                }),
          ),
          Text(text, style: Theme.of(context).textTheme.headline3),
        ],
      ));
    }

    Widget periodRadio(String text) {
      return Container(
          child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            child: Radio(
                activeColor: Colors.black,
                value: text,
                groupValue: period,
                onChanged: (String value) {
                  setState(() {
                    period = value;
                  });
                }),
          ),
          Text(text, style: Theme.of(context).textTheme.headline1),
        ],
      ));
    }

    void _presentDatePicker(Range theRange) {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now())
          .then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          if (theRange == Range.FirstDay)
            _firstSelectedDate = pickedDate;
          else
            _lastSelectedDate = pickedDate;
        });
      });
    }

    Widget periodOrRangeWidget() {
      return mode == 'Por periodo'
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [periodRadio('Semanal'), periodRadio('Mensual')])
          : Container(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Desde:'),
                FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      _presentDatePicker(Range.FirstDay);
                    },
                    child: _firstSelectedDate == null
                        ? Text(' Seleccionar fecha  ')
                        : Text(DateFormat.yMd().format(_firstSelectedDate))),
                Text('Hasta:'),
                FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      _presentDatePicker(Range.LastDay);
                    },
                    child: _lastSelectedDate == null
                        ? Text(' Seleccionar fecha')
                        : Text(DateFormat.yMd().format(_lastSelectedDate)))
              ],
            ));
    }

    return Scaffold(
        appBar: appBar,
        //backgroundColor: Colors.black,
        body: Column(
            //----------------------------main column--------------------------
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black,
                  ),
                  //borderRadius: BorderRadius.all(Radius.circular(3))
                ),
                //color: Colors.green,
                height: totalAvailableHeight * 0.2,
                child: SingleChildScrollView(
                  child: Column(
                    //----------------------top column--------------
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'FILTROS',
                          style: Theme.of(context).textTheme.headline3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          periodOrRangeRadio('Por periodo'),
                          periodOrRangeRadio('Por rango')
                        ],
                      ),
                      periodOrRangeWidget(),
                    ],
                  ),
                ),
              ),
              Container(
                //------------------------center column--------------
                //color: Colors.grey,
                height: totalAvailableHeight * 0.6,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Text(
                            'Este periodo o rango',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                width: mediaQuery.size.width * 0.10,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  child: IconButton(icon: Icon(Icons.arrow_back)),
                                  onPressed: (){
                                    setState(() {
                                      selectedDate = selectedDate.add(Duration(days:-7));
                                      getUse(selectedDate);
                                    });
                                  },
                                )),
                            Container(
                                height: 250,
                                width: mediaQuery.size.width * 0.80,
                                child: Card(
                                  elevation: 5,
                                  child: Container(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          DayBar(getHeightFactor(minutesUsed[0]), 'Do',range[0].day,timeInMinutesOrHours(minutesUsed[0])),
                                          DayBar(getHeightFactor(minutesUsed[1]), 'Lu', range[0].add(Duration(days:1)).day,timeInMinutesOrHours(minutesUsed[1])),
                                          DayBar(getHeightFactor(minutesUsed[2]), 'Ma',range[0].add(Duration(days:2)).day,timeInMinutesOrHours(minutesUsed[2])),
                                          DayBar(getHeightFactor(minutesUsed[3]), 'Mi',range[0].add(Duration(days:3)).day,timeInMinutesOrHours(minutesUsed[3])),
                                          DayBar(getHeightFactor(minutesUsed[4]), 'Ju',range[0].add(Duration(days:4)).day,timeInMinutesOrHours(minutesUsed[4])),
                                          DayBar(getHeightFactor(minutesUsed[5]), 'Vi',range[0].add(Duration(days:5)).day,timeInMinutesOrHours(minutesUsed[5])),
                                          DayBar(getHeightFactor(minutesUsed[6]), 'Sa',range[0].add(Duration(days:6)).day,timeInMinutesOrHours(minutesUsed[6])),
                                        ]),
                                  ),
                                )),
                            Container(
                                alignment: Alignment.centerRight,
                                width: mediaQuery.size.width * 0.10,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  child: IconButton(icon: Icon(Icons.arrow_forward)),
                                  onPressed: (){
                                    selectedDate = selectedDate.add(Duration(days:7));
                                    getUse(selectedDate);
                                  },
                                )),
                          ],
                        ),
                        Container(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Text(
                            'Total del periodo o rango: ',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  //----------------------bottom column-------------------
                  //color: Colors.blue,
                  height: totalAvailableHeight * 0.2,
                  width: double.infinity,
                  child: Center(
                      child: Text('Hoy: '+ timeInMinutesOrHours(todayUse.minutes),
                          style: Theme.of(context).textTheme.headline6)))
            ]));
  }
}

// Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text('7 horas',style: Theme.of(context).textTheme.headline6,),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text('Hoy',style: Theme.of(context).textTheme.headline3),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children:<Widget>[
//               DayBar(0.5,'Lu'),
//               DayBar(0.2,'Ma'),
//               DayBar(0.3,'Mi'),
//               DayBar(0.7,'Ju'),
//               DayBar(0.35,'Vi'),
//               DayBar(0.6,'Sa'),
//               DayBar(0.4,'Do'),
//             ]),
//           ),
//         ),
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Text('Mi., 14 oct',style: Theme.of(context).textTheme.headline3),
//          )
