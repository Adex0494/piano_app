import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import './screens/add_user.dart';
import './screens/menu_page.dart';
import './screens/piano_page.dart';
import './screens/reproduction_page.dart';
import './utils/database_helper.dart';
import './models/use.dart';
import './models/user.dart';

void main() {
  runApp(PianoApp());
}

class PianoApp extends StatelessWidget {
  static Stopwatch stopwatch = Stopwatch();
  static bool connected = false;
  //'http://10.0.0.11:5000'
  //'http://192.168.0.5:5000'
  static String urlBase = 'http://10.0.0.11:5000';
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

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Widget scaffoldBody;
  //Color backgroundColor;
  AppBar appBar;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordControler = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool stopWatchWasRunning = false;
  int userId;


  void sendHttpPostRequestPing() {
    //debugPrint(PianoApp.connected.toString());
    //const url = 'https://pianoapp-f3679.firebaseio.com/keys.json';
    String url = PianoApp.urlBase + '/ping';
    PianoApp.connected =false;
    http.post(url).then((response) {
      PianoApp.connected = true;
    }).catchError((handleError){PianoApp.connected =false;});
  }

  @override
  initState() {
    const oneSec = const Duration(milliseconds: 3000);
    new Timer.periodic(oneSec, (Timer t) => sendHttpPostRequestPing());

    WidgetsBinding.instance.addObserver(this);
    super.initState();
    returnScaffoldBody();
    startTime();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint(state.toString());
    switch (state) {
      case AppLifecycleState.inactive:
        if (PianoApp.stopwatch.isRunning) {
          PianoApp.stopwatch.stop();
          stopWatchWasRunning = true;
        }
        debugPrint(PianoApp.stopwatch.elapsedMilliseconds.toString());
        if (PianoApp.stopwatch.elapsedMilliseconds > 30000) saveTime(userId);
        break;
      case AppLifecycleState.resumed:
        if (stopWatchWasRunning) {
          PianoApp.stopwatch.start();
          stopWatchWasRunning = false;
        }
        //if (PianoApp.stopwatch.elapsedMilliseconds > 30000) saveTime();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void saveTime(int userId) async {
    debugPrint('saving');
    if (PianoApp.stopwatch.isRunning) PianoApp.stopwatch.stop();
    int timeInMinutes =
        (PianoApp.stopwatch.elapsedMilliseconds / 60000).round();

    Use lastUseSaved = await databaseHelper.getLastUseFromUser(userId);
    DateTime lastUseSavedDate = DateTime(2019);
    if (lastUseSaved != null)
      lastUseSavedDate = DateTime.tryParse(lastUseSaved.date);
    if (lastUseSaved != null &&
        lastUseSavedDate.day == DateTime.now().day &&
        lastUseSavedDate.month == DateTime.now().month &&
        lastUseSavedDate.year == DateTime.now().year) {
      lastUseSaved.minutes += timeInMinutes;
      lastUseSaved.date = DateTime.now().toString();
      await databaseHelper.updateUse(lastUseSaved);
      debugPrint('updated time saved');
      PianoApp.stopwatch.reset();
    } else {
      Use firstUseToday = Use(userId, timeInMinutes, DateTime.now().toString());
      await databaseHelper.insertUse(firstUseToday);
      debugPrint('saved new');
      PianoApp.stopwatch.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TextStyle titleStyle = Theme.of(context).textTheme.title;
    // TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Scaffold(
      appBar: appBar,
      backgroundColor: Color.fromRGBO(59, 77, 101, 1),
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
                  image: AssetImage('images/pianoWelcome.jpg'),
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
                '',
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
      TextStyle subtitleStyle = TextStyle(color: Colors.white, fontSize: 14);
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
                    Padding(
                      padding: const EdgeInsets.all(45.0),
                      child: Column(
                        children: [
                          Container(
                              width: 100,
                              height: 100,
                              child: Image.asset('images/piano.png')),
                          Text(
                            'PIANIST BOT',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      style: subtitleStyle,
                      controller: usernameController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          labelText: 'Nombre de Usuario',
                          labelStyle: subtitleStyle,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      // enabledBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.redAccent),
                      //   borderRadius: BorderRadius.circular(5.0),
                      // )

                      onChanged: (value) {
                        //when Usuario text changes...
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3, bottom: 3),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: passwordControler,
                        cursorColor: Colors.white,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: subtitleStyle,
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: double.infinity)),
                            icon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.redAccent),
                            //   borderRadius: BorderRadius.circular(5.0),
                            // )
                            ),
                        onChanged: (value) {
                          //when Usuario text changes...
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
                      child: Column(
                        children: <Widget>[
                          RaisedButton(
                            elevation: 3.0,
                            color: Color.fromRGBO(16, 183, 202, 1),
                            child: Container(
                              width: double.infinity,
                              height: 30,
                              child: Center(
                                child: Text(
                                  'INICIAR SESIÓN',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                  //textScaleFactor: 1.5,
                                ),
                              ),
                            ),
                            onPressed: () {
                              //navigateToMenuPage();
                              //When the Iniciar Sesión button is pressed...
                              _validateThenNavigate();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                          FlatButton(
                              onPressed: navigateToAddUser,
                              child: Text(
                                'Registrarse',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ))
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

  void _validateThenNavigate() async {
    User user = await databaseHelper.getAUser(usernameController.text);
    if (user != null) {
      if (passwordControler.text == user.password) {
        setState(() {
          userId = user.id;
        });

        navigateToMenuPage(user.id);
      } else {
        _showAlertDialog('Contraseña', 'La Contraseña es incorrecta.');
      }
    } else {
      _showAlertDialog('Nombre de Usuario', 'El Nombre de Usuario no existe.');
    }
  }

  void _blankCredentials() {
    setState(() {
      PianoApp.stopwatch.stop();
      PianoApp.stopwatch.reset();
      userId = null;
      usernameController.text = '';
      passwordControler.text = '';
    });
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void navigateToMenuPage(int userId) async {
    debugPrint('$userId');
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MenuPage(userId, saveTime);
    }));
    if (result) {
      _blankCredentials();
    }
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

  // void navigateToStatisticsPage() {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return StatisticsPage();
  //   }));
  // }

  void navigateToAddUser() async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddUser();
    }));
    if (result) {
      _blankCredentials();
    }
  }
}
