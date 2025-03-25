import 'package:admin/src/blocs/payments/payment_bloc.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/models/payment/payment_gateways_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';


class EditPaymentGateway extends StatefulWidget {
  final PaymentGateway paymentGateway;
  PaymentGatewaysBloc paymentGatewaysBloc = PaymentGatewaysBloc();
   EditPaymentGateway({Key? key, required this.paymentGateway});

  @override
  _EditPaymentGatewayState createState() => _EditPaymentGatewayState();
}

class _EditPaymentGatewayState extends State<EditPaymentGateway> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("edit_payment")),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /*SizedBox(height: 16),
                    TextFormField(
                    initialValue: widget.paymentGateway.id,
                    decoration: InputDecoration(
                      labelText: 'Id',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter id';
                      }
                    },
                    onSaved: (val) =>
                        setState(() => widget.paymentGateway.id = val),
                  ),*/
                  SizedBox(height: 16),
                    TextFormField(
                    initialValue: widget.paymentGateway.title,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("title")),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter title';
                      }
                    },
                    onSaved: (val) {
                      if(val != null) {
                        setState(() => widget.paymentGateway.title = val);
                      }
                    },
                  ),
                  SizedBox(height: 16),
                    TextFormField(
                    initialValue: widget.paymentGateway.description,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("description")),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                    },
                    onSaved: (val) {
                      if(val != null) {
                        setState(() => widget.paymentGateway.description = val);
                      }
                    },
                  ),
                  /* SizedBox(height: 16),
                    TextFormField(
                    initialValue: widget.paymentGateway.order.toString(),
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    decoration: InputDecoration(labelText: 'Order'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter order';
                      }
                    },
                    onSaved: (val) =>
                        setState(() => widget.paymentGateway.order),
                  ),

                  SizedBox(height: 16),
                    TextFormField(
                    initialValue: widget.paymentGateway.methodTitle,
                    decoration: InputDecoration(labelText: 'Method Title'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter method title';
                      }
                    },
                    onSaved: (val) =>
                        setState(() => widget.paymentGateway.methodTitle = val),
                  ),
                  SizedBox(height: 16),
                    TextFormField(
                    initialValue: widget.paymentGateway.methodDescription,
                    decoration: InputDecoration(labelText: 'Method Description'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter method description';
                      }
                    },
                    onSaved: (val) =>
                        setState(() => widget.paymentGateway.methodDescription = val),
                  ),*/
                  SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(AppLocalizations.of(context).translate("enabled")),
                    value: widget.paymentGateway.enabled,
                    onChanged: (bool value) {
                      setState(() {
                        widget.paymentGateway.enabled = value;
                      });
                    },
                  ),
                  //Divider(color: Colors.red,indent:5.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: AccentButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            widget.paymentGatewaysBloc.editItem(widget.paymentGateway);

                          }
                          Navigator.pop(context);
                        },
                        text: AppLocalizations.of(context).translate("submit"),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      // ],
      // ),
      // ),
    );
  }
}
