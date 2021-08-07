import 'package:easy_mall_shop/constants/colors.dart';
import 'package:easy_mall_shop/models/wishlist_attr.dart';
import 'package:easy_mall_shop/provider/wishlist_provider.dart';
import 'package:easy_mall_shop/services/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistFull extends StatefulWidget {
  final String productId;

  const WishlistFull({this.productId});
  @override
  _WishlistFullState createState() => _WishlistFullState();
}

class _WishlistFullState extends State<WishlistFull> {
  ShowDialog globalDialog = ShowDialog();

  @override
  Widget build(BuildContext context) {
    final wishListAttr = Provider.of<WishListAttr>(context);
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(right: 30.0, bottom: 10.0),
          child: Material(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(5.0),
            elevation: 3.0,
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: Image.network(
                          wishListAttr.imageUrl),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            wishListAttr.title,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "\$ ${wishListAttr.price}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        positionedRemove(widget.productId),
      ],
    );
  }

  Widget positionedRemove(String productId) {
    final wishlistProvider = Provider.of<WishListProvider>(context);
    return Positioned(
      top: 20,
      right: 15,
      child: Container(
        height: 30,
        width: 30,
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          padding: EdgeInsets.all(0.0),
          color: ColorsConsts.favColor,
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () =>{
          globalDialog.showDialogg(
          "Remove Wishlist!",
          "This product will be removed from your wishlist!",
          () => wishlistProvider.removeWishlistItem(productId), context,
          )},
        ),
      ),
    );
  }
}
