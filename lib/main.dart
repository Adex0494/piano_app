import 'package:flutter/material.dart';
import 'dart:async';

import './screens/login.dart';
import './screens/menu_page.dart';
import './screens/piano_page.dart';
import './screens/reproduction_page.dart';
import './screens/statistics.dart';

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
              button: TextStyle(color: Colors.white),
            ),
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.black,
        ),
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
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordControler = TextEditingController();

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

  void returnScaffoldBody() {
    setState(() {
      scaffoldBody = Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/Fondo Piano blur.jpeg'),
                  fit: BoxFit.cover)),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //     width: 200,
              //     height: 200,
              //     child: Image.asset('images/PianistBot-1.png')),
              Text(
                'PIANIST BOT',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          )));
    });
  }

  // void navigateToLogin() {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return Login();
  //   }));
  // }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, login);
  }

  void login() {
    setState(() {
      TextStyle subtitleStyle = Theme.of(context).textTheme.headline3;
      appBar = AppBar(
        title: Text('Login', style: TextStyle(color: Colors.white)),
        leading: null,
      );
      scaffoldBody = Container(
        alignment: Alignment.center,
        child: Form(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      style: subtitleStyle,
                      controller: usernameController,
                      decoration: InputDecoration(
                          labelText: 'Nombre de Usuario',
                          labelStyle: subtitleStyle,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                      onChanged: (value) {
                        //when Usuario text changes...
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3, bottom: 3),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: passwordControler,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: subtitleStyle,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        onChanged: (value) {
                          //when Usuario text changes...
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3, bottom: 3),
                      child: Row(
                        children: <Widget>[
                          RaisedButton(
                            elevation: 3.0,
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'Iniciar Sesión',
                              style: TextStyle(color: Colors.white),
                              //textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              navigateToMenuPage();
                              //When the Iniciar Sesión button is pressed...
                              //_validateThenNavigate();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
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

  void navigateToControlPanelPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ControlPanelPage();
    }));
  }
}
