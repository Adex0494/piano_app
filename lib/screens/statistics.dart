import 'package:flutter/material.dart';
import '../widgets/day_bar.dart';

class ControlPanelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title:Text('Estadística',style: TextStyle(color:Colors.white))),
      //backgroundColor: Colors.black,
      body: Column(
      children:<Widget>
      [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('7 horas',style: Theme.of(context).textTheme.headline6,),
        ), 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Hoy',style: Theme.of(context).textTheme.headline3),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Row( 
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:<Widget>[
              DayBar(0.5,'Lu'),
              DayBar(0.2,'Ma'),
              DayBar(0.3,'Mi'),
              DayBar(0.7,'Ju'),
              DayBar(0.35,'Vi'),
              DayBar(0.6,'Sa'),
              DayBar(0.4,'Do'),
            ]),
          ),
        ),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Text('Mi., 14 oct',style: Theme.of(context).textTheme.headline3),
         )  
      ]
    ),
    );
  }
}