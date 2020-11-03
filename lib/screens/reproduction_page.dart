import 'package:flutter/material.dart';

import 'play_page.dart';
import '../main.dart';

class ReproductionPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return ReproductionPageState();
  }
}

class ReproductionPageState extends State<ReproductionPage>{
  List<String> songs = List<String>();

  void moveToLastScreen() {
    PianoApp.stopwatch.stop();
     debugPrint(PianoApp.stopwatch.elapsedMilliseconds.toString());
    Navigator.pop(context);
  }

  initState() {
    super.initState();
    songs = ['Lose yourself','Ya me enteré','Creo en ti','La Gasolina','Punto y aparte','Pa que se lo goce','Ni fu ni fa','Noviembre sin ti','Aquí estoy',
    'Sinfonía de Bethoven','The four seasons','Volverte a ver','Te amo'];
  }

  @override
  Widget build(BuildContext context){
    if(!PianoApp.stopwatch.isRunning)
      {
        debugPrint(PianoApp.stopwatch.elapsedMilliseconds.toString());
        PianoApp.stopwatch.start();}
    return WillPopScope(
       onWillPop: () {
       moveToLastScreen();
      },
          child: Scaffold(
        appBar: AppBar(title: Text('Lista de reproducción',style: TextStyle(color: Colors.white),)),
        //backgroundColor: Colors.black,
        body: scaffoldBody(),
      ),
    );
  }

  Widget scaffoldBody(){
    return ListView.builder(
        //shrinkWrap: true,
          itemCount: songs.length,
          itemBuilder: (BuildContext context, int postition) {
            return Card(
              color: Colors.white,
              elevation: 5.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  //child: Icon(Icons.person),
                  //backgroundImage:ImageProvider('images/faceIcon.png'),
                  child: Icon(Icons.play_arrow),
                ),
                title: Text(
                  songs[postition],
                  //style: subtitleStyle,
                ),
                onTap: () {
                  navigateToPlayPage(songs[postition]);
                  //When suscriber is tapped...
                  //navigateToSubscriberPage(subscriberList[postition]);
                },
              ),
            );
          })
    ;
  }

  void navigateToPlayPage(String theSongName) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PlayPage(theSongName);
    }));
  }
}