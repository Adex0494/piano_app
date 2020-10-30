import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/day_bar.dart';

enum Range {
  FirstDay,
  LastDay,
}

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String mode = 'Por periodo';
  String period = 'Semanal';
  DateTime _firstSelectedDate;
  DateTime _lastSelectedDate;

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
                                  onPressed: null,
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
                                          DayBar(0.5, 'Lu'),
                                          DayBar(0.2, 'Ma'),
                                          DayBar(0.3, 'Mi'),
                                          DayBar(0.7, 'Ju'),
                                          DayBar(0.35, 'Vi'),
                                          DayBar(0.6, 'Sa'),
                                          DayBar(0.4, 'Do'),
                                        ]),
                                  ),
                                )),
                            Container(
                                alignment: Alignment.centerRight,
                                width: mediaQuery.size.width * 0.10,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  child: IconButton(icon: Icon(Icons.arrow_forward)),
                                  onPressed: null,
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
                      child: Text('Hoy',
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
