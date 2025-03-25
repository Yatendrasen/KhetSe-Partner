import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/country_model.dart';
import 'package:admin/src/models/customer/customer_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/resources/countires.dart';
import 'package:admin/src/ui/color_override.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:admin/src/blocs/products/vendor_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';


class AddCustomer extends StatefulWidget {
  final VendorBloc vendorBloc;
  AddCustomer({Key? key, required this.vendorBloc}) : super(key: key);

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {

  late CountryModel billingCountry;
  late CountryModel shippingCountry;
  List<CountryModel> countries = countryModelFromJson(
      JsonStrings.listOfSimpleObjects);
  final _formKey = GlobalKey<FormState>();
  final billing = Address.fromJson({});
  final shipping = Address.fromJson({});


  @override
  void initState() {
    super.initState();
    billing.country = widget.vendorBloc.initialSelectedCountry;
    shipping.country = widget.vendorBloc.initialSelectedCountry;
    // billing.state =  'AB';
    //  shipping.state =  'AB';
    billingCountry = countries.singleWhere((item) => item.value ==
        widget.vendorBloc.initialSelectedCountry);
    shippingCountry = countries.singleWhere((item) => item.value ==
        widget.vendorBloc.initialSelectedCountry);
  }


  @override
  Widget build(BuildContext context) {
    /*final NumberFormat formatter = NumberFormat.currency(
        locale: Localizations.localeOf(context).toString(),
        name: widget.model.order.currency);*/
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).translate("add_customer")),
      ),

      body:
      SafeArea(
        child: ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
          return ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                SizedBox(height: 10,),
                Text(AppLocalizations.of(context).translate("billing_details"),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.billing.firstName,
                        decoration:
                        InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "billing_firstname"),),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context).translate(
                                "please_enter_first_name");
                          }
                        },
                        onSaved: (val) {
                          if(val != null) {
                            model.order.billing.firstName = val;
                          }
                        },
                      ),
                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.billing.lastName,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "billing_lastname"),),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context).translate(
                                "please_enter_last_name");
                          }
                        },
                        onSaved: (val) {
                          if(val != null) {
                            model.order.billing.lastName = val;
                          }
                        },
                      ),
                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.billing.company,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "company"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.billing.company = val;
                          }
                        },
                      ),
                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.billing.address1,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "address1"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.billing.address1 = val;
                          }
                        },
                      ),

                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.billing.address2,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "address2"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.billing.address2 = val;
                          }
                        },
                      ),

                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.billing.city,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "city"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.billing.city = val;
                          }
                        },
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(AppLocalizations.of(context).translate("country"),),
                          CountryCodePicker(
                            dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            onChanged: onBillingCountryChange,
                            initialSelection: widget.vendorBloc
                                .initialSelectedCountry,
                            favorite: [
                              '+1',
                              widget.vendorBloc.initialSelectedCountry,
                            ],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: true,
                            alignLeft: false,
                          ),
                        ],
                      ),


                      billingCountry.regions.length > 0 ? Column(
                        children: <Widget>[
                          SizedBox(height: 24.0,),
                          DropdownButtonFormField<String>(
                            value: model.order.billing.state,
                            hint: Text(AppLocalizations.of(context).translate(
                                "state"),),
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 0,
                            onChanged: (String? newValue) {
                              if(newValue != null) {
                                setState(() {
                                  model.order.billing.state = newValue;
                                });
                              }
                            },
                            items: billingCountry.regions.map<DropdownMenuItem<
                                String>>((Region value) {
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
                        initialValue: model.order.billing.state,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "state"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.billing.state = val;
                          }
                        },
                      ),


                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.billing.postcode,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "postcode"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.billing.postcode = val;
                          }
                        },
                      ),



                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.billing.email,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "email"),),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context).translate(
                                "please_enter_email");
                          }
                        },
                        onSaved: (val) {
                          if(val != null) {
                            model.order.billing.email = val;
                          }
                        },
                      ),
                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.billing.phone,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "phonenumber"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.billing.phone = val;
                          }
                        },
                      ),

                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        AppLocalizations.of(context).translate("shipping_details"),
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),

                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.shipping.firstName,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "firstname"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.shipping.firstName = val;
                          }
                        },
                      ),
                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.shipping.lastName,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "lastname"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.shipping.lastName = val;
                          }
                        },
                      ),
                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.shipping.company,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "company"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.shipping.company = val;
                          }
                        },
                      ),
                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.shipping.address1,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "address1"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.shipping.address1 = val;
                          }
                        },
                      ),

                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.shipping.address2,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "address2"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.shipping.address2 = val;
                          }
                        },
                      ),

                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.shipping.city,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "city"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.shipping.city = val;
                          }
                        },
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(AppLocalizations.of(context).translate("country"),),
                          CountryCodePicker(
                            dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            onChanged: onShippingCountryChange,
                            initialSelection: widget.vendorBloc
                                .initialSelectedCountry,
                            favorite: [
                              '+1',
                              widget.vendorBloc.initialSelectedCountry,
                            ],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: true,
                            alignLeft: false,
                          ),
                        ],
                      ),

                      shippingCountry.regions.length > 0 ? Column(
                        children: <Widget>[
                          SizedBox(height: 24.0,),
                          DropdownButtonFormField<String>(
                            value: model.order.shipping.state,
                            hint: Text(AppLocalizations.of(context).translate(
                                "state"),),
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 0,
                            onChanged: (String? newValue) {
                              if(newValue != null) {
                                setState(() {
                                  model.order.shipping.state = newValue;
                                });
                              }
                            },
                            items: shippingCountry.regions.map<DropdownMenuItem<
                                String>>((Region value) {
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
                        initialValue: model.order.shipping.state,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "state"),),

                        onSaved: (val) {
                          if(val != null) {
                            model.order.shipping.state = val;
                          }
                        },
                      ),


                      SizedBox(height: 16),
                    TextFormField(
                        initialValue: model.order.shipping.postcode,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate(
                              "postcode"),),


                        onSaved: (val) {
                          if(val != null) {
                            model.order.shipping.postcode = val;
                          }
                        },
                      ),




                      SizedBox(
                        height: 12.0,
                      ),
                     /* Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Text(AppLocalizations.of(context).translate("total"),),

                        Text(formatter.format(double.parse(model.order.total))),

                        ],
                      ),
*/
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: AccentButton(
                              onPressed: () {
                                if (true) {
                                  _formKey.currentState!.save();
                                  model.notifyModelListeners();
                                  //widget.model.order.billing = billing;
                                  //widget.model.order.shipping = shipping;
                                  // shipping.country = '';

                                  Navigator.pop(context);
                                }
                              },
                              text: AppLocalizations.of(context).translate("done"),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        ),
      ),


    );
  }



  void onBillingCountryChange(CountryCode countryCode) {
    billing.country = countryCode.code!;
    billingCountry =
        countries.singleWhere((item) => item.value == countryCode.code);
    if (billingCountry.regions != null)
      billing.state = billingCountry.regions.first.value;
    else
      billing.state = '';
    setState(() {
      billing.country;
      billing.state;
      billingCountry;
    });
  }

  void onShippingCountryChange(CountryCode countryCode) {
    shipping.country = countryCode.code!;
    shippingCountry =
        countries.singleWhere((item) => item.value == countryCode.code);
    if (shippingCountry.regions != null)
      shipping.state = shippingCountry.regions.first.value;
    else
      shipping.state = '';
    setState(() {
      shipping.country;
      shipping.state;
      shippingCountry;
    });
  }

}
