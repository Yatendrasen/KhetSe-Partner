import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit_customer.dart';
import 'package:admin/src/models/customer/customer_model.dart';

class CustomerDetail extends StatefulWidget {
  final Customer customer;
  final CustomerBloc customersBloc;
  CustomerDetail({Key? key, required this.customer, required this.customersBloc});

  @override
  _CustomerDetailState createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).translate("customer_detail")), actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.edit,
            semanticLabel: 'edit',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditCustomer(customer: widget.customer, customersBloc: widget.customersBloc)),
            );
          },
        ),
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.customersBloc.deleteItem(widget.customer);
              widget.customersBloc.fetchItems();
              Navigator.pop(context);
            }),
      ]),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 5.0,
        ),
        children: ListTile.divideTiles(
          //          <-- ListTile.divideTiles
          context: context,
          tiles: [
            ListTile(
              title: Text(AppLocalizations.of(context).translate("id")),
              subtitle: Text(widget.customer.id.toString()),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("firstname")),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.customer.firstName),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(onPressed: () {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'tel',
                          path: widget.customer.billing.phone,
                        );
                        launchUrl(emailLaunchUri);
                      }, icon: Icon(CupertinoIcons.phone_fill), label: Text(AppLocalizations.of(context)
                          .translate("call"),)),
                      SizedBox(width: 8),
                      TextButton.icon(onPressed: () {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: widget.customer.billing.email,
                        );
                        launchUrl(emailLaunchUri);
                      }, icon: Icon(CupertinoIcons.mail_solid), label: Text(AppLocalizations.of(context)
                          .translate("email"),),),
                      SizedBox(width: 8),
                      TextButton.icon(onPressed: () {
                        final Uri launchUri = Uri(
                          scheme: 'sms',
                          path: widget.customer.billing.phone,
                        );
                        launchUrl(launchUri);
                      }, icon: Icon(CupertinoIcons.chat_bubble_fill), label: Text(AppLocalizations.of(context)
                          .translate("sms"))),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("lastname")),
              subtitle: Text(widget.customer.lastName),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("username")),
              subtitle: Text(widget.customer.username),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("email")),
              subtitle: Text(widget.customer.email),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("billing_details")),
              subtitle: Text(
                  ''' ${widget.customer.billing.firstName}   ${widget.customer.billing.lastName}
 ${widget.customer.billing.company}
 ${widget.customer.billing.address1}
 ${widget.customer.billing.address2}
 ${widget.customer.billing.city}
 ${widget.customer.billing.state}
 ${widget.customer.billing.postcode}
 ${widget.customer.billing.country}
 ${widget.customer.billing.email}
 ${widget.customer.billing.phone}
              '''),
            ),


            ListTile(
              title: Text(AppLocalizations.of(context).translate("shipping_details:")),
              subtitle: Text(
                  '''${widget.customer.shipping.firstName}   ${widget.customer.shipping.lastName}
${widget.customer.shipping.company}
${widget.customer.shipping.address1}
${widget.customer.shipping.address2}
 ${widget.customer.shipping.city}
${widget.customer.shipping.state}
${widget.customer.shipping.postcode}
 ${widget.customer.shipping.country}
                  
              '''),
            ),
          ],
        ).toList(),
      ),
    );
  }
}
