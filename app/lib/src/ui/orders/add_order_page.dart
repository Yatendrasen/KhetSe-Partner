import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/blocs/products/vendor_bloc.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'add_customer.dart';
import 'package:intl/intl.dart';


class AddOrderPage extends StatefulWidget {
  final VendorBloc vendorBloc;
  AddOrderPage({Key? key, required this.vendorBloc}) : super(key: key);

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  TextEditingController _totalController = TextEditingController();

  var qty = 0;
  AppStateModel _appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
    widget.vendorBloc.fetchAllProducts();

  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.currency(
       // decimalDigits: _appStateModel.order.decimals,
        locale: Localizations.localeOf(context).toString(),
        name: _appStateModel.order.currency);

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("add_order")),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.person_add,
                  size: 25,
                ),
                iconSize: 20.0,
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddCustomer(
                              vendorBloc: widget.vendorBloc
                          ))),
                })
          ],
        ),
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                buildProductDetails(context, formatter),
                buildCustomerDetails(context, formatter)
              ],
            ),
            Positioned(
              bottom: 20,
              left: 10.0,
              right: 10.0,
              child: Container(
                child: AccentButton(
                  onPressed: () {
                    widget.vendorBloc.addOrder(_appStateModel.order);
                    // In new Page
                  },
                  text: AppLocalizations.of(context).translate("submit"),
                ),
              ),
            ),
          ],
        ));
  }

  buildProductDetails(BuildContext context, NumberFormat formatter) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.0),
      sliver: ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
        return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Text(model.order.lineItems[index].name
                                  + ' x ' + model.order.lineItems[index].quantity.toString()
                              ),
                            ),
                            Text(formatter.format((double.parse(
                                '${model.order.lineItems[index].price}')))),

                            IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {

                                  setState(() {
                                    model.order.lineItems
                                        .remove(model.order.lineItems[index]);
                                  });
                                })
                          ],
                        ),
                        height: 80),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                        /*  SizedBox(
                            width: 120,
                            child: SizedBox(height: 16),
                    TextFormField(
                              initialValue: formatter.format((double.parse(
                                  '${widget.order.lineItems[index].total}'))),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  widget.order.lineItems[index].total =
                                      (double.parse(newValue)).toString();
                                });
                              },
                              // onSaved: (val) => setState(() =>  widget.order.lineItems[index].total = val),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 80,
                            child: SizedBox(height: 16),
                    TextFormField(
                             initialValue: widget.order.lineItems[index].quantity.toString(),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                               suffixIcon: Column(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_drop_up,
                                        ),
                                         onPressed: () => _increaseQty()
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                        ),
                                       onPressed: () => _decreaseQty()
                                      ),
                                    ],
                                  ),

                              ),
                            ),
                          ),*/

                        ],
                      ),
                      // ),
                    ),
                  ],
                );
              },
              childCount: model.order.lineItems.length,
            ),
          );
        }
      ),
    );
  }

  buildCustomerDetails(BuildContext context, NumberFormat formatter) {

    return ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
      return SliverList(
            delegate: SliverChildListDelegate([
          Container(
            padding: EdgeInsets.all(10.0),
            child: InkWell(
              /*  onTap: (){Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditOrder(vendorBloc: widget.vendorBloc)));
              },*/
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  _getBillingAddress(model.order.billing) != '' ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate("billing_details"),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 10.0),
                        Text(_getBillingAddress(model.order.billing)),
                        Divider(),
                        SizedBox(height: 10.0),
                      ]) : Container(),
                  _getShippingAddress(model.order.shipping).isNotEmpty ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate("shipping_details"),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(_getShippingAddress(model.order.shipping))
                      ]) : Container(),
                ],
              ),
            ),
          )
        ]));
      }
    );
  }

  String _getBillingAddress(Address billing) {
    String address = '';
    if(billing.firstName != null) {
      address = address + ' ' + billing.firstName;
    } if(billing.lastName != null) {
      address = address + ' ' + billing.lastName;
    } if(billing.company != null) {
      address = address + ' ' + billing.company;
    } if(billing.address2 != null) {
      address = address + ' ' + billing.address2;
    } if(billing.address2 != null) {
      address = address + ' ' + billing.address2;
    } if(billing.city != null) {
      address = address + ' ' + billing.city;
    } if(billing.postcode != null) {
      address = address + ' ' + billing.postcode;
    } if(billing.state != null) {
      address = address + ' ' + billing.state!;
    } if(billing.country != null) {
      address = address + ' ' + billing.country!;
    } return address;
  }
  String _getShippingAddress(Address shipping) {
    String address = '';
    if(shipping.firstName != null) {
      address = address + shipping.firstName;
    } if(shipping.lastName != null) {
      address = address + ' ' + shipping.lastName;
    } if(shipping.company != null) {
      address = address + ' ' + shipping.company;
    } if(shipping.address2 != null) {
      address = address + ' ' + shipping.address2;
    } if(shipping.address2 != null) {
      address = address + ' ' + shipping.address2;
    } if(shipping.city != null) {
      address = address + ' ' + shipping.city;
    } if(shipping.postcode != null) {
      address = address + ' ' + shipping.postcode;
    } if(shipping.state != null) {
      address = address + ' ' + shipping.state!;
    } if(shipping.country != null) {
      address = address + ' ' + shipping.country!; }
    return address;
  }
}
