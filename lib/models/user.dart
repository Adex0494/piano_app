class User{
  int _id;
  String _username;
  String _password;

  User(this._username, this._password);
  User.withId(this._id,this._username, this._password);

  int get id => _id;
  String get username => _username;
  String get password => _password;

  set username(String newusername){
    this._username = newusername;
  }

  set password (String newPassword){
    this._password = newPassword;
  }


  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();

    if (_id != null){
      map['id'] = _id;
    }
    map['username'] = _username;
    map['password'] = _password;
    return map;
  }

  User.toUser(Map<String,dynamic> map){
    this._id = map['id'];
    this.username = map['username'];
    this._password = map['password'];
  }

}