import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper{
  static Database? _db;
  static final int _version=1;
  static final String _tablename="tasks";
  static Future<void> initDB()async{
    if (_db!=null){
      return;
    }
    try{
      String _path=await getDatabasesPath()+'tasks.db';
      _db=await openDatabase(
        _path,
        version: _version,
        onCreate: (db,version){
          print("creating new");
          return db.execute(
            "Create table $_tablename("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, date STRING, "
                "startTime STRING, endTime STRING, "
                "remind INTEGER, repeat STRING,"
                "color INTEGER, "
                "completedFor STRING"
                "isCompleted INTEGER)",
          );
        }
      );
    }
    catch(e){
      print(e);
    }
  }
  static Future<int> insert(Task?task)async{
    print("insert function called");
    print(task);
    return await _db?.insert(_tablename,task!.toJson())??1;
  }
  static Future<List<Map<String,dynamic>>> query() async{
    print("query");
    return await _db!.query(_tablename);
  }
  static delete(Task task)async{
    await _db!.delete(_tablename,where:"id=?",whereArgs: [task.id]);
  }
  static update(int id, String completedFor)async{
    return await _db!.rawUpdate('''
        UPDATE tasks
        SET isCompleted=?
        SET completedFor=?
        WHERE id=?
    ''',[1, completedFor, id]);
  }

}