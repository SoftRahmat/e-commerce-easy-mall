import 'package:flutter/cupertino.dart';

class CartAttr with ChangeNotifier{
  final String id;
  final String title;
  final String productId;
  final int quantity;
  final double price;
  final String imageUrl;

  CartAttr({this.id, this.title, @required this.productId, this.quantity, this.price, this.imageUrl});

}
