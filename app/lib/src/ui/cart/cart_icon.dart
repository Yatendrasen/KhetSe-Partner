import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/blocs/products/vendor_bloc.dart';
import 'package:admin/src/ui/cart/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class CartIcon extends StatelessWidget {
  final OrdersBloc ordersBloc;
  const CartIcon({
    Key? key, required this.ordersBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                CupertinoIcons.bag,
                semanticLabel: 'Cart',
              ),
              onPressed: () {
                if(model.order.lineItems.length > 0)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CartPage(ordersBloc: ordersBloc),
                    ));
              },
            ),
            Positioned(
              top: 2,
              right: 2.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => CartPage(ordersBloc: ordersBloc),
                      ));
                },
                child: model.order.lineItems.length > 0 ? Card(
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
                    shape: StadiumBorder(),
                    color: Colors.red,
                    child: Container(
                        padding: EdgeInsets.all(2),
                        constraints: BoxConstraints(minWidth: 20.0),
                        child: Center(
                            child: Text(
                              _getTotal(model.order.lineItems),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                backgroundColor: Colors.red,
                              ),
                            )))) : Container(),
              ),
            )
          ],
        );
      }
    );
  }

  String _getTotal(List<LineItem> lineItems) {
    int total = 0;
    lineItems.forEach((element) {total = total+element.quantity;});
    return total.toString();
  }
}