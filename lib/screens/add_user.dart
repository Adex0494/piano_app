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
      body: scaffoldBody(),
    );
  }

  Widget scaffoldBody() {
    //TextStyle titleStyle = Theme.of(context).textTheme.title;
    TextStyle subtitleStyle = Theme.of(context).textTheme.headline3;
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
                      padding: EdgeInsets.all(3.0),
                      child: TextFormField(
                        style: subtitleStyle,
                        controller: usernameController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduzca el Nombre de Usuario';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Nombre de Usuario',
                            labelStyle: subtitleStyle,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(5.0))),
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
                        decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: subtitleStyle,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(5.0))),
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
                        decoration: InputDecoration(
                            labelText: 'Repita Contraseña',
                            labelStyle: subtitleStyle,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(5.0))),
                        onChanged: (value) {
                          //When Name Text has changed...
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: RaisedButton(
                      elevation: 3.0,
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Registrar usuario',
                        style: TextStyle(color: Colors.white),
                        //textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        //When the Registrar button is pressed...
                        //if (_formkey.currentState.validate())
                          //_validateThenSave();
                        // setState(() {
                        //   debugPrint('Registrar button Pressed');
                        //   Trainer trainer = Trainer(nameController.text,0);
                        //   debugPrint('trainer created');
                        //   _saveTrainer(trainer);
                        // });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
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