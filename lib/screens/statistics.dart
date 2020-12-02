import 'dart:async';

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
  final int userId;
  final Function saveTime;

  StatisticsPage(this.userId, this.saveTime);
  @override
  _StatisticsPageState createState() =>
      _StatisticsPageState(this.userId, this.saveTime);
}

class _StatisticsPageState extends State<StatisticsPage> {
  final int userId;
  final Function saveTime;
  Timer timer;

  bool connected = false;

  void askForConnection() {
    //debugPrint(PianoApp.connected.toString());
    if (PianoApp.connected != connected)
      setState(() {
        connected = PianoApp.connected;
      });
  }

  void getDaySelectedMinutes(DateTime day) async {
    Use dayUse = await databaseHelper.getUseFromUserAndDate(
        userId, getDateStringFromDateTime(day));
    if (dayUse != null) {
      setState(() {
        daySelectedMinutes = dayUse.minutes;
      });
    } else
      setState(() {
        daySelectedMinutes = 0;
      });
  }

  @override
  initState() {
    _firstSelectedDate = DateTime.now();
    // getDaySelectedMinutes(_firstSelectedDate);
    todayUse = Use(userId, 0, DateTime.now().toString());
    getUse(selectedDate);
    const oneSec = const Duration(milliseconds: 3000);
    timer = new Timer.periodic(oneSec, (Timer t) => askForConnection());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  _StatisticsPageState(this.userId, this.saveTime);
  //Function saveTime = widget.saveTime;
  String mode = 'Por semana';
  String period = 'Semanal';
  DateTime _firstSelectedDate;//By default it is today
  //DateTime _lastSelectedDate;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Use> useList = List<Use>();
  int totalUseInMinutes = 0;
  List<int> minutesUsed = [0, 0, 0, 0, 0, 0, 0];
  List<DateTime> range = [DateTime.now(), DateTime.now()];
  DateTime selectedDate = DateTime.now();
  Use todayUse;
  bool gotTodayUse = false;
  String monthOrMonthes = '';
  String weekToShow = 'Esta semana';
  int weekCount = 0;
  int daySelectedMinutes = 0;

  void getTodayUse() async {
    Use auxTodayUse = await databaseHelper.getUseFromUserAndDate(
        userId, getDateStringFromDateTime(DateTime.now()));
    if (auxTodayUse != null) {
      setState(() {
        //_firstSelectedDate = DateTime.now();
        daySelectedMinutes = auxTodayUse.minutes;
        this.todayUse = auxTodayUse;
      });
    }
  }

  void showMonthOrMonthes() {
    if (range[0].month == range[1].month) {
      monthOrMonthes = getMonthName(range[0].month);
    } else {
      monthOrMonthes =
          getMonthName(range[0].month) + '-' + getMonthName(range[1].month);
    }
  }

  String getMonthName(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'Enero';
      case 2:
        return 'Febrero';
      case 3:
        return 'Marzo';
      case 4:
        return 'Abril';
      case 5:
        return 'Mayo';
      case 6:
        return 'Junio';
      case 7:
        return 'Julio';
      case 8:
        return 'Agosto';
      case 9:
        return 'Septiembre';
      case 10:
        return 'Octubre';
      case 11:
        return 'Noviembre';
      case 12:
        return 'Diciembre';
    }
  }

  void getWeekLabel() {
    if (weekCount == 0)
      weekToShow = 'Esta semana';
    else if (weekCount == -1)
      weekToShow = 'La semana pasada';
    else {
      weekToShow = 'Hace ${(-weekCount).toString()}' + ' semanas';
    }
  }

  String timeInMinutesOrHours(int minutes) {
    if (minutes < 60)
      return '$minutes' + ' m';
    else {
      return ((minutes / 60).round().toString() + ' h');
    }
  }

  int distanceFromSunday(String day) {
    switch (day) {
      case 'Sunday':
        return 0;
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      default:
        return -1;
    }
  }

  String translateDay(String day) {
    switch (day) {
      case 'Sunday':
        return 'Domingo';
      case 'Monday':
        return 'Lunes';
      case 'Tuesday':
        return 'Martes';
      case 'Wednesday':
        return 'Miércoles';
      case 'Thursday':
        return 'Jueves';
      case 'Friday':
        return 'Viernes';
      case 'Saturday':
        return 'Sábado';
      default:
        return 'Irreconocido';
    }
  }

  List<DateTime> dateRangeFromWeek(DateTime date) {
    int theDistanceFromSunday =
        distanceFromSunday(DateFormat('EEEE').format(date));
    DateTime rangeStart = date.add(Duration(days: -theDistanceFromSunday));
    DateTime rangeEnd = date.add(Duration(days: -theDistanceFromSunday + 6));
    List<DateTime> range = [rangeStart, rangeEnd];
    return range;
  }

  String getMonthOrDayString(int number) {
    String theString;
    if (number < 10)
      theString = '0$number';
    else
      theString = number.toString();
    return theString;
  }

  String getDateStringFromDateTime(DateTime theDateTime) {
    return theDateTime.year.toString() +
        '-' +
        getMonthOrDayString(theDateTime.month) +
        '-' +
        getMonthOrDayString(theDateTime.day);
  }

  double getHeightFactor(int theMinutesUsed) {
    if (totalUseInMinutes == 0)
      return 0.0;
    else {
      return theMinutesUsed / totalUseInMinutes;
    }
  }

  void getUse(DateTime dateTime) async {
    List<Use> useList = await databaseHelper.getUseList();
    for (int i = 0; i < useList.length; i++) {
      debugPrint(useList[i].id.toString() +
          useList[i].userId.toString() +
          useList[i].minutes.toString() +
          useList[i].date);
    }

    List<int> auxMinutesUsed = List<int>();
    int auxTotalUseInMinutes = 0;

    //PianoApp.stopwatch.stop();
    debugPrint(PianoApp.stopwatch.elapsedMilliseconds.toString());
    if (PianoApp.stopwatch.elapsedMilliseconds > 30000) await saveTime(userId);

    if (!gotTodayUse) {
      getTodayUse();
      gotTodayUse = true;
    }
    //Getting range
    List<DateTime> auxrange = dateRangeFromWeek(dateTime);
    //adding the use of each day in range
    for (int i = 0; i <= auxrange[1].difference(auxrange[0]).inDays; i++) {
      Use auxUse = (await databaseHelper.getUseFromUserAndDate(userId,
          getDateStringFromDateTime(auxrange[0].add(Duration(days: i)))));
      if (auxUse != null) {
        auxMinutesUsed.add(auxUse.minutes);
        auxTotalUseInMinutes += auxUse.minutes;
      } else {
        auxMinutesUsed.add(0);
      }
    }
    setState(() {
      this.totalUseInMinutes = auxTotalUseInMinutes;
      this.minutesUsed = auxMinutesUsed;
      this.range = auxrange;
      showMonthOrMonthes();
      getWeekLabel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text('Estadística', style: TextStyle(color: Colors.white)),
      leading: Icon(
        Icons.circle,
        color: PianoApp.connected ? Colors.green : Colors.grey,
      ),
    );
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
          .then((pickedDate) async {
        if (pickedDate == null) {
          return;
        }

        if (theRange == Range.FirstDay) {
          _firstSelectedDate = pickedDate;
          Use dayUse = await databaseHelper.getUseFromUserAndDate(
              userId, getDateStringFromDateTime(_firstSelectedDate));
          if (dayUse != null) {
            setState(() {
              daySelectedMinutes = dayUse.minutes;
            });
          } else
            setState(() {
              daySelectedMinutes = 0;
            });
        } else
          setState(() {
            //_lastSelectedDate = pickedDate;
          });
      });
    }

    Widget periodOrRangeWidget() {
      if (mode == 'Por día')
        monthOrMonthes = '';
      else {
        showMonthOrMonthes();
      }
      return mode == 'Por semana'
          ?
          //  Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [periodRadio('Semanal'), periodRadio('Mensual')])
          Container()
          : Container(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Día:'),
                FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      _presentDatePicker(Range.FirstDay);
                    },
                    child: _firstSelectedDate == null
                        ? Text(' Seleccionar fecha  ')
                        : Text(DateFormat.yMd().format(_firstSelectedDate))),
                // Text('Hasta:'),
                // FlatButton(
                //     padding: EdgeInsets.all(0),
                //     onPressed: () {
                //       _presentDatePicker(Range.LastDay);
                //     },
                //     child: _lastSelectedDate == null
                //         ? Text(' Seleccionar fecha')
                //         : Text(DateFormat.yMd().format(_lastSelectedDate)))
              ],
            ));
    }

    Widget weekBarsGraph() {
      return Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                  child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Text(
                  weekToShow,
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
                        onPressed: () {
                          setState(() {
                            weekCount--;
                            selectedDate = selectedDate.add(Duration(days: -7));
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                DayBar(
                                    getHeightFactor(minutesUsed[0]),
                                    'Do',
                                    range[0].day.toString(),
                                    timeInMinutesOrHours(minutesUsed[0])),
                                DayBar(
                                    getHeightFactor(minutesUsed[1]),
                                    'Lu',
                                    range[0]
                                        .add(Duration(days: 1))
                                        .day
                                        .toString(),
                                    timeInMinutesOrHours(minutesUsed[1])),
                                DayBar(
                                    getHeightFactor(minutesUsed[2]),
                                    'Ma',
                                    range[0]
                                        .add(Duration(days: 2))
                                        .day
                                        .toString(),
                                    timeInMinutesOrHours(minutesUsed[2])),
                                DayBar(
                                    getHeightFactor(minutesUsed[3]),
                                    'Mi',
                                    range[0]
                                        .add(Duration(days: 3))
                                        .day
                                        .toString(),
                                    timeInMinutesOrHours(minutesUsed[3])),
                                DayBar(
                                    getHeightFactor(minutesUsed[4]),
                                    'Ju',
                                    range[0]
                                        .add(Duration(days: 4))
                                        .day
                                        .toString(),
                                    timeInMinutesOrHours(minutesUsed[4])),
                                DayBar(
                                    getHeightFactor(minutesUsed[5]),
                                    'Vi',
                                    range[0]
                                        .add(Duration(days: 5))
                                        .day
                                        .toString(),
                                    timeInMinutesOrHours(minutesUsed[5])),
                                DayBar(
                                    getHeightFactor(minutesUsed[6]),
                                    'Sa',
                                    range[0]
                                        .add(Duration(days: 6))
                                        .day
                                        .toString(),
                                    timeInMinutesOrHours(minutesUsed[6])),
                              ]),
                        ),
                      )),
                  Container(
                      alignment: Alignment.centerRight,
                      width: mediaQuery.size.width * 0.10,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        child: IconButton(icon: Icon(Icons.arrow_forward)),
                        onPressed: () {
                          if (weekCount < 0) {
                            weekCount++;
                            selectedDate = selectedDate.add(Duration(days: 7));
                            getUse(selectedDate);
                          }
                        },
                      )),
                ],
              ),
              Container(
                  child: Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Text(
                  'Total: ${timeInMinutesOrHours(totalUseInMinutes)}',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ))
            ],
          ));
    }

    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
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
                    //     //----------------------top column--------------
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
                          periodOrRangeRadio('Por semana'),
                          periodOrRangeRadio('Por día')
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
                      children: <Widget>[
                        Center(
                          child: Text(
                            monthOrMonthes,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        mode == 'Por semana'
                            ? weekBarsGraph()
                            : DayBar(
                                daySelectedMinutes == 0 ? 0 : 1,
                                translateDay(DateFormat('EEEE')
                                    .format(_firstSelectedDate)),
                                _firstSelectedDate.day.toString() +
                                    ' ' +
                                    getMonthName(_firstSelectedDate.month),
                                timeInMinutesOrHours(daySelectedMinutes))
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
                      child: Text(
                          'Hoy: ' + timeInMinutesOrHours(todayUse.minutes),
                          style: Theme.of(context).textTheme.headline6)))
            ])));
  }

  void moveToLastScreen() {
    //PianoApp.stopwatch.stop();
    debugPrint(PianoApp.stopwatch.elapsedMilliseconds.toString());
    Navigator.pop(context);
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
