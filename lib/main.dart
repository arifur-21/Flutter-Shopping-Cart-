
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_card_provide/cart_provider.dart';
import 'package:flutter_shopping_card_provide/product_list_screen.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ProductListScreen(),
        );
      },),
    );
  }
}
