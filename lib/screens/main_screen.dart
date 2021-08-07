import 'package:easy_mall_shop/inner_screens/upload_product_form.dart';
import 'package:easy_mall_shop/screens/bottom_bar.dart';
import 'package:easy_mall_shop/screens/landing_page.dart';
import 'package:flutter/material.dart';

class MainScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [BottomBarScreen(), UploadProductForm()],
    );
  }
}
