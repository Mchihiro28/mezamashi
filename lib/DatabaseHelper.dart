import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{

  static final _databaseName = "MyDatabase.db"; // DB名
  static final _databaseVersion = 1; // スキーマのバージョン指定

  static const table = 'my_table'; // テーブル名

  static const columnId = '_id'; // カラム名：ID
  static const columnAlarmId = 'alarm_id'; // カラム名:alarm_id
  static const columnHour = 'hour'; // カラム名:hour
  static const columnMin = 'min'; // カラム名:min
  static const columnAudioNum = 'audio_num'; // カラム名:audio_num
  static const columnValid = 'validity'; // カラム名:validity
  static const columnPoint = 'point'; // カラム名：point

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
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnAlarmId INTEGER NOT NULL,
            $columnHour INTEGER NOT NULL,
            $columnMin INTEGER NOT NULL,
            $columnAudioNum INTEGER NOT NULL,
            $columnValid INTEGER NOT NULL,
            $columnPoint INTEGER NOT NULL.
          )
          ''');
  }

}