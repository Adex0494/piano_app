import 'package:flutter/material.dart';
import 'screens/piano_page.dart';
import 'dart:async';
import 'screens/reproduction_page.dart';
import './widgets/menu_option.dart';
import 'screens/statistics.dart';
void main() {
  runApp(PianoApp());
}

class PianoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Pianist Bot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.grey,
        //accentColor: Colors.white,
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  color: Colors.black,
                  //fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
              headline3: TextStyle(
                  color: Colors.black,
                  //fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
               headline1: TextStyle(
                  color: Colors.black,
                  //fontFamily: 'OpenSans',
                  fontWeight: FontWeight.normal,
                  fontSize: 12),
              button: TextStyle(color:Colors.white),
                  ),
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.black,),
        scaffoldBackgroundColor: Colors.white,
        hintColor: Colors.white,
        canvasColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  Widget scaffoldBody;
  //Color backgroundColor;
  AppBar appBar;
  @override
  initState() {
    super.initState();
    //backgroundColor= Colors.white;
    returnScaffoldBody();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    // TextStyle titleStyle = Theme.of(context).textTheme.title;
    // TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Scaffold(
      appBar: appBar,
      //backgroundColor: backgroundColor,
      body: scaffoldBody,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     navigateToMenuPage();
      //   },
      // ),
    );
  }
void returnScaffoldBody(){
    setState(() {
      scaffoldBody = Container(

        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/Fondo Piano blur.jpeg'),
          fit: BoxFit.cover
          )
        ),
        child:Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //     width: 200,
          //     height: 200,
          //     child: Image.asset('images/PianistBot-1.png')),
          Text('PIANIST BOT',style: TextStyle(
              color: Colors.white, fontSize: 36.0,fontWeight: FontWeight.bold),)
        ],
      ))
      );
    });
}

 void navigateToPianoPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PianoPage();
    }));
  }

  void navigateToReproductionPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ReproductionPage();
    }));
  }

    void navigateToControlPanelPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ControlPanelPage();
    }));
  }

  startTime() async {
    var duration = new Duration(seconds: 1);
    return new Timer(duration,menuScaffoldBody);
  }

  void menuScaffoldBody() {
    setState(() {
      appBar = AppBar(title: Text('Pianist Bot', style: TextStyle(color:Colors.white)),leading: null,);
      //backgroundColor=Colors.white;
      scaffoldBody= Column(
        children: <Widget>[
        MenuOption(0,4,0, 'Teclado',navigateToPianoPage,'images/piano.png'),   
        MenuOption(0,4,0, 'Biblioteca Musical',navigateToReproductionPage,'images/playButton.png'),
        MenuOption(0,4,2, 'Estadística',navigateToControlPanelPage,'images/controlPanel.png'),
        ],
      );
    });
  }
}