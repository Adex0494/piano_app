import 'package:flutter/material.dart';
import 'play_page.dart';

class ReproductionPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return ReproductionPageState();
  }
}

class ReproductionPageState extends State<ReproductionPage>{
  List<String> songs = List<String>();

  initState() {
    super.initState();
    songs = ['Lose yourself','Ya me enteré','Creo en ti','La Gasolina','Punto y aparte','Pa que se lo goce','Ni fu ni fa','Noviembre sin ti','Aquí estoy',
    'Sinfonía de Bethoven','The four seasons','Volverte a ver','Te amo'];
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Lista de reproducción')),
      backgroundColor: Colors.black,
      body: scaffoldBody(),
    );
  }

  Widget scaffoldBody(){
    return ListView.builder(
        //shrinkWrap: true,
          itemCount: songs.length,
          itemBuilder: (BuildContext context, int postition) {
            return Card(
              color: Theme.of(context).primaryColorLight,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
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