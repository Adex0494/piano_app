import 'package:flutter/material.dart';

class DayBar extends StatelessWidget {
  final double timePorcentage;
  final String day;
  final String dayNumber;
  String time;

  DayBar(this.timePorcentage,this.day,this.dayNumber,this.time);
  @override
  Widget build(BuildContext context) {
    return Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
            Text(dayNumber,style: Theme.of(context).textTheme.headline1,),
             Transform.rotate( 
               angle: -3.1416,
               child:Container(
                //color: Colors.white,
                width: 30,
                height: 150,
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(20))
                  ),

                  FractionallySizedBox(
                  heightFactor: timePorcentage,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                  ))

                ],),
              )),
              Text(day,style: Theme.of(context).textTheme.headline1,),
              Text(time,style: Theme.of(context).textTheme.headline1,)
            
            ]);
  }
}