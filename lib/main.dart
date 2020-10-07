import 'package:flutter/material.dart';
import 'screens/piano_page.dart';
import 'screens/menu_page.dart';
import 'dart:async';
import 'screens/reproduction_page.dart';

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
        //primarySwatch: Colors.black,
        textTheme: TextTheme(
            headline6: TextStyle(color: Colors.white),
            subtitle2: TextStyle(color: Colors.white)),
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
  Color backgroundColor;
  AppBar appBar;
  @override
  initState() {
    super.initState();
    backgroundColor= Colors.white;
    returnScaffoldBody();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    // TextStyle titleStyle = Theme.of(context).textTheme.title;
    // TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
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
          Text('Pianist Bot',style: TextStyle(
              color: Colors.white, fontSize: 36.0,fontWeight: FontWeight.bold),)
        ],
      ))
      );
    });
}

 void navigateToMenuPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MenuPage();
    }));
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

  startTime() async {
    var duration = new Duration(seconds: 7);
    return new Timer(duration,menuScaffoldBody);
  }

  Widget menuOption (String imageDir, String text, double topAndSidePadding,double bottomPadding,Function function){
    return
      Expanded(

          child: Center(
              child: Padding(
                  padding: EdgeInsets.only(top:topAndSidePadding,bottom: bottomPadding,left: topAndSidePadding,right: topAndSidePadding),
                  child: Container(

                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 100.0,
                              height: 100.0,
                              child: FlatButton(
                                  onPressed: function,
                                  child: Image.asset(imageDir)),
                            ),
                            (Text(
                              text,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ))
                          ])))));
  }

  void menuScaffoldBody() {
    setState(() {
      appBar = AppBar(title: Text('Pianist Bot'),leading: null,);
      backgroundColor=Colors.black;
      scaffoldBody= Column(
        children: <Widget>[
          menuOption('images/teclado.png', 'Teclado',4.0,0,navigateToPianoPage),
          menuOption('images/biblioteca musical.png', 'Biblioteca Musical',4.0,0,navigateToReproductionPage),
          menuOption('images/panel de control.png', 'Panel de Control',4.0,4.0,navigateToPianoPage)
        ],
      );
    });
  }
}