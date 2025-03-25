import 'package:admin/src/blocs/customers/customer_bloc.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:admin/src/models/country_model.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/resources/countires.dart';
import 'package:admin/src/ui/language/app_localizations.dart';

class EditCustomer extends StatefulWidget {
  final Customer customer;
  final CustomerBloc customersBloc;
   EditCustomer({Key? key, required this.customer, required this.customersBloc});

  @override
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  CountryModel? billingCountry;
  CountryModel? shippingCountry;
  List<CountryModel> countries = countryModelFromJson(JsonStrings.listOfSimpleObjects);
  final billing = Address.fromJson({});
  final shipping = Address.fromJson({});
  
  final _formKey = GlobalKey<FormState>();


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("edit_customer")),
      ),
      body:
    // SingleChildScrollView(
       // child: Stack(
         // children: <Widget>[
            SafeArea(
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
                          initialValue: widget.customer.username,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).translate("username"),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context).translate("please_enter_username");
                            }
                          },
                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.username = val);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.email,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("email")),
                          /*validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context).translate("please_enter_email");
                            }
                          },*/
                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.email = val);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.billing.phone,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("phonenumber")),
                         /* validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context).translate("please_enter_phone_number");
                            }
                          },

                          */
                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.billing.phone = val);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.firstName,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("firstname")),
                          /*validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context).translate("please_enter_first_name");
                            }
                          },*/
                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.firstName = val);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.lastName,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("lastname")),
                          /*validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context).translate("please_enter_last_name");
                            }
                          },*/
                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.lastName = val);
                            }
                          },
                        ),


                        //Divider(color: Colors.red,indent:5.0,),
                        SizedBox(
                          height: 15.0,
                        ),

                          Text(AppLocalizations.of(context).translate("billing_details"),style: TextStyle(fontSize: 20.0),),

                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.billing.firstName,
                          decoration:
                              InputDecoration(labelText: AppLocalizations.of(context).translate("billing_first_name")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.billing.firstName = val);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.billing.lastName,
                          decoration:
                              InputDecoration(labelText: AppLocalizations.of(context).translate("billing_last_name")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.billing.lastName = val);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.billing.company,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("company")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.billing.company = val);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.billing.address1,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("address1")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.billing.address1 = val);
                            }
                          },
                        ),

                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.billing.address2,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("address2")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.billing.address2 = val);
                            }
                          },
                        ),

                        SizedBox(height: 16),
                    TextFormField(
                          initialValue:  widget.customer.billing.city,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("city")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.billing.city = val);
                            }
                          },
                        ),




                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.billing.email,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("email")),
                          /*validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context).translate("please_enter_email");
                            }
                          },*/
                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.billing.email = val);
                            }
                          },
                        ),


                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.billing.phone,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("phonenumber")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.billing.phone = val);
                            }
                          },
                        ),



                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.billing.postcode,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("postcode")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.billing.postcode = val);
                            }
                          },
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(AppLocalizations.of(context).translate("country")),
                            CountryCodePicker(
                              onChanged: onBillingCountryChange,
                              initialSelection: widget.customersBloc.initialSelectedCountry,
                              favorite: ['+1', widget.customer.billing.country ?? "IN"],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: true,
                              alignLeft: false,
                            ),
                          ],
                        ),


                        billingCountry!.regions.length > 0 ? Column(
                          children: <Widget>[
                            SizedBox(height: 5.0,),
                            DropdownButtonFormField<String>(
                              value:  billing.state,
                              hint: Text(AppLocalizations.of(context).translate("state")),
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 0,
                              onChanged: (String? newValue) {
                                if(newValue != null) {
                                  setState(() {
                                    billing.state = newValue;
                                  });
                                }
                              },
                              items: billingCountry!.regions.map<DropdownMenuItem<String>>((Region value) {
                                return DropdownMenuItem<String>(
                                  value: value.value,
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
                          initialValue: billing.state,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("state")),

                          onSaved: (val) =>
                              setState(() => billing..state = val),
                        ),


                        SizedBox(
                          height: 15.0,
                        ),

                        Text(AppLocalizations.of(context).translate("shipping_details:"),style: TextStyle(fontSize: 20.0),),

                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.shipping.firstName,
                          decoration:
                          InputDecoration(labelText: AppLocalizations.of(context).translate("shipping_first_name")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.shipping.firstName = val);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.shipping.lastName,
                          decoration:
                          InputDecoration(labelText: AppLocalizations.of(context).translate("shipping_last_name")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.shipping.lastName = val);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.shipping.company,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("company")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.shipping.company = val);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.shipping.address1,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("address1")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.shipping.address1 = val);
                            }
                          },
                        ),

                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.shipping.address2,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("address2")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.shipping.address2 = val);
                            }
                          },
                        ),

                        SizedBox(height: 16),
                    TextFormField(
                          initialValue:  widget.customer.shipping.city,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("city")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.shipping.city = val);
                            }
                          },
                        ),


                        SizedBox(height: 16),
                    TextFormField(
                          initialValue: widget.customer.shipping.postcode,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("postcode")),

                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.customer.shipping.postcode = val);
                            }
                          },
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(AppLocalizations.of(context).translate("country")),
                            CountryCodePicker(
                              dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              onChanged: onShippingCountryChange,
                              initialSelection: widget.customersBloc.initialSelectedCountry,
                              favorite: ['+1', widget.customer.billing.country ?? "IN"],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: true,
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

                          onSaved: (val) =>
                              setState(() => shipping.state = val),
                        ),




                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: AccentButton(
                              onPressed: () {
                                //print(_formKey.currentState!.validate());
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  widget.customer.billing = billing;
                                  widget.customer.shipping = shipping;
                                  widget.customersBloc.editItem(widget.customer);
                                  Navigator.pop(context);
                                  //String user = json.encode(_widget.customer.toJson());
                                  
                                  //_showDialog(context);
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
            ),
         // ],
       // ),
     // ),
    );
  }

  void onBillingCountryChange(CountryCode? countryCode) {
    if(countryCode?.code != null) {
      billing.country = countryCode!.code!;
      billingCountry = countries.singleWhere((item) => item.value == countryCode.code);
      if(shippingCountry!.regions.length > 0)
        billing.state = billingCountry!.regions.first.value;
      else billing.state = '';
      setState(() {
        billing.country;
        billing.state;
      });
    }
  }


  void onShippingCountryChange(CountryCode? countryCode) {
    if(countryCode?.code != null) {
      shipping.country = countryCode!.code!;
      shippingCountry = countries.singleWhere((item) => item.value == countryCode.code);
      if(shippingCountry!.regions.length > 0)
        shipping.state = shippingCountry!.regions.first.value;
      else billing.state = '';
      setState(() {
        shipping.country;
        shipping.state;
      });
    }
  }
}
