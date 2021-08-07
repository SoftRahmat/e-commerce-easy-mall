import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_mall_shop/constants/colors.dart';
import 'package:easy_mall_shop/constants/my_icons.dart';
import 'package:easy_mall_shop/provider/cart_provider.dart';
import 'package:easy_mall_shop/services/payment.dart';
import 'package:easy_mall_shop/services/show_dialog.dart';
import 'package:easy_mall_shop/widget/cart_empty.dart';
import 'package:easy_mall_shop/widget/cart_full.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:ffi';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Cart extends StatefulWidget {
  static const routeName = '/Cart';

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
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

  ShowDialog globalDialog = ShowDialog();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: CartEmpty(),
          )
        : Scaffold(
            bottomSheet: checkOutSection(context, cartProvider.totalAmount),
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text("Cart (${cartProvider.getCartItems.length})"),
              actions: [
                IconButton(
                  onPressed: () {
                    globalDialog.showDialogg(
                        "Clear cart!",
                        "Your cart will be cleared!",
                        () => cartProvider.clearCart(),
                        context);
                    // cartProvider.clearCart();
                  },
                  icon: Icon(MyAppIcons.trash),
                ),
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(bottom: 60.0),
              child: ListView.builder(
                itemCount: cartProvider.getCartItems.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return ChangeNotifierProvider.value(
                    value: cartProvider.getCartItems.values.toList()[index],
                    child: CartFull(
                      productId: cartProvider.getCartItems.keys.toList()[index],
                      // id: cartProvider.getCartItems.values.toList()[index].id,
                      // title: cartProvider.getCartItems.values.toList()[index].title,
                      // productId: cartProvider.getCartItems.keys.toList()[index],
                      // price: cartProvider.getCartItems.values.toList()[index].price,
                      // imageUrl: cartProvider.getCartItems.values.toList()[index].imageUrl,
                      // quatity: cartProvider.getCartItems.values.toList()[index].quantity,
                    ),
                  );
                },
              ),
            ),
          );
  }

  Widget checkOutSection(BuildContext ctx, double subtotal) {
    final cartProvider = Provider.of<CartProvider>(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uuid = Uuid();
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      ColorsConsts.gradiendLStart,
                      ColorsConsts.gradiendLEnd,
                    ],
                    stops: [
                      0.0,
                      0.7,
                    ],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      double amountInCents = subtotal * 1000;
                      int intengerAmount = (amountInCents / 10).ceil();
                      await payWithCard(amount: intengerAmount);
                      if (response.success == true) {
                        User user = _auth.currentUser;
                        final _uid = user.uid;
                        cartProvider.getCartItems
                            .forEach((key, orderValue) async {
                          final orderId = uuid.v4();
                          try {
                            await FirebaseFirestore.instance
                                .collection('order')
                                .doc(orderId)
                                .set({
                              'orderId': orderId,
                              'userId': _uid,
                              'productId': orderValue.productId,
                              'title': orderValue.title,
                              'price': orderValue.price * orderValue.quantity,
                              'imageUrl': orderValue.imageUrl,
                              'quantity': orderValue.quantity,
                              'orderDate': Timestamp.now(),
                            });
                          } catch (err) {
                            print('error occured $err');
                          }
                        });
                      } else {
                        globalDialog.authErrorDialog(
                            'Please enter your correct information', context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Checkout",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(ctx).textSelectionColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Text(
              "Total: ",
              // textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(ctx).textSelectionColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "US ${subtotal.toStringAsFixed(3)} ",
              // textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
