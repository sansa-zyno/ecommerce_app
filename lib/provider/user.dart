import 'dart:async';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/user.dart';
import 'package:shop_app/models/cards.dart';
import 'package:shop_app/models/purchase.dart';
import 'package:shop_app/services/order.dart';
import 'package:shop_app/services/users.dart';
import 'package:shop_app/services/purchases.dart';
import 'package:shop_app/services/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  Status get status => _status;
  FirebaseUser get user => _user;
  UserServices _userServices = UserServices();
  CardServices _cardServices = CardServices();
  PurchaseServices _purchaseServices = PurchaseServices();
  OrderServices _orderServices = OrderServices();

  UserModel _userModel;
  List<CardModel> cards = [];
  List<PurchaseModel> purchaseHistory = [];

  //  we will make this variables public for now
  final formKey = GlobalKey<FormState>();

//  getter
  UserModel get userModel => _userModel;
  bool hasStripeId = true;

  // public variables
  List<OrderModel> orders = [];

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {});
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  void hasCard() {
    hasStripeId = !hasStripeId;
    notifyListeners();
  }

  Future<void> loadCardsAndPurchase({String userId}) async {
    cards = await _cardServices.getCards(userId: userId);
    purchaseHistory =
        await _purchaseServices.getPurchaseHistory(userId: userId);
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        print("CREATE USER");
        _userServices.createUser({
          'name': name,
          'email': email,
          'uid': result.user.uid,
        });
        notifyListeners();
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onStateChanged(FirebaseUser user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
      notifyListeners();
    } else {
      _user = user;
      _status = Status.Authenticated;
      _userModel = await _userServices.getUserById(user.uid);
      cards = await _cardServices.getCards(userId: user.uid);
      purchaseHistory =
          await _purchaseServices.getPurchaseHistory(userId: user.uid);
      if (_userModel.stripeId == null) {
        hasStripeId = false;
        notifyListeners();
      }
      notifyListeners();
    }
  }

  Future<bool> addToCart(
      {ProductModel product, String size, String color}) async {
    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List<CartItemModel> cart = _userModel.cart;

      Map cartItem = {
        "id": cartItemId,
        "name": product.name,
        "image": product.picture,
        "productId": product.id,
        "price": product.price,
        "size": size,
        "color": color
      };

      CartItemModel item = CartItemModel.fromMap(cartItem);
//      if(!itemExists){
      print("CART ITEMS ARE: ${cart.toString()}");
      _userServices.addToCart(userId: _user.uid, cartItem: item);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromCart({CartItemModel cartItem}) async {
    print("THE PRODUC IS: ${cartItem.toString()}");

    try {
      _userServices.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  getOrders() async {
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }

  Future<void> reloadUserModel() async {
    _userModel = await _userServices.getUserById(user.uid);
    notifyListeners();
  }
}
