
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_card_provide/db_helper.dart';
import 'package:flutter_shopping_card_provide/product_list_screen.dart';
import 'package:provider/provider.dart';

import 'cart_model.dart';
import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  DbHelper? dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child){
                  return  Text(
                    value.getCounter().toString(),
                    style: TextStyle(color: Colors.white),
                  );
                },

              ),
              animationDuration: Duration(microseconds: 300),
              child: Icon(Icons.shopping_bag_outlined),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: cart.getData() ,
              builder: (context, AsyncSnapshot<List<Cart>> snapshot){
              if(snapshot.hasData){
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Image(
                                    height: 100,
                                    width: 100,
                                    image:
                                    NetworkImage(snapshot.data![index].image.toString()),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshot.data![index].productName.toString(),
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                            ),
                                            InkWell(
                                                onTap: (){
                                                dbHelper!.delete(snapshot.data![index].id!);
                                                cart.removeCounter();
                                                cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                },
                                                child: Icon(Icons.delete)),
                                          ],
                                        ),
                                        Text(
                                          snapshot.data![index].productName.toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          snapshot.data![index].unitTag.toString() +
                                              " " +
                                              r"$" +
                                              snapshot.data![index].productPrice.toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {

                                            },
                                            child: Container(
                                              height: 36,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(5),
                                                  color: Colors.green),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InkWell(
                                                        onTap: (){
                                                          int quantity = snapshot.data![index].quantity!;
                                                          int price = snapshot.data![index].initialPrice!;
                                                          quantity--;
                                                          int? newPrice = price * quantity;

                                                          if(quantity >= 1){
                                                            dbHelper!.updateQuantity(
                                                                Cart(
                                                                    id: snapshot.data![index].id,
                                                                    productId: snapshot.data![index].id.toString(),
                                                                    productName: snapshot.data![index].productName.toString(),
                                                                    initialPrice: snapshot.data![index].initialPrice,
                                                                    productPrice: newPrice,
                                                                    quantity: quantity,
                                                                    unitTag: snapshot.data![index].unitTag.toString(),
                                                                    image: snapshot.data![index].image.toString())
                                                            ).then((value) {
                                                              newPrice = 0;
                                                              quantity = 0;
                                                              cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                              print("update successfull");
                                                            }).onError((error, stackTrace) {
                                                              print("update Error : ${error.toString()}");
                                                            });
                                                          }

                                                        },
                                                        child: Icon(Icons.remove, color: Colors.white,)),
                                                    Text(snapshot.data![index].quantity.toString(), style: TextStyle(color: Colors.white),),

                                                    InkWell(
                                                        onTap: (){
                                                          int quantity = snapshot.data![index].quantity!;
                                                          int price = snapshot.data![index].initialPrice!;
                                                          quantity++;
                                                          int? newPrice = price * quantity;

                                                          dbHelper!.updateQuantity(
                                                            Cart(
                                                                id: snapshot.data![index].id,
                                                                productId: snapshot.data![index].id.toString(),
                                                                productName: snapshot.data![index].productName.toString(),
                                                                initialPrice: snapshot.data![index].initialPrice,
                                                                productPrice: newPrice,
                                                                quantity: quantity,
                                                                unitTag: snapshot.data![index].unitTag.toString(),
                                                                image: snapshot.data![index].image.toString())
                                                          ).then((value) {
                                                            newPrice = 0;
                                                            quantity = 0;
                                                            cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                            print("update successfull");
                                                          }).onError((error, stackTrace) {
                                                            print("update Error : ${error.toString()}");
                                                          });
                                                        },
                                                        child: Icon(Icons.add, color: Colors.white,)),
                                                  ],
                                                    ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }else{
                print("data not found");
              }
              return Text('');
              }),

          Consumer<CartProvider>(builder: (context, value, child){
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == '0.00' ? false : true ,
              child: Column(
                children: [
                  ResuableWidget(title: "Sub Total", value: r'$'+ value.getTotalPrice().toStringAsFixed(2))
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}

class ResuableWidget extends StatelessWidget {
  final String title, value;
  ResuableWidget({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(title, style:  Theme.of(context).textTheme.subtitle2,),
          Text(value.toString(), style:  Theme.of(context).textTheme.subtitle2,)
        ],
      ),
    );
  }
}
