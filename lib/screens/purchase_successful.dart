import 'package:flutter/material.dart';
import 'package:shop_app/helpers/style.dart';
import 'package:shop_app/screens/home.dart';
import 'package:shop_app/helpers/common.dart';
import 'package:shop_app/widgets/custom_text.dart';

class Success extends StatelessWidget {
  final String price;
  Success({this.price});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor: blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.shop,
                  size: 30,
                  color: orange,
                ),
                Text(
                  "Aisha shop",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          CustomText(
            text:
                "Thank you for Patronizing us. \n You have successfully purchased a product of " +
                    " ",
            color: orange,
            textAlign: TextAlign.center,
          ),
          RichText(
            text: TextSpan(
                text: "\$${int.parse(price) / 100}",
                style: TextStyle(color: blue, fontSize: 21)),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  changeScreen(context, HomePage());
                },
                icon: Icon(Icons.home),
                label: CustomText(text: "Go to home"),
                color: orange,
              ),
            ],
          )
        ],
      ),
    );
  }
}
