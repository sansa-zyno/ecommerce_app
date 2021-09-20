import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:shop_app/provider/user.dart';
import 'package:shop_app/screens/home.dart';
import 'package:shop_app/helpers/common.dart';
import 'package:shop_app/services/stripe.dart';
import 'package:provider/provider.dart';

class CreditCard extends StatefulWidget {
  CreditCard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  final _scacffoldKey = GlobalKey<ScaffoldState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _scacffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              CreditCardWidget(
                height: 200,
                cardBgColor: Colors.deepOrange,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView:
                    isCvvFocused, //true when you want to show cvv(back) view
              ),
              CreditCardForm(
                themeColor: Colors.deepOrange,
                onCreditCardModelChange: (CreditCardModel data) {
                  setState(() {
                    cardNumber = data.cardNumber;
                    expiryDate = data.expiryDate;
                    cardHolderName = data.cardHolderName;
                    cvvCode = data.cvvCode;
                    isCvvFocused = data.isCvvFocused;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          int cvc = int.tryParse(cvvCode);
          int carNo =
              int.tryParse(cardNumber.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
          int exp_year = int.tryParse(expiryDate.substring(3, 5));
          int exp_month = int.tryParse(expiryDate.substring(0, 2));

          print("cvc num: ${cvc.toString()}");
          print("card num: ${carNo.toString()}");
          print("exp year: ${exp_year.toString()}");
          print("exp month: ${exp_month.toString()}");
          print(cardNumber.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
//
          StripeServices stripeServices = StripeServices();
          bool res;
          if (user.userModel.stripeId == null) {
            String stripeID = await stripeServices.createStripeCustomer(
                email: user.userModel.email, userId: user.user.uid);
            print("stripe id: $stripeID");

            res = await stripeServices.addCard(
                stripeId: stripeID,
                month: exp_month,
                year: exp_year,
                cvc: cvc,
                cardNumber: carNo,
                userId: user.user.uid);
            if (res) {
              user.hasCard();
            }
          } else {
            res = await stripeServices.addCard(
                stripeId: user.userModel.stripeId,
                month: exp_month,
                year: exp_year,
                cvc: cvc,
                cardNumber: carNo,
                userId: user.user.uid);
          }
          user.loadCardsAndPurchase(userId: user.user.uid);
       if (res == true) {
            Navigator.pop(context);
          } else {
            _scacffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
                "Invalid card details",
              ),
            ));
          }
        },
        tooltip: 'Submit',
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
