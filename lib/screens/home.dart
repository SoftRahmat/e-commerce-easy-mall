import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_mall_shop/constants/colors.dart';
import 'package:easy_mall_shop/inner_screens/brands_navigation_rail.dart';
import 'package:easy_mall_shop/provider/products.dart';
import 'package:easy_mall_shop/screens/feeds.dart';
import 'package:easy_mall_shop/widget/PopularProduct.dart';
import 'package:easy_mall_shop/widget/backlayer.dart';
import 'package:easy_mall_shop/widget/category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _carouselImage = [
    "assets/images/caro1.jpg",
    "assets/images/caro5.jpg",
    "assets/images/caro6.jpg",
    "assets/images/caro7.jpg",
  ];
  List _PopularBrandsImages = [
    "assets/images/addidas.jpg",
    "assets/images/apple.webp",
    "assets/images/dell.jpg",
    "assets/images/hp.jpg",
    "assets/images/huawei.png",
    "assets/images/nike.jpg",
    "assets/images/samsung.jpg"
  ];
  ScrollController _scrollController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid;
  String _userImageUrl;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    getData();
  }

  void getData() async {
    User user = _auth.currentUser;
    _uid = user.uid;
    print('user.displayName ${user.displayName}');
    print('user.photoURL ${user.photoURL}');
    final DocumentSnapshot userDoc = user.isAnonymous
        ? null
        : await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        _userImageUrl = userDoc.get('imageUrl');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    productData.fetchProducts();
    final popularItem = productData.popularProducts;
    return Scaffold(
      body: Center(
        child: BackdropScaffold(
          frontLayerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          headerHeight: MediaQuery.of(context).size.height * 0.25,
          appBar: BackdropAppBar(
            title: Text("Home"),
            leading: BackdropToggleButton(
              icon: AnimatedIcons.home_menu,
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorsConsts.starterColor, ColorsConsts.endColor],
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {},
                icon: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundImage: NetworkImage( _userImageUrl??
                        "https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg"),
                  ),
                ),
                iconSize: 15,
                padding: EdgeInsets.all(10),
              ),
            ],
          ),
          backLayer: BackLayerMenu(),
          frontLayer: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 240.0,
                  width: double.infinity,
                  child: Carousel(
                    boxFit: BoxFit.fill,
                    autoplay: true,
                    animationCurve: Curves.fastOutSlowIn,
                    animationDuration: Duration(milliseconds: 1000),
                    dotSize: 6.0,
                    dotIncreasedColor: Colors.deepOrangeAccent,
                    dotBgColor: Colors.black.withOpacity(0.2),
                    dotPosition: DotPosition.bottomCenter,
                    showIndicator: true,
                    indicatorBgPadding: 5.0,
                    images: [
                      ExactAssetImage(_carouselImage[0]),
                      ExactAssetImage(_carouselImage[1]),
                      ExactAssetImage(_carouselImage[2]),
                      ExactAssetImage(_carouselImage[3]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Categories",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 180,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (BuildContext ctx, int index) {
                        return CategoryWidget(
                          index: index,
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Popular Brands",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      Spacer(),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            BrandNavigationRailScreen.routeName,
                            arguments: {
                              7,
                            },
                          );
                        },
                        child: Text(
                          "View all....",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 210,
                  width: MediaQuery.of(context).size.width * 0.99,
                  child: Swiper(
                    itemCount: _PopularBrandsImages.length,
                    viewportFraction: 0.8,
                    scale: 0.9,
                    onTap: (index) {
                      Navigator.of(context).pushNamed(
                        BrandNavigationRailScreen.routeName,
                        arguments: {
                          index,
                        },
                      );
                    },
                    autoplay: true,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.blueGrey,
                            child: Image.asset(
                              _PopularBrandsImages[index],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Popular Products",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      Spacer(),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Feeds.routeName, arguments: "popular");
                        },
                        child: Text(
                          "View all....",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 285,
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  child: ListView.builder(
                      itemCount: popularItem.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext ctx, int index) {
                        return ChangeNotifierProvider.value(
                          value: popularItem[index],
                          child: PopularProduct(
                            // imageUrl: popularItem[index].imageUrl,
                            // title: popularItem[index].title,
                            // description: popularItem[index].description,
                            // price: popularItem[index].price,
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
