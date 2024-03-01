import 'dart:io';

import 'package:mezamashi/AlarmFactory.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'MyAlarm.dart';

class DatabaseHelper{

  static const _databaseName = "MyDatabase.db"; // DB名
  static const _databaseVersion = 1; // スキーマのバージョン指定

  static const alarmTable = 'alarm_table'; // テーブル名
  static const pointTable = 'point_table'; // テーブル名

  static const columnAId = 'a_id'; // カラム名：ID
  static const columnHour = 'hour'; // カラム名:hour
  static const columnMin = 'min'; // カラム名:min
  static const columnAudioNum = 'audio_num'; // カラム名:audio_num
  static const columnValid = 'validity'; // カラム名:validity

  static const columnPId = 'p_id'; // カラム名：ID
  static const columnPoint = 'point'; // カラム名：point
  static const columnTime = 'created_at'; //カラム名：created_at (タイムスタンプ)

  // DatabaseHelper クラスを定義
  DatabaseHelper._privateConstructor();
  //singleton
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  // databaseメソッド定義
  // 非同期処理
  Future<Database?> get database async {
    // _databaseがNULLか判定
    // NULLの場合、_initDatabaseを呼び出しデータベースの初期化し、_databaseに返す
    // NULLでない場合、そのまま_database変数を返す
    // これにより、データベースを初期化する処理は、最初にデータベースを参照するときにのみ実行されるようになります。
    // このような実装を「遅延初期化 (lazy initialization)」と呼びます。
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // データベース接続
  _initDatabase() async {
    // アプリケーションのドキュメントディレクトリのパスを取得
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // 取得パスを基に、データベースのパスを生成
    String path = join(documentsDirectory.path, _databaseName);
    // データベース接続
    return await openDatabase(path,
        version: _databaseVersion,
        // テーブル作成メソッドの呼び出し
        onCreate: _onCreate);
  }

  // テーブル作成
  // 引数:dbの名前
  // 引数:スキーマーのversion
  // スキーマーのバージョンはテーブル変更時にバージョンを上げる（テーブル・カラム追加・変更・削除など）
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $alarmTable (
            $columnAId INTEGER PRIMARY KEY,
            $columnHour INTEGER NOT NULL,
            $columnMin INTEGER NOT NULL,
            $columnAudioNum INTEGER NOT NULL,
            $columnValid INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $pointTable (
            $columnPId INTEGER PRIMARY KEY,
            $columnPoint INTEGER NOT NULL,
            $columnTime TEXT DEFAULT CURRENT_DATE
          )
          ''');
  }

  // 登録処理
  static Future<int> insert(String tableName, Map<String, dynamic> row) async {
    if((tableName == alarmTable) || (tableName == pointTable)){
      throw Exception("table name is not valid!");
    }
    Database? db = await instance.database;
    return await db!.insert(tableName, row, conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  // 照会処理
  static Future<List<Map<String, dynamic>>> query(String query) async {
    Database? db = await instance.database;
    return await db!.rawQuery(query);
  }

  // レコード数を確認
  static Future<int?> queryCount(String query) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery(query));
  }

  //　更新処理
  static Future<int> update(String tableName, Map<String, dynamic> row) async {
    if((tableName == alarmTable) || (tableName == pointTable)){
      throw Exception("table name is not valid!");
    }
    Database? db = await instance.database;
    String columnId;
    int id;
    if(tableName == alarmTable){
      columnId = columnAId;
      id = row[columnAId];
    }else{
      columnId = columnPId;
      id = row[columnPId];
    }
    return await db!.update(tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  //　削除処理
  static Future<int> delete(String tableName, int id) async {
    if((tableName == alarmTable) || (tableName == pointTable)){
      throw Exception("table name is not valid!");
    }
    Database? db = await instance.database;
    String columnId;
    if(tableName == alarmTable){
      columnId = columnAId;
    }else{
      columnId = columnPId;
    }
    return await db!.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  static Future<int> setPointDB(int point) async{ //pointをsqliteに保存
    Database? db = await DatabaseHelper.instance.database;
    return await db!.rawInsert("INSERT INTO $pointTable(point) VALUES($point)");
  }

  static Future<List<int>> getPointDB() async{ //pointをsqliteから取得
    int pp = -1; //前のポイント
    int count = 0; //何連続でポイントが上昇しているか

    //var data = await DatabaseHelper.query("SELECT * FROM $pointTable");
    var data = await DatabaseHelper.query(
        '''SELECT * FROM $pointTable 
           WHERE $columnPId IN(SELECT MAX($columnPId) 
           FROM $pointTable GROUP BY $columnTime)''');

    for(var e in data){
      if(pp - e['point'] >= 10){
        count += 1;
      }else{
        count = 0;
      }
      pp = e['point'];
    }

    //DEBUG
    print(data);
    print("point is $pp /count is $count");

    return [pp, count];
  }

  static Future<void> setAlarmDB(AlarmFactory af) async{ //alarmをsqliteに保存
    for (var e in af.alarms) {
      DatabaseHelper.insert(DatabaseHelper.alarmTable,
          {
            DatabaseHelper.columnAId : e.id,
            DatabaseHelper.columnHour  : e.hour,
            DatabaseHelper.columnMin  : e.min,
            DatabaseHelper.columnAudioNum  : e.audioNum,
            DatabaseHelper.columnValid  : e.isValid,
          });
    }
  }

  static Future<void> getAlarmDB(AlarmFactory af) async{ //alarmをsqliteから取得
    var data = await DatabaseHelper.query("SELECT * FROM alarm_table");
    for(var e in data){
      af.alarms.add(MyAlarm(int.parse(e['a_id']), int.parse(e['hour']), int.parse(e['min']), int.parse(e['audio_num']), int.parse(e['validity'])));
    }
    af.sortAlarm();

    //DEBUG
    print(data);

  }
}
