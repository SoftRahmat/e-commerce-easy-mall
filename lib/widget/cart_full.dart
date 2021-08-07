import 'package:easy_mall_shop/constants/colors.dart';
import 'package:easy_mall_shop/inner_screens/product_details.dart';
import 'package:easy_mall_shop/models/cart_attr.dart';
import 'package:easy_mall_shop/provider/cart_provider.dart';
import 'package:easy_mall_shop/provider/theme_provider.dart';
import 'package:easy_mall_shop/services/show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'dart:ffi';

class CartFull extends StatefulWidget {
  final String productId;

  const CartFull({this.productId});

  @override
  _CartFullState createState() => _CartFullState();
}

class _CartFullState extends State<CartFull> {

  @override
  Widget build(BuildContext context) {
    ShowDialog globalDialog = ShowDialog();
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final cartAttr = Provider.of<CartAttr>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    double subTotal = cartAttr.price * cartAttr.quantity;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetails.routeName,
          arguments: widget.productId),
      child: Container(
        height: 135,
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
                  image: NetworkImage(cartAttr.imageUrl),
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
                            cartAttr.title,
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
                                "Remove Item!",
                                "Product will be remove from the cart",
                                () => cartProvider.removeItem(widget.productId), context,
                              );
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              child: Icon(
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
                          "${cartAttr.price}\$",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Sub Total: "),
                        SizedBox(
                          width: 5,
                        ),
                        FittedBox(
                          child: Text(
                            "${subTotal.toStringAsFixed(2)} \$",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: themeChange.darkTheme
                                    ? Colors.brown.shade900
                                    : Theme.of(context).accentColor),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Ships Free",
                          style: TextStyle(
                              color: themeChange.darkTheme
                                  ? Colors.brown.shade900
                                  : Theme.of(context).accentColor),
                        ),
                        Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32.0),
                            onTap: cartAttr.quantity < 2
                                ? null
                                : () {
                                    cartProvider.reduceCartItems(
                                      widget.productId,
                                    );
                                  },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Entypo.minus,
                                  size: 22,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 12,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.12,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
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
                            child: Text(
                              cartAttr.quantity.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32.0),
                            onTap: () {
                              cartProvider.addProductToCart(
                                  widget.productId,
                                  cartAttr.price,
                                  cartAttr.title,
                                  cartAttr.imageUrl);
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  Entypo.plus,
                                  size: 22,
                                  color: cartAttr.quantity < 2
                                      ? Colors.green
                                      : Colors.purple,
                                ),
                              ),
                            ),
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
