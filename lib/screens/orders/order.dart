import 'package:easy_mall_shop/constants/colors.dart';
import 'package:easy_mall_shop/constants/my_icons.dart';
import 'package:easy_mall_shop/provider/cart_provider.dart';
import 'package:easy_mall_shop/provider/order_provider.dart';
import 'package:easy_mall_shop/screens/orders/order_full.dart';
import 'package:easy_mall_shop/services/payment.dart';
import 'package:easy_mall_shop/services/show_dialog.dart';
import 'package:easy_mall_shop/screens/orders/order_empty.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:ffi';

import 'package:provider/provider.dart';

class Order extends StatefulWidget {
  static const routeName = '/Order';

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  var response;
  Future<void> payWithCard({int amount}) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    response = await StripeService.payWithNewCard(
        currency: 'USD', amount: amount.toString());
    await dialog.hide();
    print('response : ${response.success}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response.message,
          style: TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        duration:
            Duration(milliseconds: response.success == true ? 1200 : 3000),
        width: 280.0, // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0, vertical: 5, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ShowDialog globalDialog = ShowDialog();
    final orderProvider = Provider.of<OrdersProvider>(context);
    // final cartProvider = Provider.of<CartProvider>(context);
    return FutureBuilder(
        future: orderProvider.fetchOrders(),
        builder: (context, snapshot) {
          return orderProvider.getOrders.isEmpty
              ? Scaffold(
                  body: OrderEmpty(),
                )
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).backgroundColor,
                    title: Text("Order(${orderProvider.getOrders.length})"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          // globalDialog.showDialogg(
                          //     "Clear cart!",
                          //     "Your cart will be cleared!",
                          //     () => cartProvider.clearCart(),
                          //     context);
                        },
                        icon: Icon(MyAppIcons.trash),
                      ),
                    ],
                  ),
                  body: Container(
                    margin: EdgeInsets.only(bottom: 60.0),
                    child: ListView.builder(
                      itemCount: orderProvider.getOrders.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return ChangeNotifierProvider.value(
                            value: orderProvider.getOrders[index],
                            child: OrderFull());
                      },
                    ),
                  ),
                );
        });
  }
}
