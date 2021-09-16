import 'package:shop_app/helpers/common.dart';
import 'package:shop_app/helpers/style.dart';
import 'package:shop_app/widgets/custom_text.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shop_app/provider/app.dart';
import 'package:shop_app/provider/user.dart';
import 'package:provider/provider.dart';
import 'loading.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;

  const ProductCard({Key key, this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      key: _key,
      body: GestureDetector(
        onTap: () {
          changeScreen(
              context,
              ProductDetails(
                product: widget.product,
              ));
        },
        child: Card(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: Align(
                    alignment: Alignment.center,
                    child: Loading(),
                  )),
                  Container(
                    width: 160,
                    height: 180,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.product.picture,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: '${widget.product.name} \n',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextSpan(
                      text: '\$${widget.product.price / 100} \n',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: widget.product.sale ? 'ON SALE ' : "",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: orange,
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: orange,
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: orange,
                      size: 16,
                    ),
                    Icon(
                      Icons.star,
                      color: grey,
                      size: 16,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    CustomText(
                      text: "4.0",
                      color: grey,
                      size: 14.0,
                    ),
                  ],
                ),
              ),
              Material(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.orange,
                elevation: 0.0,
                child: MaterialButton(
                  onPressed: () async {
                    appProvider.changeIsLoading();
                    bool success = await userProvider.addToCart(
                        product: widget.product,
                        color: widget.product.colors[0],
                        size: widget.product.sizes[0]);
                    if (success) {
                      _key.currentState.showSnackBar(
                        SnackBar(
                          content: Text(
                            "Added to Cart!",
                            style: TextStyle(color: black),
                          ),
                          elevation: 0.0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: white,
                        ),
                      );
                      userProvider.reloadUserModel();
                      appProvider.changeIsLoading();
                      return;
                    } else {
                      _key.currentState.showSnackBar(SnackBar(
                        content: Text("Not added to Cart!"),
                        elevation: 0.0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: white,
                      ));
                      appProvider.changeIsLoading();
                      return;
                    }
                  },
                  child: Text(
                    "ADD TO CART",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
