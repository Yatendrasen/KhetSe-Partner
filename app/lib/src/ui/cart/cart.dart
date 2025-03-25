import 'package:admin/src/blocs/orders/orders_bloc.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/coupons/coupons_model.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/models/payment/payment_gateways_model.dart';
import 'package:admin/src/ui/coupons/select_coupon.dart';
import 'package:admin/src/ui/customers/select_customer.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/orders/custom_card.dart';
import 'package:admin/src/ui/orders/select_order_status.dart';
import 'package:admin/src/ui/payment_gateways/select_payment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

extension StringExtension on String {
  String capitalize() {
    return "₹{this[0].toUpperCase()}₹{this.substring(1).toLowerCase()}";
  }
}

class CartPage extends StatefulWidget {
  final OrdersBloc ordersBloc;

  const CartPage({Key? key, required this.ordersBloc}) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  bool isLoading = false;
  AppStateModel _appStateModel = AppStateModel();
  final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: AppStateModel().numberOfDecimals);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).translate("cart"),),),
        body: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return model.order.lineItems.length > 0 ? ListView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: model.order.lineItems.length,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          Card(
                            elevation: 0,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                              leading: Container(
                                width: 60,
                                height: 80,
                                child: CachedNetworkImage(
                                  imageUrl: model.order.lineItems[i].images.length > 0 ? model.order.lineItems[i].images[0].src : '',
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image:
                                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    width: 60,
                                    height: 80,
                                    color: Theme.of(context).canvasColor,
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 60,
                                    height: 80,
                                    color: Theme.of(context).canvasColor,
                                  ),
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(model.order.lineItems[i].name, maxLines: 2),
                                  if(model.order.lineItems[i].metaData != null)
                                    for(var meta in model.order.lineItems[i].metaData!)
                                      Text(meta.key.replaceAll('pa_', '').capitalize() + ': ' + meta.value, style: Theme.of(context).textTheme.bodyMedium,),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(AppLocalizations.of(context)
                                              .translate("price") +":"+" ₹"+ model.order.lineItems[i].price.toString()),
                                          Text(AppLocalizations.of(context)
                                              .translate("total") + ":"+" ₹"+ model.order.lineItems[i].total.toString()),
                                        ],
                                      ),
                                      ScopedModelDescendant<AppStateModel>(
                                          builder: (context, child, model) {
                                            return Row(
                                              children: [
                                                IconButton(onPressed: () {
                                                  _decreaseQty(model.order.lineItems[i]);
                                                }, icon: Icon(CupertinoIcons.minus_circle, color: Theme.of(context).primaryColor)),
                                                Center(child: Text(model.order.lineItems[i].quantity.toString())),
                                                IconButton(onPressed: () {
                                                  _increaseQty(model.order.lineItems[i]);
                                                }, icon: Icon(CupertinoIcons.add_circled_solid, color: Theme.of(context).primaryColor))
                                              ],
                                            );
                                          }
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                      onTap: () {
                                        _removeItem(model.order.lineItems[i]);
                                      },
                                      child: Icon(CupertinoIcons.delete, color: Theme.of(context).hintColor, size: 16,))
                                ],
                              ),
                            ),
                          ),
                          Divider(height: 0)
                        ],
                      );
                    },
                  ),
                  CustomCard(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)
                              .translate("total") ),
                          Text(("₹${_getTotal().toString()}")),
                        ],
                      ),
                    ),
                  ),
                  CustomCard(
                    child: ListTile(
                      onTap: () async {
                        Customer? customer = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => SelectCustomer()
                            ));
                        print(model.order.billing.firstName);
                        if(customer != null) {
                          model.order.customerId = customer.id;
                          model.order.billing = customer.billing;
                          model.order.shipping = customer.shipping;
                          if(model.order.billing.email.isEmpty) {
                            model.order.billing.email = customer.email;
                          }
                          setState(() {});
                        }
                      },
                      title: Text(AppLocalizations.of(context)
                          .translate("customer") ),
                      trailing: Icon(Icons.arrow_right),
                      subtitle: model.order.billing.firstName.isNotEmpty ? Text(model.order.billing.firstName + ' ' + model.order.billing.lastName) : model.order.billing.email.isNotEmpty ? Text(model.order.billing.email) : model.order.customerId == null ? Text(AppLocalizations.of(context).translate("select"),) : null,
                    ),
                  ),
                  CustomCard(
                    child: ListTile(
                      onTap: () async {
                        Coupon? coupon = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => SelectCoupon()
                            ));
                        if(coupon != null) {
                          CouponLine couponLine = CouponLine(code: coupon.code);
                          model.order.couponLines.add(couponLine);
                          setState(() {});
                        }
                      },
                      title: Text('Coupon'),
                      trailing: Icon(Icons.arrow_right),
                      subtitle: model.order.couponLines.isNotEmpty && model.order.couponLines[0].code != null ? Wrap(
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children: model.order.couponLines.map((e) => Chip(onDeleted: () {
                            setState(() {
                              model.order.couponLines.remove(e);
                            });
                          },deleteIcon: Icon(
                                Icons.close,
                                ), label: Text(e.code!))
                          ).toList()) : null,
                    ),
                  ),
                  CustomCard(
                    child: ListTile(
                      onTap: () async {
                        PaymentGateway? payment = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => SelectPaymentGateway()
                            ));
                        if(payment != null) {
                          model.order.paymentMethodTitle = payment.title;
                          model.order.paymentMethod = payment.id;
                          setState(() {});
                        }
                      },
                      title: Text(AppLocalizations.of(context)
                          .translate("payment") ),
                      trailing: Icon(Icons.arrow_right),
                      subtitle: model.order.paymentMethodTitle.isNotEmpty ? Text(model.order.paymentMethodTitle) : Text(AppLocalizations.of(context).translate("select"),),
                    ),
                  ),
                  CustomCard(
                    child: ListTile(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => OrderStatus()
                            ));
                      },
                      title: Text(AppLocalizations.of(context)
                          .translate("order_status") ),
                      trailing: Icon(Icons.arrow_right),
                      subtitle: model.order.status != null ? Text(model.order.status!.toUpperCase()) : Text(AppLocalizations.of(context).translate("select"),),
                    ),
                  ),
                  CustomCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate("order_notes"),        //transaction_id should come here
                        ),
                        onChanged: (val) {
                          setState(() => model.order.customerNote = val);
                        },
                      ),
                    ),
                  )
                ],
              ) : Center(child: Icon(CupertinoIcons.bag, size: 128, color: Theme.of(context).focusColor,),);
            }
        ),
        bottomNavigationBar: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return model.order.lineItems.length > 0 ? Card(
                elevation: 0,
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Builder(
                  builder: (context) =>  SafeArea(
                    child: Container(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          setState(() {
                            isLoading = true;
                          });
                          Order order = await widget.ordersBloc.addItem(model.order);
                          model.order = Order.fromJson({});
                          model.notifyModelListeners();
                          setState(() {
                            isLoading = false;
                          });
                          widget.ordersBloc.fetchItems();
                        },
                        child: Text(AppLocalizations.of(context)
                            .translate("create_order"), ),
                      ),
                    ),
                  ),
                ),
              ) : Container(height: 0);
            }
        )
    );
  }

  void _increaseQty(LineItem lineItem) {
    lineItem.quantity++;
    lineItem.total = (lineItem.price * lineItem.quantity);
    _appStateModel.notifyModelListeners();
  }

  void _decreaseQty(LineItem lineItem) {
    if(lineItem.quantity == 1) {
      _appStateModel.order.lineItems.remove(lineItem);
    } else {
      lineItem.quantity--;
      lineItem.total = (lineItem.price * lineItem.quantity);
    }
    _appStateModel.notifyModelListeners();
  }

  void _removeItem(LineItem lineItem) {
    _appStateModel.order.lineItems.remove(lineItem);
    _appStateModel.notifyModelListeners();
  }

  double _getTotal() {
    double total = 0;
    _appStateModel.order.lineItems.forEach((element) { total = total + element.total;});
    return total;
  }
}
