import 'package:admin/src/blocs/coupons/coupon_bloc.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/models/coupons/coupons_model.dart';
import 'package:intl/intl.dart';
import 'package:admin/src/ui/language/app_localizations.dart';

class AddCoupon extends StatefulWidget {
  CouponsBloc couponsBloc = CouponsBloc();
  @override
  _AddCouponState createState() => _AddCouponState();
}

class _AddCouponState extends State<AddCoupon> {
  final _formKey = GlobalKey<FormState>();
  final coupon = Coupon.fromJson({});
  DateTime _fromDateTime = DateTime.now();
  DateTime _toDateTime = DateTime.now();
  bool _saveNeeded = false;
  bool free_shipping = false;

  @override
  void initState() {
    super.initState();
    coupon.discountType = 'fixed_cart';
  }

  @override
  void dispose() {
    widget.couponsBloc.dispose();
    super.dispose();
  }

  void handleDiscountTypeValueChanged(String? value) {
    if (value != null) {
      setState(() {
        coupon.discountType = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("add_coupons")),
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
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).translate("coupon_code"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate("please_enter_coupon_code");
                      }
                    },
                    onSaved: (val) {
                      if (val != null) {
                        setState(() => coupon.code = val);
                      }
                    },
                  ),
                  SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)
                          .translate("coupon_description"),
                    ),
                    onSaved: (val) {
                      if (val != null) {
                        setState(() => coupon.description = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Text(AppLocalizations.of(context).translate("coupon_data")),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ChoiceChip(
                        label: Text(AppLocalizations.of(context).translate("percent")),
                        selected: coupon.discountType == 'percent',
                        onSelected: (bool selected) {
                          setState(() {
                            coupon.discountType = 'percent';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: Text(AppLocalizations.of(context).translate("fixed_product")),
                        selected: coupon.discountType == 'fixed_product',
                        onSelected: (bool selected) {
                          setState(() {
                            coupon.discountType = 'fixed_product';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: Text(AppLocalizations.of(context).translate("fixed_cart")),
                        selected: coupon.discountType == 'fixed_cart',
                        onSelected: (bool selected) {
                          setState(() {
                            coupon.discountType = 'fixed_cart';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)
                          .translate("coupon_amount"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate("please_enter_coupon_amount");
                      }
                    },
                    onSaved: (val) {
                      if (val != null) {
                        setState(() => coupon.amount = val);
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),

                  new CheckboxListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(AppLocalizations.of(context)
                        .translate("allow_free_shipping")),
                      subtitle: Text(AppLocalizations.of(context)
                          .translate("check_the_box_to_allow_free_shipping")),
                      value: free_shipping,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => free_shipping = val);
                        }
                      }),

                  /* const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Coupon Expiry date'),
                      SizedBox(height: 10.0,),
                      DateTimeItem(
                        dateTime: _fromDateTime,
                        onChanged: (DateTime value) {
                          setState(() {
                            _fromDateTime = value;
                            _saveNeeded = true;
                          });
                        },
                      ),
                    ],
                  ),
*/
                  SizedBox(
                    height: 16.0,
                  ),


                  /*   SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Products',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter product id';
                      }
                    },
                    onSaved: (val) =>
                        setState(() => coupon.productIds),
                  ),*/

                  /* SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Exclude Products',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter product id';
                      }
                    },
                    onSaved: (val) =>
                        setState(() => coupon.excludedProductIds),
                  ),*/

                  /*  SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Product Categories',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter product category';
                      }
                    },
                    onSaved: (val) =>
                        setState(() => coupon.productCategories),
                  ),
                  SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Exclude Categories',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter excluded product category';
                      }
                    },
                    onSaved: (val) =>
                        setState(() => coupon.excludedProductCategories),
                  ),*/

                  /*  SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email Restrictions',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Allowed emails';
                      }
                    },
                    onSaved: (val) =>
                        setState(() => coupon.emailRestrictions),
                  ),*/

                    TextFormField(
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate("usage_limit_per_coupon")),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate("please_enter_usage_limit");
                      }
                    },
                    onSaved: (val) => setState(() => coupon.usageLimit),
                  ),
                  SizedBox(height: 16),
                    TextFormField(
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate("usage_limit_per_user")),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .translate("please_enter_usage_limit_per_user");
                      }
                    },
                    onSaved: (val) => setState(() => coupon.usageLimitPerUser),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: AccentButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await widget.couponsBloc.addItem(coupon);
                            Navigator.pop(context);
                          }
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

class DateTimeItem extends StatelessWidget {
  DateTimeItem({Key? key, required DateTime dateTime, required this.onChanged})
      : assert(onChanged != null),
        date = DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DefaultTextStyle(
      style: theme.textTheme.titleMedium!,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: theme.dividerColor))),
              child: InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: date.subtract(const Duration(days: 3000)),
                    lastDate: date,
                  ).then<void>((DateTime? value) {
                    if (value != null)
                      onChanged(DateTime(value.year, value.month, value.day,
                          time.hour, time.minute));
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(DateFormat('EEE, MMM d yyyy').format(date)),
                    const Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: theme.dividerColor))),
            child: InkWell(
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: time,
                ).then<void>((TimeOfDay? value) {
                  if (value != null)
                    onChanged(DateTime(date.year, date.month, date.day,
                        value.hour, value.minute));
                });
              },
              child: Row(
                children: <Widget>[
                  Text('${time.format(context)}'),
                  const Icon(Icons.arrow_drop_down, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
