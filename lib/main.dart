import 'dart:ffi';

import 'package:easy_mall_shop/auth/forget_password.dart';
import 'package:easy_mall_shop/auth/login.dart';
import 'package:easy_mall_shop/auth/sign_up.dart';
import 'package:easy_mall_shop/inner_screens/brands_navigation_rail.dart';
import 'package:easy_mall_shop/inner_screens/category_feeds.dart';
import 'package:easy_mall_shop/provider/cart_provider.dart';
import 'package:easy_mall_shop/provider/order_provider.dart';
import 'package:easy_mall_shop/provider/products.dart';
import 'package:easy_mall_shop/provider/wishlist_provider.dart';
import 'package:easy_mall_shop/screens/cart.dart';
import 'package:easy_mall_shop/screens/feeds.dart';
import 'package:easy_mall_shop/screens/orders/order.dart';
import 'package:easy_mall_shop/screens/user_state.dart';
import 'package:easy_mall_shop/screens/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:easy_mall_shop/constants/theme_data.dart';
import 'package:easy_mall_shop/provider/theme_provider.dart';
import 'package:easy_mall_shop/screens/bottom_bar.dart';
import 'inner_screens/product_details.dart';
import 'inner_screens/upload_product_form.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text("Error occurred"),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) {
                return themeChangeProvider;
              },
            ),
            ChangeNotifierProvider(
              create: (_) => Products(),
            ),
            ChangeNotifierProvider(
              create: (_) => CartProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => WishListProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => OrdersProvider(),
            ),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeData, child) {
              return MaterialApp(
                title: 'Flutter Demo',
                theme: Styles.themeData(themeChangeProvider.darkTheme, context),
                home: UserState(),
                // home: BottomBarScreen(),
                routes: {
                  BrandNavigationRailScreen.routeName: (ctx) =>
                      BrandNavigationRailScreen(),
                  Cart.routeName: (ctx) => Cart(),
                  Feeds.routeName: (ctx) => Feeds(),
                  UploadProductForm.routeName: (ctx) => UploadProductForm(),
                  WishlistScreen.routeName: (ctx) => WishlistScreen(),
                  ProductDetails.routeName: (ctx) => ProductDetails(),
                  CategoryFeeds.routeName: (ctx) => CategoryFeeds(),
                  LoginScreen.routeName: (ctx) => LoginScreen(),
                  SignUpScreen.routeName: (ctx) => SignUpScreen(),
                  ForgetPassword.routeName: (ctx) => ForgetPassword(),
                  BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
                  Order.routeName: (ctx) => Order(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
