import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_mall_shop/constants/colors.dart';
import 'package:easy_mall_shop/inner_screens/product_details.dart';
import 'package:easy_mall_shop/models/cart_attr.dart';
import 'package:easy_mall_shop/models/order_attr.dart';
import 'package:easy_mall_shop/provider/cart_provider.dart';
import 'package:easy_mall_shop/provider/theme_provider.dart';
import 'package:easy_mall_shop/services/show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'dart:ffi';

class OrderFull extends StatefulWidget {
  @override
  _OrderFullState createState() => _OrderFullState();
}

class _OrderFullState extends State<OrderFull> {
  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    ShowDialog globalDialog = ShowDialog();
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final orderAttrProvider = Provider.of<OrdersAttr>(context);
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetails.routeName,
          arguments: orderAttrProvider.productId),
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        child: Row(
          children: [
            Container(
              width: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(orderAttrProvider.imageUrl),
                  // fit: BoxFit.fill,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            orderAttrProvider.title,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32.0),
                            onTap: () {
                              globalDialog.showDialogg(
                                  "Remove Order!", "Order will be deleted",
                                  () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await FirebaseFirestore.instance
                                    .collection('order')
                                    .doc(orderAttrProvider.orderId)
                                    .delete();
                              }, context);
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : Icon(
                                      Entypo.cross,
                                      size: 22,
                                      color: Colors.red,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Price: "),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${orderAttrProvider.price}\$",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Quantity: "),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${orderAttrProvider.quantity}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(child: Text("Order ID: ")),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Text(
                            "${orderAttrProvider.orderId}",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
