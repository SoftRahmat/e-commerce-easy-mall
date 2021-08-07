import 'package:flutter/cupertino.dart';

class WishListAttr with ChangeNotifier{
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  WishListAttr({this.id, this.title, this.price, this.imageUrl});

}
