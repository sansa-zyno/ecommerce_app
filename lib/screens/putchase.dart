import 'package:flutter/material.dart';
import 'package:shop_app/provider/user.dart';
import 'package:shop_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class Purchases extends StatefulWidget {
  @override
  _PurchasesState createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.green),
          title: Text(
            "Purchase History",
            style: TextStyle(color: Colors.green),
          ),
        ),
        body: ListView.separated(
          itemCount: user.purchaseHistory.length,
          itemBuilder: (_, index) {
            return ListTile(
              leading: CustomText(
                  text: "\$" + user.purchaseHistory[index].amount.toString()),
              title: Text(user.purchaseHistory[index].productName),
              subtitle: Text(
                  "Order id: asdasdasdasd \n Putchased on: ${user.purchaseHistory[index].date}"),
              trailing: Icon(Icons.more_horiz),
              onTap: () {},
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ));
  }
}
