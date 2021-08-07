import 'package:easy_mall_shop/models/product.dart';
import 'package:easy_mall_shop/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:easy_mall_shop/widget/feeds_product.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:ffi';

import 'package:provider/provider.dart';

class CategoryFeeds extends StatelessWidget {
  static const routeName = '/CategoryFeeds';
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    final categoryName = ModalRoute.of(context).settings.arguments as String;
    print(categoryName);
    final productsList = productsProvider.findByCategory(categoryName);
    return Scaffold(
      // body: StaggeredGridView.countBuilder(
      //   crossAxisCount: 6,
      //   itemCount: 8,
      //   itemBuilder: (BuildContext context, int index) => FeedProducts(),
      //   staggeredTileBuilder: (int index) =>
      //   new StaggeredTile.count(3, index.isEven ? 4 : 5),
      //   mainAxisSpacing: 8.0,
      //   crossAxisSpacing: 6.0,
      // ),
      body: productsList.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Feather.database,
                    size: 80,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'No products related to this category',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
              ),
            )
          : GridView.count(
              childAspectRatio: 240 / 475,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              crossAxisCount: 2,
              children: List.generate(
                productsList.length,
                (index) {
                  return ChangeNotifierProvider.value(
                    value: productsList[index],
                    child: FeedProducts(),
                  );
                },
              ),
            ),
    );
  }
}
