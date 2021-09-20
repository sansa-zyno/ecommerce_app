import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shop_app/helpers/common.dart';
import 'package:shop_app/helpers/style.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/user.dart';
import 'package:shop_app/widgets/custom_text.dart';
import 'package:shop_app/widgets/product_card.dart';
import 'package:shop_app/screens/credit_card.dart';
import 'package:shop_app/screens/manage_cards.dart';
import 'package:shop_app/screens/putchase.dart';
import 'package:shop_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
        key: _key,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.5,
          backgroundColor: Colors.white,
          title: CustomText(
            text: "AishaShop",
            color: Colors.black,
          ),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  changeScreen(context, CartScreen());
                },
                child: Icon(Icons.shopping_cart)),
            SizedBox(width: 10),
            GestureDetector(
                onTap: () {
                  _key.currentState
                      .showSnackBar(SnackBar(content: Text("User profile")));
                },
                child: Icon(Icons.person)),
            SizedBox(width: 10),
          ],
        ),
        backgroundColor: white,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 30,
                  backgroundColor: white,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: orange,
                  ),
                ),
                accountEmail: CustomText(
                  text: userProvider.user.email ?? "email loading...",
                  color: white,
                ),
                accountName: CustomText(
                  text: userProvider.userModel.name ?? "name loading...",
                  color: white,
                ),
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: CustomText(
                  text: "Add Credit Card",
                ),
                onTap: () {
                  changeScreen(
                      context,
                      CreditCard(
                        title: "Add card",
                      ));
                },
              ),
              ListTile(
                leading: Icon(Icons.credit_card),
                title: CustomText(
                  text: "Manage Cards",
                ),
                onTap: () {
                  changeScreen(context, ManagaCardsScreen());
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: CustomText(
                  text: "Purchase history",
                ),
                onTap: () {
                  changeScreen(context, Purchases());
                },
              ),
              ListTile(
                leading: Icon(Icons.memory),
                title: CustomText(
                  text: "Subscriptions",
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: CustomText(
                  text: "Log out",
                ),
                onTap: () {
                  userProvider.signOut();
                  changeScreenReplacement(context, Login());
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
            child: RefreshIndicator(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
//           Custom App bar
              Visibility(
                visible: !userProvider.hasStripeId,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      changeScreen(
                          context,
                          CreditCard(
                            title: "Add card",
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: red[400],
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.warning,
                              color: white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CustomText(
                              text: "Please add your card details",
                              size: 14,
                              color: white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // recent products
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: new Text(
                      'Recent products',
                      style: TextStyle(fontSize: 20, color: black),
                      textAlign: TextAlign.center,
                    )),
                  ),
                ],
              ),

              Divider(),

              StaggeredGridView.countBuilder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                crossAxisCount: 4,
                itemCount: productProvider.products.length,
                itemBuilder: (BuildContext context, int index) => ProductCard(
                  product: productProvider.products[index],
                ),
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, index.isEven ? 4 : 4),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 2.0,
              )
            ],
          ),
          onRefresh: () async {
            await productProvider.loadProducts();
          },
        )));
  }
}
