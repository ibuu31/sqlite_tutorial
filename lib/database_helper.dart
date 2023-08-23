import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //dbName is a name for database file.
  static const dbName = 'dataBase.db';
  //initial version of database.
  static const version = 1;
  //creating table in database.
  static const table = 'myTable';
  //declaring columns for table
  static const columnId = 'id';
  static const columnName = 'name';

  //creating constructor for DatabaseHelper so that we can utilize the variables.
  static final DatabaseHelper instance = DatabaseHelper();
  //Initializing database, Database is to send sql commands, which came from sqlite package and creating _database object
  static Database? _database;

// if the variable doesn't exist then this will initialize the database.
  Future<Database?> get database async {
    //?? returns the right side of operand if left side is null.
    _database ??= await initDb();
    return _database;
  }

  initDb() async {
    //path provider is used to get our database directory
    Directory directory = await getApplicationDocumentsDirectory();
    //this line joins the file with path
    String path = join(directory.path, dbName);
    //we are initializing the path that we want to open.
    return await openDatabase(path, version: version, onCreate: create);
  }

//writing query for creating table and column
  Future create(Database db, int version) async {
    db.execute('''
      
      CREATE TABLE $table(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL
      )
    ''');
    print('Database is created');
  }

//to insert value in record
  insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

// reading the values
  Future<List<Map<String, dynamic>>> queryDatabase() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

//updating the record
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

//deleting record
  Future<int?> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  //getting records
  // Future<List> getAllRecords(String myTable) async {
  //   var dbClient = await database;
  //   var result = await dbClient?.rawQuery("SELECT * FROM $myTable");
  //
  //   return result!.toList();
  // }
}
