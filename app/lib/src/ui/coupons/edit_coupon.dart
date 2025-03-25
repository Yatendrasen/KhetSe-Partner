import 'package:admin/src/blocs/coupons/coupon_bloc.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/models/coupons/coupons_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';

class EditCoupon extends StatefulWidget {
  final Coupon coupon;
  CouponsBloc couponsBloc = CouponsBloc();
  EditCoupon({Key? key, required this.coupon}) : super(key: key);

  @override
  _EditCouponState createState() => _EditCouponState();
}

class _EditCouponState extends State<EditCoupon> {
 final _formKey = GlobalKey<FormState>();
  bool free_shipping = false;

 void _value1Changed(bool? value) {
   if(value != null) {
     setState(() => free_shipping = value);
   }
 }

  @override
  void initState() {
    super.initState();
    widget.coupon.discountType = 'fixed_cart';
  }

  void handleDiscountTypeValueChanged(String? value) {
    if(value != null) {
      setState(() {
        widget.coupon.discountType = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("edit_coupons")),
      ),
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 16),
                    TextFormField(
                    initialValue: widget.coupon.code,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("coupon_code"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return  AppLocalizations.of(context).translate("please_enter_coupon_code");
                      }
                    },
                    onSaved: (val) {
                      if(val != null) {
                        setState(() => widget.coupon.code = val);
                      }
                    },
                  ),
                  SizedBox(height: 16),
                    TextFormField(
                    initialValue: widget.coupon.description,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("coupon_description"),
                    ),
                    onSaved: (val) {
                      if(val != null) {
                        setState(() => widget.coupon.description = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Text(AppLocalizations.of(context).translate("coupon_data")),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: AppLocalizations.of(context).translate("percent"),
                        groupValue: widget.coupon.discountType,
                        onChanged: handleDiscountTypeValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("percent"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                     Radio<String>(
                        value: AppLocalizations.of(context).translate("fixed_cart"),
                        groupValue: widget.coupon.discountType,
                        onChanged: handleDiscountTypeValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("fixed_cart"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: AppLocalizations.of(context).translate("fixed_product"),
                        groupValue: widget.coupon.discountType,
                        onChanged: handleDiscountTypeValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("fixed_product"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                    TextFormField(
                    initialValue: widget.coupon.amount,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("coupon_amount"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return  AppLocalizations.of(context).translate("please_enter_coupon_amount");
                      }
                    },
                    onSaved: (val) {
                      if(val != null) {
                        setState(() => widget.coupon.amount = val);
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(AppLocalizations.of(context).translate("allow_free_shipping")),
                  new Row(children: <Widget>[
                    Text(AppLocalizations.of(context).translate("check_the_box_to_allow_free_shipping")),
                    new Checkbox(
                        value: free_shipping, onChanged: _value1Changed),
                  ]),

                  SizedBox(
                    height: 16.0,
                  ),
                  Text(AppLocalizations.of(context).translate("usage_limits")),
                  SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("usage_limit_per_coupon"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).translate("please_enter_usage_limit");
                      }
                    },
                    onSaved: (val) => setState(() => widget.coupon.usageLimit),
                  ),
                  SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("usage_limit_per_user"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).translate("please_enter_usage_limit");
                      }
                    },
                    onSaved: (val) => setState(() => widget.coupon.usageLimitPerUser),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: AccentButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            widget.couponsBloc.editItem(widget.coupon);
                          }
                          Navigator.pop(context);
                        },
                        text: AppLocalizations.of(context).translate("submit"),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      )),
    );
  }
}

