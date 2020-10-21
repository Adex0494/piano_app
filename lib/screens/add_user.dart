import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  var _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title:Text('Registrar usuario')),
      backgroundColor: Color.fromRGBO(59, 77, 101, 1),
      body: scaffoldBody(),
    );
  }

  Widget scaffoldBody() {
    TextStyle subtitleStyle = TextStyle(color: Colors.white, fontSize: 14);
    return Container(
      alignment: Alignment.center,
      child: Form(
        key: _formkey,
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
                  Padding(
                      padding: EdgeInsets.all(3.0),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: usernameController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca el Nombre de Usuario';
                          }
                        },
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
                        onChanged: (value) {
                          //When Name Text has changed...
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.all(3.0),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: passwordController,
                        obscureText: true,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca la Contraseña';
                          } else {
                            if(value !=passwordController1.text)
                            {
                              return 'Las Contraseñas no coinciden';
                            }
                            else
                            if (value.length < 6) {
                              return 'La Contraseña debe tener más de 5 caracteres';
                            }
                          }
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: subtitleStyle,
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
                          //When Name Text has changed...
                        },
                      )),
                      Padding(
                      padding: EdgeInsets.all(3.0),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: passwordController1,
                        obscureText: true,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca la Contraseña';
                          } else {
                            if(value !=passwordController.text)
                            {
                              return 'Las Contraseñas no coinciden';
                            }
                            else
                            if (value.length < 6) {
                              return 'La Contraseña debe tener más de 5 caracteres';
                            }
                          }
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            labelText: 'Repita Contraseña',
                            labelStyle: subtitleStyle,
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
                          //When Name Text has changed...
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
                      child: RaisedButton(
                              elevation: 3.0,
                              color: Color.fromRGBO(16, 183, 202, 1),
                              child: Container(
                                width: double.infinity,
                                height: 30,
                                child: Center(
                                  child: Text(
                                    'Registrar',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    textAlign: TextAlign.center,
                                    //textScaleFactor: 1.5,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                //When the Iniciar Sesión button is pressed...
                                //_validateThenNavigate();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}