

class Use{
  int _id;
  int _userId;
  int _minutes;
  DateTime _date;

  Use(this._userId,this._minutes,this._date);
  Use.withId(this._id,this._userId,this._minutes,this._date);

  int get id => _id;
  int get userId => _userId;
  int get minutes => _minutes;
  DateTime get date => _date;

  set userId(int newUserId){
    this._userId = newUserId;
  }

  set minutes(int newMinutes){
    this._minutes = newMinutes;
  }

  set date(DateTime newDate){
    this._date = newDate;
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = Map<String,dynamic>();

    if (_id != null){
      map['id'] = _id;
    }
    map['userId'] =_userId;
    map['minutes'] = _minutes;
    map['date'] = _date;
    return map;
  }

  Use.toUse(Map<String,dynamic> map){
    this._id = map['id'];
    this._userId = map['userId'];
    this._minutes = map['minutes'];
    this._date = map['date'];
  }
}