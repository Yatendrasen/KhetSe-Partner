import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter/material.dart';

class NewsLetter extends StatefulWidget {
  final CustomerBloc customersBloc;

  const NewsLetter({Key? key, required this.customersBloc}) : super(key: key);
  @override
  _NewsLetterState createState() => _NewsLetterState();
}

class _NewsLetterState extends State<NewsLetter> {

  final _formKey = GlobalKey<FormState>();
  final _customer = Customer.fromJson({});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).translate("username"),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).translate("username");
                        }
                      },
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => _customer.username = val);
                        }
                      },
                    ),*/
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("email")),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).translate("please_enter_email");
                      }
                    },
                    onSaved: (val) {
                      if(val != null) {
                        setState(() => _customer.email = val);
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: _customer.billing.phone,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("phonenumber")),
                    onSaved: (val) {
                      if(val != null) {
                        setState(() => _customer.billing.phone = val);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone';
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: AccentButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await widget.customersBloc.addItem(_customer);
                            widget.customersBloc.fetchItems();
                            //String user = json.encode(_customer.toJson());

                            //_showDialog(context);
                            Navigator.of(context).pop();
                          }
                        },
                        text: AppLocalizations.of(context).translate("submit"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
