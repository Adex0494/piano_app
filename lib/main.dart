import 'package:flutter/material.dart';
import 'screens/piano_page.dart';
import 'screens/menu_page.dart';

void main() {
  runApp(PianoApp());
}

class PianoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Piano Bot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      //    primarySwatch: Colors.black,
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
  @override
  Widget build(BuildContext context) {
    // TextStyle titleStyle = Theme.of(context).textTheme.title;
    // TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Scaffold(
      appBar: AppBar(title: Text('Inicio')),
      backgroundColor: Colors.black,
      // body: scaffoldBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToMenuPage();
        },
      ),
    );
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
}