
import 'package:flutter_shopping_card_provide/cart_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DbHelper{

  static Database? _db;

  Future<Database?> get db async{
    if(_db != null){
      return _db!;
    }
    _db = await initDb();

  }

  initDb() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart_db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate,);
    return db;
  }

  _onCreate(Database db, int version)async{
    await  db.execute(
    'CREATE TABLE cart (id INTEGER PRIMARY KEY, productId VARCHAR UNIQUE, productName TEXT, initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, unitTag TEXT, image TEXT)');
  }

  Future<Cart> insert(Cart cartModel) async{
    var dbClient = await db;
    await dbClient!.insert("cart", cartModel.toMap());
    return cartModel;
  }

  Future<List<Cart>> getCartList() async{
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('cart');
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }


  Future<int> delete(int id)async{
    var dbClient = await db;
    return await dbClient!.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<int> updateQuantity(Cart cart)async{
    var dbClient = await db;
    return await dbClient!.update(
        'cart',
       cart.toMap(),
        where: 'id = ?',
        whereArgs: [cart.id]
    );
  }

}