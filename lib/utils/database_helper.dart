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

  String colId = 'id';

  //-----------------User table--------------------
  String userTable = 'user_table';
  String colUsername ='username';
  String colPassword = 'password';

  //-----------------Use table--------------------
  String useTable = 'use_table';
  String colUserId = 'userId';
  String colMinutes = 'minutes';
  String colDate = 'date';

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
    debugPrint('Database Created');
  }

  //-------------Insert User----------------
  Future<int> insertUser(User user) async {
    Database db = await this.database;
    int result =
        await db.insert(userTable, user.toMap());
    return result;
  }

//--------------Insert Use
   Future<int> insertUse(Use use) async {
    Database db = await this.database;
    int result =
        await db.insert(useTable, use.toMap());
    return result;
  }

//----------------Get all users map List
    Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $userTable ORDER BY $colId ASC');
    return result;
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

//----------------Get all uses from a user map List
    Future<List<Map<String, dynamic>>> getUseFromUserMapList(int userId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $useTable WHERE $colUserId = userId ORDER BY $colId ASC');
    return result;
  }


  //----------------Get last use from a user map 
    Future<Map<String, dynamic>> getLastUseFromUserMap(int userId) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $useTable WHERE $colUserId = userId ORDER BY $colId DESC LIMIT 1');
    if (result.length!=0)
      return result[0];
    else return null;
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
    if (map!=null)
    {
      Use object = Use.toUse(map);
      return object;
    } else return null;
  }


// ----------------------Update use
  Future<int> updateUse(Use use) async {
    Database db = await this.database;
    int result = await db.update(useTable, use.toMap(),
        where: '$colId = ?', whereArgs: [use.id]);
    return result;
  }


}

