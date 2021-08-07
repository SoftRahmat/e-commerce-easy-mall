import 'package:easy_mall_shop/models/wishlist_attr.dart';
import 'package:flutter/cupertino.dart';

class WishListProvider with ChangeNotifier {
  Map<String, WishListAttr> _wishlistItems = {};

  Map<String, WishListAttr> get getWishlistItems {
    return {..._wishlistItems};
  }

  void addAndRemoveWishlist(
      String productId, double price, String title, String imageUrl) {
    if (_wishlistItems.containsKey(productId)) {
      removeWishlistItem(productId);
    } else {
      _wishlistItems.putIfAbsent(
          productId,
          () => WishListAttr(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                imageUrl: imageUrl,
              ));
    }
    notifyListeners();
  }

  void removeWishlistItem(String productId) {
    _wishlistItems.remove(productId);
    notifyListeners();
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
