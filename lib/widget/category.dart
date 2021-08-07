import 'package:easy_mall_shop/inner_screens/category_feeds.dart';
import 'package:easy_mall_shop/screens/feeds.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  CategoryWidget({Key key, this.index}) : super(key: key);
  final int index;

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  List<Map<String, Object>> categories = [
    {
      "categoryName": "Phones",
      "categoryImagePath": "assets/images/cataf2.png",
    },
    {
      "categoryName": "Clothes",
      "categoryImagePath": "assets/images/catclothes.jpg",
    },
    {
      "categoryName": "Laptop",
      "categoryImagePath": "assets/images/catlaptop.jpg",
    },
    {
      "categoryName": "Matches",
      "categoryImagePath": "assets/images/catmatches.jpg",
    },
    {
      "categoryName": "Shoes",
      "categoryImagePath": "assets/images/catshoes.jpg",
    },
    {
      "categoryName": "Furniture",
      "categoryImagePath": "assets/images/catfurniture.jpg",
    },
    {
      "categoryName": "Beauty",
      "categoryImagePath": "assets/images/catbeauty.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(CategoryFeeds.routeName,
                arguments: "${categories[widget.index]['categoryName']}");
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(
                  categories[widget.index]["categoryImagePath"],
                ),
                fit: BoxFit.cover,
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 150,
            height: 150,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Theme.of(context).backgroundColor,
            child: Text(
              categories[widget.index]["categoryName"],
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Theme.of(context).textSelectionColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
