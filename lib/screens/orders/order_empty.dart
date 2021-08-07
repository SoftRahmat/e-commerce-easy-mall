import 'package:easy_mall_shop/constants/colors.dart';
import 'package:easy_mall_shop/provider/theme_provider.dart';
import 'package:easy_mall_shop/screens/feeds.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ffi';

class OrderEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 80),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                'https://image.flaticon.com/icons/png/128/3759/3759041.png',
              ),
            ),
          ),
        ),
        Text(
          "You didn\'t order yet",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 35,
        ),
        Text(
          "Looks like you didn\'t \n add anything to your order yet",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: themeChange.darkTheme
                ? Theme.of(context).disabledColor
                : ColorsConsts.subTitle,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.06,
          child: RaisedButton(
            onPressed: () => {
              Navigator.of(context).pushNamed(Feeds.routeName),
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.red),
            ),
            color: Colors.red,
            child: Text(
              "Order now".toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
