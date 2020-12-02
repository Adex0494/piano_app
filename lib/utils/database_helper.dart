import 'package:piano/models/song.dart';

import '../models/use.dart';
import '../models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
  bool firstTimeDb = false;

  String colId = 'id';

  //-----------------User table--------------------
  String userTable = 'user_table';
  String colUsername = 'username';
  String colPassword = 'password';

  //-----------------Use table--------------------
  String useTable = 'use_table';
  String colUserId = 'userId';
  String colMinutes = 'minutes';
  String colDate = 'date';

  //------------------Song table---------------------
  String songTable = 'song_table';
  String colName = 'name';
  String colCodification = 'codification';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    //debugPrint('Getting database');
    if (_database == null) {
      debugPrint('Initializing database');
      _database = await initializeDatabase();
      if(firstTimeDb){
        firstTimeDb = false;
        await insertDefaultSongs();
      }
    }
    //debugPrint('returning database');
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'pianoApp.db';
    debugPrint('Opening database');
    var pianoDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return pianoDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    debugPrint('Creating database');
    await db.execute(
        'CREATE TABLE $userTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colUsername TEXT NOT NULL,'
        '$colPassword TEXT NOT NULL)');
    await db.execute(
        'CREATE TABLE $useTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colUserId INTEGER,$colMinutes INTEGER NOT NULL,$colDate TEXT NOT NULL,'
        'FOREIGN KEY ($colUserId) REFERENCES $userTable ($colId))');
    await db.execute(
        'CREATE TABLE $songTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT NOT NULL,'
        '$colCodification TEXT NOT NULL)');
    debugPrint('Database Created');
    firstTimeDb = true;
  }

  Future<void> insertDefaultSongs()async{
     List<Song> songsByDefect = [
      Song('La Estrellita', 'La Estrellita'),
      Song('Feliz Navidad', 'Feliz Navidad'),
      Song('Santa Claus Is Coming to Town', 'Santa Claus Is Coming to Town')
    ];
    for (int i = 0; i < songsByDefect.length; i++)
      await insertSong(songsByDefect[i]);
  }
    //-------------Insert Song----------------
  Future<int> insertSong(Song song) async {
    Database db = await this.database;
    int result = await db.insert(songTable, song.toMap());
    return result;
  }

  //-------------Insert User----------------
  Future<int> insertUser(User user) async {
    Database db = await this.database;
    int result = await db.insert(userTable, user.toMap());
    return result;
  }

//--------------Insert Use
  Future<int> insertUse(Use use) async {
    Database db = await this.database;
    int result = await db.insert(useTable, use.toMap());
    return result;
  }

//----------------Get all songs map List
  Future<List<Map<String, dynamic>>> getSongMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $songTable ORDER BY $colId ASC');
    return result;
  }

//----------------Get all users map List
  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $userTable ORDER BY $colId ASC');
    return result;
  }

//----------------Get all uses map List
  Future<List<Map<String, dynamic>>> getUseMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $useTable ORDER BY $colId ASC');
    return result;
  }

  //------------------Get a user map
  Future<Map<String, dynamic>> getAUserMap(String username) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery("SELECT * FROM $userTable WHERE $colUsername='$username'");
    if (result.length != 0) {
      return result[0];
    } else {
      return null;
    }
  }

//-----------------Get all songs object List

  Future<List<Song>> getSongList() async {
    List<Map<String, dynamic>> mapList = await getSongMapList();
    int count = mapList.length;
    List<Song> objectList = List<Song>();
    for (int i = 0; i < count; i++) {
      objectList.add(Song.toSong(mapList[i]));
    }
    return objectList;
  }

//-----------------Get all users object List

  Future<List<User>> getUserList() async {
    List<Map<String, dynamic>> mapList = await getUserMapList();
    int count = mapList.length;
    List<User> objectList = List<User>();
    for (int i = 0; i < count; i++) {
      objectList.add(User.toUser(mapList[i]));
    }
    return objectList;
  }

  //-----------------Get all uses object List

  Future<List<Use>> getUseList() async {
    List<Map<String, dynamic>> mapList = await getUseMapList();
    int count = mapList.length;
    List<Use> objectList = List<Use>();
    for (int i = 0; i < count; i++) {
      objectList.add(Use.toUse(mapList[i]));
    }
    return objectList;
  }

//-----------------Get a users object

  Future<User> getAUser(String username) async {
    Map<String, dynamic> map = await getAUserMap(username);
    if (map != null) {
      User object = User.toUser(map);
      return object;
    } else {
      return null;
    }
  }

//----------------Get all uses from a user map List
  Future<List<Map<String, dynamic>>> getUseFromUserMapList(int userId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $useTable WHERE $colUserId = $userId ORDER BY $colId ASC');
    return result;
  }

//----------------Get use from a user with a specified date map List
  Future<Map<String, dynamic>> getUseFromUserAndDateMap(
      int thisUserId, String date) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM $useTable WHERE $colUserId = $thisUserId AND $colDate LIKE '$date%' ORDER BY $colId ASC");
    if (result.length != 0) {
      return result[0];
    } else
      return null;
  }

  //----------------Get last use from a user map
  Future<Map<String, dynamic>> getLastUseFromUserMap(int userId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM $useTable WHERE $colUserId = $userId ORDER BY $colId DESC LIMIT 1');
    if (result.length != 0)
      return result[0];
    else
      return null;
  }

//-----------------Get all uses from a user object List

  Future<List<Use>> getUseFromUserList(int userId) async {
    List<Map<String, dynamic>> mapList = await getUseFromUserMapList(userId);
    int count = mapList.length;
    List<Use> objectList = List<Use>();
    for (int i = 0; i < count; i++) {
      objectList.add(Use.toUse(mapList[i]));
    }
    return objectList;
  }

  //----------------------Get last use object
  Future<Use> getLastUseFromUser(int userId) async {
    Map<String, dynamic> map = await getLastUseFromUserMap(userId);
    if (map != null) {
      Use object = Use.toUse(map);
      return object;
    } else
      return null;
  }

  //-----------------Get use from a user and a date object List

  Future<Use> getUseFromUserAndDate(int userId, String date) async {
    Map<String, dynamic> map = await getUseFromUserAndDateMap(userId, date);
    if (map != null) {
      Use object = Use.toUse(map);
      return object;
    } else
      return null;
  }

// ----------------------Update use
  Future<int> updateUse(Use use) async {
    Database db = await this.database;
    int result = await db.update(useTable, use.toMap(),
        where: '$colId = ?', whereArgs: [use.id]);
    return result;
  }

  //--------------------Delete song
    //Delete Trainer
  Future<int> deleteSong(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $songTable WHERE $colId = $id');
    return result;
  }
}
