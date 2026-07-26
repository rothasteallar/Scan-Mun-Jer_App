
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/scan_result.dart';

//Manage the local sqlite database
//Handle all save. read, and delete for scan history
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  //when called DatabaseHelper(), get that instance that contain database object
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  Database? database;

  //Open/create the database and table
  Future<Database> initDatabase() async {
    //join path so can find path on phone
    final String path = join(await getDatabasesPath(), 'scan_mun_jer.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        //run only once to create table structure when app is first installed
        await db.execute('''
          create table scan_results(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT NOT NULL,
            verdict TEXT NOT NULL,
            riskScore INTEGER NOT NULL,
            source TEXT NOT NULL,
            timestamp INTEGER NOT NULL,
            triggeredRules TEXT NOT NULL,
            threatTypes TEXT NOT NULL
            )
          ''');
      },
    );
  }

  //Get database, open it if not opened yet
  Future<Database> getDatabase() async {
    if (database != null) {
      return database!;
    } else {
      database = await initDatabase();
      return database!;
    }
  }

  //Save a new scan, get the row id
  Future<int> insertScan(ScanResult result) async {
    final Database db = await getDatabase();

    return db.insert('scan_results', result.toMap());
  }

  //Get all scans, newest first
  Future<List<ScanResult>> getAllScans() async {
    final Database db = await getDatabase();
    //get list of map(key = column, value = cell)
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_results',
      orderBy: 'timestamp DESC',
    );

    final List<ScanResult> scans = [];

    for (var m in maps) {
      scans.add(ScanResult.fromMap(m));
    }

    return scans;
  }

  //Delete one scan
  Future<void> deleteScan(int id) async {
    final Database db = await getDatabase();

    await db.delete('scan_results', where: 'id = $id');
  }

  //Delete all scans at once
  Future<void> deleteAllScans() async {
    final Database db = await getDatabase();

    await db.delete('scan_results');
  }
}
