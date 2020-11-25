class Song {
  int _id;
  String _name;
  String _codification;

  Song(this._name,this._codification);
  Song.withId(this._id,this._name,this._codification);

  int get id => _id;
  String get name => _name;
  String get codification => _codification;

   set name(String newName){
    this._name = newName;
  }

    set codification(String newCodification){
    this._codification = newCodification;
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();

    if (_id != null){
      map['id'] = _id;
    }
    map['name'] =_name;
    map['codification'] = _codification;
    return map;
  }

    Song.toSong(Map<String,dynamic> map){
    this._id = map['id'];
    this._name = map['name'];
    this._codification = map['codification'];
  }

}