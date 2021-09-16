import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/services/cards.dart';
import 'package:shop_app/services/purchases.dart';
import 'package:shop_app/services/users.dart';
import 'package:uuid/uuid.dart';

class StripeServices {
  //static const PUBLISHABLE_KEY = "pk_test_A4nXLMSuUFOORBC9PE1x0TmK00Flkotazb";
  static const PUBLISHABLE_KEY =
      "pk_test_51IZBsxJbYEviG9EVjSskHaeIjBqWW2P64a7sDCQlL4dFOwbrItsDoCXvS75XSnVwtmBp3zm9AkLyMJ4myLEC5EMQ00Is4thYkk";
  // static const SECRET_KEY = "sk_test_lkszgvX0S87KLLs7NmunPr5Z00F8lcHe6s";
  static const SECRET_KEY =
      "sk_test_51IZBsxJbYEviG9EVlh2qn2UxneEHSQD90rVayQM73lZLjAYn5OhUEihhWcsBKg3ur1XoJgiaiNIekNdCL3XKAENx001XoioNqe";
  static const PAYMENT_METHOD_URL = "https://api.stripe.com/v1/payment_methods";
  static const CUSTOMERS_URL = "https://api.stripe.com/v1/customers";
  static const CHARGE_URL = "https://api.stripe.com/v1/charges";
  Map<String, String> headers = {
    'Authorization': "Bearer  $SECRET_KEY",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  Future<String> createStripeCustomer({String email, String userId}) async {
    Map<String, String> body = {
      'email': email,
    };
    String stripeId = await http
        .post(CUSTOMERS_URL, body: body, headers: headers)
        .then((response) {
      String stripeId = jsonDecode(response.body)["id"];
      print("The stripe id is: $stripeId");
      UserServices userService = UserServices();
      userService.updateDetails({"id": userId, "stripeId": stripeId});
      return stripeId;
    }).catchError((err) {
      print("==== THERE WAS AN ERROR ====: ${err.toString()}");
      return null;
    });
    return stripeId;
  }

  Future<void> addCard(
      {int cardNumber,
      int month,
      int year,
      int cvc,
      String stripeId,
      String userId}) async {
    Map body = {
      "type": "card",
      "card[number]": cardNumber,
      "card[exp_month]": month,
      "card[exp_year]": year,
      "card[cvc]": cvc
    };
    Dio()
        .post(PAYMENT_METHOD_URL,
            data: body,
            options: Options(
                contentType: Headers.formUrlEncodedContentType,
                headers: headers))
        .then((response) {
      String paymentMethodId = response.data["id"];
      print("=== The payment mathod id id ===: $paymentMethodId");
      http
          .post(
              "https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach",
              body: {"customer": stripeId},
              headers: headers)
          .catchError((err) {
        print("ERROR ATTACHING CARD TO CUSTOMER");
        print("ERROR: ${err.toString()}");
      });

      CardServices cardServices = CardServices();
      cardServices.createCard(
          id: paymentMethodId,
          last4: int.parse(cardNumber.toString().substring(11)),
          exp_month: month,
          exp_year: year,
          userId: userId);
      UserServices userService = UserServices();
      userService.updateDetails({"id": userId, "activeCard": paymentMethodId});
    });
  }

  Future<bool> charge(
      {String customer,
      int amount,
      String userId,
      String cardId,
      String productName}) async {
    Map<String, dynamic> data = {
      "amount": amount,
      "currency": "usd",
      "source": cardId,
      "customer": customer
    };
    try {
      Dio()
          .post(CHARGE_URL,
              data: data,
              options: Options(
                  contentType: Headers.formUrlEncodedContentType,
                  headers: headers))
          .then((response) {
        print(response.toString());
      });
      PurchaseServices purchaseServices = PurchaseServices();
      var uuid = Uuid();
      var purchaseId = uuid.v1();
      purchaseServices.createPurchase(
          id: purchaseId,
          amount: amount,
          cardId: cardId,
          userId: userId,
          productName: productName);
      return true;
    } catch (e) {
      print("there was an error charging the customer: ${e.toString()}");
      return false;
    }
  }
}
