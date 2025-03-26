import 'dart:io';

import 'package:mezamashi/AlarmFactory.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'MyAlarm.dart';

class DatabaseHelper{

  /// DB名
  static const _databaseName = "MyDatabase.db";
  /// スキーマのバージョン指定
  static const _databaseVersion = 1;

  /// テーブル名
  static const alarmTable = 'alarm_table';
  /// テーブル名
  static const pointTable = 'point_table';

  /// カラム名：ID
  static const columnAId = 'a_id';
  /// カラム名:hour
  static const columnHour = 'hour';
  /// カラム名:min
  static const columnMin = 'min';
  /// カラム名:audio_num
  static const columnAudioNum = 'audio_num';
  /// カラム名:validity
  static const columnValid = 'validity';

  /// カラム名：ID
  static const columnPId = 'p_id';
  /// カラム名：point
  static const columnPoint = 'point';
  ///カラム名：created_at (タイムスタンプ)
  static const columnTime = 'created_at';

  // DatabaseHelper クラスを定義
  DatabaseHelper._privateConstructor();
  /// インストールはシングルトンとする。
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  // databaseメソッド定義<br>
  // 非同期処理
  Future<Database?> get database async {
    // _databaseがNULLか判定
    // NULLの場合、_initDatabaseを呼び出しデータベースの初期化し、_databaseに返す
    // NULLでない場合、そのまま_database変数を返す。
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // データベース接続
  _initDatabase() async {
    // アプリケーションのドキュメントディレクトリのパス
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // 取得パスを基に、データベースのパスを生成
    String path = join(documentsDirectory.path, _databaseName);
    // データベース接続
    return await openDatabase(path,
        version: _databaseVersion,
        // テーブル作成メソッドの呼び出し
        onCreate: _onCreate);
  }

  /// テーブル作成を行う。<br>
  ///
  /// スキーマーのバージョンはテーブル変更時にバージョンを上げる（テーブル・カラム追加・変更・削除など）<br>
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

  /// DBへの登録処理を行う。
  ///
  /// テーブル名[tableName]がであるテーブルに辞書型[row]を登録する。<br>
  /// 競合が発生した場合は置き換える。
  static Future<int> insert(String tableName, Map<String, dynamic> row) async {
    if((tableName == alarmTable) || (tableName == pointTable)){
      Database? db = await instance.database;
      return await db!.insert(tableName, row, conflictAlgorithm: ConflictAlgorithm.replace,);
    }else{
      throw Exception("table name is not valid!");
    }
  }

  /// 照会処理を行う。
  ///
  /// SQLiteのクエリである、引数[query]をもとにDBを照会した結果を返す。
  static Future<List<Map<String, dynamic>>> query(String query) async {
    Database? db = await instance.database;
    return await db!.rawQuery(query);
  }

  /// レコード数を確認する。
  ///
  /// SQLiteのクエリである、引数[query]をもとにカウントしたレコード数を返す。
  static Future<int?> queryCount(String query) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery(query));
  }

  /// 更新処理を行う。
  ///
  /// テーブル名が[tableName]であるテーブルに辞書型[row]で対象のレコードを上書きする。
  static Future<int> update(String tableName, Map<String, dynamic> row) async {
    if((tableName == alarmTable) || (tableName == pointTable)){
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
      return await db!.update(tableName, row, where: '$columnId = ?', whereArgs: [id], conflictAlgorithm: ConflictAlgorithm.replace);
    }else{
      throw Exception("table name is not valid!");
    }
  }

  ///　削除処理を行う。
  ///
  /// テーブル名が[tableName]であるテーブルの列[id]を削除する。
  static Future<int> delete(String tableName, int id) async {
    if((tableName == alarmTable) || (tableName == pointTable)){
      Database? db = await instance.database;
      String columnId;
      if(tableName == alarmTable){
        columnId = columnAId;
      }else{
        columnId = columnPId;
      }
      return await db!.delete(tableName, where: '$columnId = $id');
    }else{
      throw Exception("table name is not valid!");
    }

  }

  /// ポイント[point]を[pointTable]に保存する。
  static Future<int> setPointDB(int point) async{
    Database? db = await DatabaseHelper.instance.database;
    return await db!.rawInsert("INSERT INTO $pointTable($columnPoint) VALUES($point)");
  }

  /// ポイントを[pointTable]から取得する。
  ///
  /// 返り値はサイズ2のリストであり、それぞれの要素は以下の通り。
  /// 1. ポイント数
  /// 2. 直近に連続でポイントが上昇している回数
  static Future<List<int>> getPointDB() async{
    int pp = 0; //前のポイント
    int count = 0; //何連続でポイントが上昇しているか

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

    return [pp, count];
  }

  /// alarmを[alarmTable]に登録する。
  ///
  /// [AlarmFactory]に保存されているすべてのalarmを[alarmTable]に登録する。
  static Future<void> setAlarmDB(AlarmFactory af) async{
    for (var e in af.alarms) {
      DatabaseHelper.insert(alarmTable,
          {
            DatabaseHelper.columnAId : e.id,
            DatabaseHelper.columnHour  : e.hour,
            DatabaseHelper.columnMin  : e.min,
            DatabaseHelper.columnAudioNum  : e.audioNum,
            DatabaseHelper.columnValid  : e.isValid,
          });
    }
  }

  /// alarmを[alarmTable]から取得する。
  ///
  /// [alarmTable]にあるすべてのalarmを取得し、[AlarmFactory]にソートされた状態で保存する。<br>
  static Future<void> getAlarmDB(AlarmFactory af) async{
    var data = await DatabaseHelper.query("SELECT * FROM alarm_table");
    for(var e in data){
      af.alarms.add(MyAlarm(e['a_id'], e['hour'], e['min'], e['audio_num'], e['validity']));
    }
    af.sortAlarm();
  }
}
