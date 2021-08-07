import 'package:easy_mall_shop/constants/my_icons.dart';
import 'package:easy_mall_shop/provider/wishlist_provider.dart';
import 'package:easy_mall_shop/services/show_dialog.dart';
import 'package:easy_mall_shop/widget/wishlist_empty.dart';
import 'package:easy_mall_shop/widget/wishlist_full.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/WishlistScreen';
  @override
  Widget build(BuildContext context) {
    ShowDialog globalDialog = ShowDialog();
    final wishlistProvider = Provider.of<WishListProvider>(context);
    return wishlistProvider.getWishlistItems.isEmpty
        ? Scaffold(body: WishlistEmpty())
        : Scaffold(
            appBar: AppBar(
              title: Text('Wishlist (${wishlistProvider.getWishlistItems.length})'),
              actions: [
                IconButton(
                  onPressed: () {
                    globalDialog.showDialogg(
                        "Clear wishlist!",
                        "Your wishlist will be cleared!",
                            () => wishlistProvider.clearWishlist(), context
                    );
                    // cartProvider.clearCart();
                  },
                  icon: Icon(MyAppIcons.trash),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: wishlistProvider.getWishlistItems.length,
              itemBuilder: (BuildContext ctx, int index) {
                return ChangeNotifierProvider.value(
                  value: wishlistProvider.getWishlistItems.values.toList()[index],
                    child: WishlistFull(
                      productId: wishlistProvider.getWishlistItems.keys.toList()[index],
                    ),
                );
              },
            ),
          );
  }
}
