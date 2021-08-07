import 'package:badges/badges.dart';
import 'package:easy_mall_shop/constants/colors.dart';
import 'package:easy_mall_shop/constants/my_icons.dart';
import 'package:easy_mall_shop/models/product.dart';
import 'package:easy_mall_shop/provider/cart_provider.dart';
import 'package:easy_mall_shop/provider/products.dart';
import 'package:easy_mall_shop/provider/wishlist_provider.dart';
import 'package:easy_mall_shop/screens/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:easy_mall_shop/widget/feeds_product.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:ffi';

import 'package:provider/provider.dart';

import 'cart.dart';

class Feeds extends StatefulWidget {
  static const routeName = '/Feeds';

  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  Future<void> _getProductsOnRefresh() async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context).settings.arguments as String;
    final productsProvider = Provider.of<Products>(context);
    List<Product> productsList = productsProvider.products;
    if (popular == "popular") {
      productsList = productsProvider.popularProducts;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Feeds'),
        actions: [
          Consumer<WishListProvider>(
            builder: (_, wishlist, ch) => Badge(
              badgeColor: ColorsConsts.cartBadgeColor,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 5, end: 7),
              badgeContent: Text(
                wishlist.getWishlistItems.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: Icon(
                  MyAppIcons.wishList,
                  color: ColorsConsts.favColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(WishlistScreen.routeName);
                },
              ),
            ),
          ),
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              badgeColor: ColorsConsts.cartBadgeColor,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 5, end: 7),
              badgeContent: Text(
                cart.getCartItems.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: Icon(
                  MyAppIcons.cart,
                  color: ColorsConsts.cartColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(Cart.routeName);
                },
              ),
            ),
          ),
        ],
      ),
      // body: RefreshIndicator(
      //   onRefresh: _getProductsOnRefresh,
      //   child: StaggeredGridView.countBuilder(
      //     crossAxisCount: 6,
      //     itemCount: 8,
      //     itemBuilder: (context, index) {
      //        List.generate(
      //         productsList.length,
      //             (index) {
      //           return ChangeNotifierProvider.value(
      //             value: productsList[index],
      //             child: FeedProducts(),
      //           );
      //         },
      //       );
      //     },
      //     staggeredTileBuilder: (int index) =>
      //     new StaggeredTile.count(3, index.isEven ? 4 : 5),
      //     mainAxisSpacing: 8.0,
      //     crossAxisSpacing: 6.0,
      //   ),
      // ),
      body: RefreshIndicator(
        onRefresh: _getProductsOnRefresh,
        child: GridView.count(
          childAspectRatio: 240 / 470,
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
      ),
    );
  }
}
