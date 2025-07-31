import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  static Future<Database> init() async {
    final path = join(await getDatabasesPath(), 'app.db');
    print("INIT DB");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE transactions (
          code TEXT PRIMARY KEY,
          user_id INT,
          date TEXT,
          sell INTEGER,
          pay INTEGER,
          active INTEGER
        );
      ''');

        await db.execute('''
        CREATE TABLE transaction_items (
          code_id TEXT,
          ordinal INTEGER,
          product_id INTEGER,
          qty INTEGER
        );
      ''');
      },
    );
  }

  static Future<void> insertTransaction({
    required String code,
    required int userId,
    required String date,
    required int sell,
    required int pay,
    required List<Map<String, dynamic>> products,
  }) async {
    final dbClient = await db;

    await dbClient.insert('transactions', {'code': code, 'user_id': userId, 'date': date, 'sell': sell, 'pay': pay, 'active': 1});

    for (int i = 0; i < products.length; i++) {
      await dbClient.insert('transaction_items', {'code_id': code, 'ordinal': i + 1, 'product_id': products[i]['id'], 'qty': products[i]['cart']});
    }
  }

  static Future<List<Map<String, dynamic>>> getAllTransactions() async {
    final dbClient = await db;
    return await dbClient.query('transactions');
  }

  static Future<List<Map<String, dynamic>>> getItemTransaction(code) async {
    final dbClient = await db;
    return await dbClient.query('transaction_items', where: 'code_id = ?', whereArgs: [code]);
  }
  
  static Future<void> deleteTransactions(code) async {
    final dbClient = await db;
    await dbClient.delete(
        'transactions',
        where: 'code = ?',
        whereArgs: [code]
    );

    await dbClient.delete(
        'transaction_items',
        where: 'code_id = ?',
        whereArgs: [code]
    );
  }
}
