import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_mall_shop/constants/my_icons.dart';
import 'package:easy_mall_shop/provider/theme_provider.dart';
import 'package:easy_mall_shop/screens/cart.dart';
import 'package:easy_mall_shop/screens/orders/order.dart';
import 'package:easy_mall_shop/screens/wishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:easy_mall_shop/constants/colors.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';
import 'dart:ffi';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  ScrollController _scrollController;
  var top = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid;
  String _name;
  String _email;
  String _joinedAt;
  String _userImageUrl;
  int _phoneNumber;

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
        _name = userDoc.get('name');
        _email = user.email;
        _joinedAt = userDoc.get('joinedAt');
        _phoneNumber = userDoc.get('phoneNumber');
        _userImageUrl = userDoc.get('imageUrl');
      });
    }
    //print("name $_name");
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 4,
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  top = constraints.biggest.height;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            ColorsConsts.starterColor,
                            ColorsConsts.endColor,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      centerTitle: true,
                      title: Row(
                        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: top <= 110.0 ? 1.0 : 0,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Container(
                                  height: kToolbarHeight / 1.8,
                                  width: kToolbarHeight / 1.8,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(_userImageUrl ??
                                          'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  // 'top.toString()',
                                  _name == null ? 'Guest' : _name,
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      background: Image(
                        image: NetworkImage(_userImageUrl ??
                            'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                }),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: userTitle("User Bag"),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        onTap: () => Navigator.of(context)
                            .pushNamed(WishlistScreen.routeName),
                        child: ListTile(
                          title: Text("Wishlist"),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFFD32F2F),
                          ),
                          leading: Icon(
                            MyAppIcons.wishList,
                            color: Color(0xFFD32F2F),
                          ),
                        ),
                      ),
                    ),

                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        onTap: () {
                          Navigator.of(context).pushNamed(Cart.routeName);
                        },
                        child: ListTile(
                          title: Text("Cart"),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFFD32F2F),
                          ),
                          leading: Icon(
                            MyAppIcons.cart,
                            color: Color(0xFFD32F2F),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        onTap: () =>
                            Navigator.of(context).pushNamed(Order.routeName),
                        child: ListTile(
                          title: Text("My Orders"),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFFD32F2F),
                          ),
                          leading: Icon(
                            MyAppIcons.bag,
                            color: Color(0xFFD32F2F),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: userTitle("User Information"),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    userListTile("Email", _email ?? '', 0, context),
                    userListTile("Phone number", _phoneNumber.toString() ?? '',
                        1, context),
                    userListTile("Shipping address", "", 2, context),
                    userListTile("Joined date", _joinedAt ?? '', 3, context),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: userTitle("User settings"),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    ListTileSwitch(
                      value: themeChange.darkTheme,
                      leading: Icon(
                        Ionicons.md_moon,
                        color: Color(0xFF000000),
                      ),
                      onChanged: (value) {
                        setState(() {
                          themeChange.darkTheme = value;
                        });
                      },
                      visualDensity: VisualDensity.comfortable,
                      switchType: SwitchType.cupertino,
                      switchActiveColor: Color(0xFFEC407A),
                      title: Text('Dark theme'),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                title: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: Image.network(
                                        'https://image.flaticon.com/icons/png/128/1828/1828304.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Sign out"),
                                    )
                                  ],
                                ),
                                content: Text("Do you wanna sign out"),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await _auth.signOut().then(
                                            (value) => Navigator.pop(context),
                                          );
                                    },
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                          // Navigator.canPop(context)?Navigator.pop(context): null;
                        },
                        child: ListTile(
                          title: Text("Logout"),
                          leading: Icon(
                            Icons.exit_to_app_rounded,
                            color: Color(0xFFD50000),
                          ),
                          // trailing: IconButton(
                          //   icon: Icon(Icons.edit),
                          //   onPressed: () {},
                          // ),
                        ),
                      ),
                    ),
                    // userListTile("Logout", "", 4, context)
                  ],
                ),
              ),
            ],
          ),
          _buildFab()
        ],
      ),
    );
  }

  Widget _buildFab() {
    //starting fab position
    final double defaultTopMargin = 200.0 - 4.0;
    //pixels from top where scaling should start
    final double scaleStart = 160.0;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          backgroundColor: Color(0xFFEC407A),
          heroTag: "btn1",
          onPressed: () {},
          child: Icon(Icons.camera_alt_outlined),
        ),
      ),
    );
  }

  List<IconData> _userTileIcon = [
    Icons.email,
    Icons.phone,
    Icons.local_shipping,
    Icons.watch_later,
    Icons.exit_to_app_rounded,
  ];

  Widget userListTile(
    String title,
    String subTitle,
    int index,
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        onTap: () {},
        child: ListTile(
          title: Text(title),
          subtitle: Text(subTitle == null ? 'Empty' : subTitle),
          leading: Icon(
            _userTileIcon[index],
            color: Color(0xFFEC407A),
          ),
          // trailing: IconButton(
          //   icon: Icon(Icons.edit),
          //   onPressed: () {},
          // ),
        ),
      ),
    );
  }

  Widget userTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}
