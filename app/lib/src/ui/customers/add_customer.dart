import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:admin/src/ui/customers/select_country.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:admin/src/models/country_model.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/resources/countires.dart';
import 'package:admin/src/ui/category/filter_category.dart';
import 'package:admin/src/ui/language/app_localizations.dart';

class AddCustomer extends StatefulWidget {
  final CustomerBloc customersBloc;
  AddCustomer({Key? key, required this.customersBloc});
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  CountryModel? billingCountry;
  CountryModel? shippingCountry;
  List<CountryModel> countries = countryModelFromJson(JsonStrings.listOfSimpleObjects);

  final _formKey = GlobalKey<FormState>();
  final _customer = Customer.fromJson({});
  final billing = Address.fromJson({});
  final shipping = Address.fromJson({});

  @override
  void initState() {
    super.initState();
    billing.country =  widget.customersBloc.initialSelectedCountry;
    shipping.country =  widget.customersBloc.initialSelectedCountry;
    billing.state =  'AB';
    shipping.state =  'AB';
    billingCountry = countries.singleWhere((item) => item.value == widget.customersBloc.initialSelectedCountry);
    shippingCountry = countries.singleWhere((item) => item.value == widget.customersBloc.initialSelectedCountry);
  }

  void handleRoleValueChanged(String value) {
    setState(() {
      _customer.role = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).translate("add_customer"))),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 16),
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
                    ),
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
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("firstname")),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).translate("please_enter_first_name");
                        }
                      },
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => _customer.firstName = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("lastname")),
                      /*validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).translate("please_enter_last_name");
                        }
                      },*/
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => _customer.lastName = val);
                        }
                      },
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("billing_details"),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: billing.firstName,
                      decoration:
                          InputDecoration(labelText: AppLocalizations.of(context).translate("billing_first_name"),),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => billing.firstName = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: billing.lastName,
                      decoration:
                          InputDecoration(labelText: AppLocalizations.of(context).translate("billing_last_name"),),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => billing.lastName = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: billing.phone,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("phonenumber")),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => billing.phone = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: billing.company,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("company"),),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => billing.company = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: billing.address1,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("address1"),),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => billing.address1 = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: billing.address2,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("address2"),),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => billing.address2 = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: billing.city,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("city"),),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => billing.city = val);
                        }
                      },
                    ),



                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: billing.postcode,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("postcode")),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => billing.postcode = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(AppLocalizations.of(context).translate("country")),
                        CountryCodePicker(
                          dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          onChanged: onBillingCountryChange,
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: widget.customersBloc.initialSelectedCountry,
                          favorite: ['+1', widget.customersBloc.initialSelectedCountry],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: true,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ),
                      ],
                    ),

                    billingCountry!.regions.length > 0 ? Column(
                      children: <Widget>[
                        SizedBox(height: 5.0,),
                        DropdownButtonFormField<String>(
                          value: billing.state,
                          hint: Text(AppLocalizations.of(context).translate("state"),),
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 0,
                          onChanged: (String? newValue) {
                            setState(() {
                              billing.state = newValue;
                            });
                          },
                          items: billingCountry!.regions.map<DropdownMenuItem<String>>((Region value) {
                            return DropdownMenuItem<String>(
                              value: value.value != null ? value.value : '',
                              child: Text(value.label),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16.0,),
                        //  ),
                      ],
                    ) :



                    SizedBox(height: 16),
                    TextFormField(
                      initialValue:  billing.state,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("state"),),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).translate("please_enter_state");
                        }
                      },
                      onSaved: (val) =>
                          setState(() =>  billing.state = val),
                    ),

                    const SizedBox(
                      height: 24.0,
                    ),
                    Text(
                        AppLocalizations.of(context).translate("shipping_details"),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: billing.firstName,
                      decoration:
                          InputDecoration(labelText: AppLocalizations.of(context).translate("shipping_first_name")),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => shipping.firstName = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: shipping.lastName,
                      decoration:
                          InputDecoration(labelText: AppLocalizations.of(context).translate("shipping_last_name")),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => shipping.lastName = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: shipping.company,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("company")),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => shipping.company = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: shipping.address1,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("address1")),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => shipping.address1 = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: shipping.address2,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("address2")),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => shipping.address2 = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: shipping.city,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("city")),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => shipping.city = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: shipping.postcode,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("postcode")),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => shipping.postcode = val);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(AppLocalizations.of(context).translate("country")),
                        CountryCodePicker(
                          dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          onChanged: onShippingCountryChange,
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: widget.customersBloc.initialSelectedCountry,
                          favorite: ['+1', widget.customersBloc.initialSelectedCountry],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: true,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ),
                      ],
                    ),

                    shippingCountry!.regions.length > 0 ? Column(
                      children: <Widget>[
                        SizedBox(height: 5.0,),
                        DropdownButtonFormField<String>(
                          value: shipping.state,
                          hint: Text(AppLocalizations.of(context).translate("state")),
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 0,
                          onChanged: (String? newValue) {
                            setState(() {
                              shipping.state = newValue;
                            });
                          },
                          items: shippingCountry!.regions.map<DropdownMenuItem<String>>((Region value) {
                            return DropdownMenuItem<String>(
                              value: value.value != null ? value.value : '',
                              child: Text(value.label),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16.0,),
                        //  ),
                      ],
                    ) :

                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: shipping.state,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("state")),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).translate("please_enter_state");
                        }
                      },
                      onSaved: (val) =>
                          setState(() => shipping.state = val),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: AccentButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              billing.email = _customer.email;
                              shipping.email = _customer.email;
                              _customer.billing = billing;
                              _customer.shipping = shipping;
                              await widget.customersBloc.addItem(_customer);
                              widget.customersBloc.fetchItems();
                              //String user = json.encode(_customer.toJson());
                              
                              //_showDialog(context);
                              Navigator.pop(context, DismissDialogAction.save);
                            }
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
        ));
  }

  void onShippingCountryChange(CountryCode countryCode) {
    shipping.country = countryCode.code;
    shippingCountry = countries.singleWhere((item) => item.value == countryCode.code);
    if(shippingCountry!.regions.length > 0)
      shipping.state = shippingCountry!.regions.first.value;
    else shipping.state = '';
    setState(() {
      shipping.country;
      shipping.state;
      shippingCountry;
    });
  }

  void onBillingCountryChange(CountryCode countryCode) {
    billing.country = countryCode.code;
    billingCountry = countries.singleWhere((item) => item.value == countryCode.code);
    if(billingCountry!.regions.length > 0)
    billing.state = billingCountry!.regions.first.value;
    else billing.state = '';
    setState(() {
      billing.country;
      billing.state;
      billingCountry;
    });
  }
}
