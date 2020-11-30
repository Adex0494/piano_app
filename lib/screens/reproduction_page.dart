import 'dart:async';

import 'package:flutter/material.dart';
import 'package:piano/models/song.dart';
import 'package:piano/utils/database_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'play_page.dart';
import '../main.dart';

class ReproductionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReproductionPageState();
  }
}

class ReproductionPageState extends State<ReproductionPage> {
  List<Song> theSongs = List<Song>();
  DatabaseHelper databaseHelper = DatabaseHelper();
  Timer timer;

  bool connected = false;

  void askForConnection() {
    //debugPrint(PianoApp.connected.toString());
    if (PianoApp.connected != connected)
      setState(() {
        connected = PianoApp.connected;
      });
  }

  @override
  initState() {
    loadSongs();
    const oneSec = const Duration(milliseconds: 3000);
    timer = new Timer.periodic(oneSec, (Timer t) => askForConnection());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void moveToLastScreen() {
    PianoApp.stopwatch.stop();
    debugPrint(PianoApp.stopwatch.elapsedMilliseconds.toString());
    Navigator.pop(context);
  }

  loadSongs() async {
    List<Song> auxSongs = await databaseHelper.getSongList();

    setState(() {
      this.theSongs = auxSongs;
    });
  }

  void sendHttpPostRequest(String codification) {
    debugPrint(codification);
    //const url = 'https://pianoapp-f3679.firebaseio.com/keys.json';
    String url = PianoApp.urlBase + '/play';
    http.post(url,
        body: json.encode({'codification': codification}),
        headers: {'Content-type': 'application/json'}).then((response) {});
  }

  @override
  Widget build(BuildContext context) {
    if (!PianoApp.stopwatch.isRunning) {
      debugPrint(PianoApp.stopwatch.elapsedMilliseconds.toString());
      PianoApp.stopwatch.start();
    }
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Lista de reproducción',
            style: TextStyle(color: Colors.white),
          ),
          leading: Icon(
            Icons.circle,
            color: PianoApp.connected ? Colors.green : Colors.grey,
          ),
        ),
        //backgroundColor: Colors.black,
        body: scaffoldBody(),
      ),
    );
  }

  Widget scaffoldBody() {
    return ListView.builder(
        //shrinkWrap: true,
        itemCount: theSongs.length,
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
                theSongs[position].name,
                //style: subtitleStyle,
              ),
              onTap: () {
                sendHttpPostRequest(theSongs[position].codification);
                navigateToPlayPage(theSongs[position].name);
                //When suscriber is tapped...
                //navigateToSubscriberPage(subscriberList[position]);
              },
              trailing: IconButton(
                tooltip: 'Eliminar canción',
                //color: Colors.black,
                icon: Icon(Icons.delete, color: Colors.black,),
                onPressed:(){deleteSong(theSongs[position].id);},
              ),
            ),
          );
        });
  }

  void deleteSong(int id)async{
    await databaseHelper.deleteSong(id);
    List<Song> auxSongs = await databaseHelper.getSongList();
    setState(() {
      this.theSongs = auxSongs;
    });
  }

  void navigateToPlayPage(String theSongName) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PlayPage(theSongName);
    }));
  }
}
