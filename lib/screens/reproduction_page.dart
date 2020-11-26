import 'package:flutter/material.dart';
import 'package:piano/models/song.dart';
import 'package:piano/utils/database_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  List<Song> theSongs;
  DatabaseHelper databaseHelper = DatabaseHelper();

  void moveToLastScreen() {
    PianoApp.stopwatch.stop();
     debugPrint(PianoApp.stopwatch.elapsedMilliseconds.toString());
    Navigator.pop(context);
  }

  initState() {
    super.initState();
    loadSongs();
  }

  loadSongs()async{
    List<Song> songsByDefect = [Song('La Estrellita','La Estrellita'),Song('Feliz Navidad','Feliz Navidad')];
    List<String> auxSongs = List<String>();

    for(int i=0;i<songsByDefect.length;i++)
      auxSongs.add(songsByDefect[i].name);

    theSongs = songsByDefect;
    List<Song> auxTheSongs = await databaseHelper.getSongList();
    for (int i =0;i<auxTheSongs.length;i++){
      auxSongs.add(auxTheSongs[i].name);
      theSongs.add(auxTheSongs[i]);
    }
    setState(() {
      this.songs=auxSongs;
    });
  }
  
      void sendHttpPostRequest(String codification) {
        debugPrint(codification);
      //const url = 'https://pianoapp-f3679.firebaseio.com/keys.json';
      String url = PianoApp.urlBase + '/play';
      http.post(url,
          body: json.encode({'codification': codification}),
          headers: {'Content-type': 'application/json'}).then((response) {
      });

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
          itemBuilder: (BuildContext context, int position) {
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
                  songs[position],
                  //style: subtitleStyle,
                ),
                onTap: () {
                  sendHttpPostRequest(theSongs[position].codification);
                  navigateToPlayPage(theSongs[position].name);
                  //When suscriber is tapped...
                  //navigateToSubscriberPage(subscriberList[position]);
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