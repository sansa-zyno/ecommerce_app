import 'package:shop_app/helpers/style.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/provider/app.dart';
import 'package:shop_app/provider/user.dart';
import 'package:shop_app/widgets/custom_text.dart';
import 'package:shop_app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({Key key, this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _key = GlobalKey<ScaffoldState>();
  String _color = "";
  String _size = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _color = widget.product.colors[0];
    _size = widget.product.sizes[0];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      body: SafeArea(child: Container(child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned.fill(
                        child: Align(
                      alignment: Alignment.center,
                      child: Loading(),
                    )),
                    Center(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: widget.product.picture,
                        fit: BoxFit.fill,
                        height: 400,
                        width: double.infinity,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            // Box decoration takes a gradient
                            gradient: LinearGradient(
                              // Where the linear gradient begins and ends
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              // Add one stop for each color. Stops should increase from 0 to 1
                              colors: [
                                // Colors are easy thanks to Flutter's Colors class.
                                Colors.black.withOpacity(0.7),
                                Colors.black.withOpacity(0.5),
                                Colors.black.withOpacity(0.07),
                                Colors.black.withOpacity(0.05),
                                Colors.black.withOpacity(0.025),
                              ],
                            ),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container())),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                            // Box decoration takes a gradient
                            gradient: LinearGradient(
                              // Where the linear gradient begins and ends
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              // Add one stop for each color. Stops should increase from 0 to 1
                              colors: [
                                // Colors are easy thanks to Flutter's Colors class.
                                Colors.black.withOpacity(0.8),
                                Colors.black.withOpacity(0.6),
                                Colors.black.withOpacity(0.6),
                                Colors.black.withOpacity(0.4),
                                Colors.black.withOpacity(0.07),
                                Colors.black.withOpacity(0.05),
                                Colors.black.withOpacity(0.025),
                              ],
                            ),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container())),
                    ),
                    Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  widget.product.name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '\$${widget.product.price / 100}',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Positioned(
                      top: 120,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: red,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(35))),
                            child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: CustomText(
                                text: "Select a Color",
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: DropdownButton<String>(
                                  value: _color,
                                  style: TextStyle(color: white),
                                  items: widget.product.colors
                                      .map<DropdownMenuItem<String>>(
                                          (value) => DropdownMenuItem(
                                              value: value,
                                              child: CustomText(
                                                text: value,
                                                color: red,
                                              )))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _color = value;
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: CustomText(
                                text: "Select a Size",
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: DropdownButton<String>(
                                  value: _size,
                                  style: TextStyle(color: white),
                                  items: widget.product.sizes
                                      .map<DropdownMenuItem<String>>(
                                          (value) => DropdownMenuItem(
                                              value: value,
                                              child: CustomText(
                                                text: value,
                                                color: red,
                                              )))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _size = value;
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("${widget.product.description}",
                            style:
                                TextStyle(color: Colors.black, fontSize: 18)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(9),
                        child: Material(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.black,
                            elevation: 0.0,
                            child: MaterialButton(
                              onPressed: () async {
                                appProvider.changeIsLoading();
                                bool success = await userProvider.addToCart(
                                    product: widget.product,
                                    color: _color,
                                    size: _size);
                                if (success) {
                                  _key.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                      "Item has been put to Cart!",
                                      style: TextStyle(
                                          color: orange,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    //behavior: SnackBarBehavior.floating,
                                    backgroundColor: white,
                                    elevation: 0.0,
                                  ));
                                  userProvider.reloadUserModel();
                                  appProvider.changeIsLoading();
                                  return;
                                } else {
                                  _key.currentState.showSnackBar(SnackBar(
                                    content: Text("Not added to Cart!"),
                                    backgroundColor: white,
                                    elevation: 0.0,
                                  ));
                                  appProvider.changeIsLoading();
                                  return;
                                }
                              },
                              minWidth: MediaQuery.of(context).size.width,
                              child: appProvider.isLoading
                                  ? Loading()
                                  : Text(
                                      "Add to cart",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }))),
    );
  }
}
