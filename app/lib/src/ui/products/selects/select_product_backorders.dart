import 'package:admin/src/ui/custom_card.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:flutter/material.dart';

class SelectProductBackorder extends StatefulWidget {
  final VendorProduct product;

  const SelectProductBackorder({Key? key, required this.product}) : super(key: key);
  @override
  _SelectProductBackorderState createState() => _SelectProductBackorderState();
}

class _SelectProductBackorderState extends State<SelectProductBackorder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          CustomCard(
            child: RadioListTile<String>(
              title: Text(AppLocalizations.of(context).translate("no")),
              value: 'no',
              groupValue: widget.product.backOrders,
              onChanged: (value) {
                if(value != null) {
                  setState(() {
                    widget.product.backOrders = value;
                  });
                }
                Navigator.pop(context);
              }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("yes")),
                value: 'yes',
                groupValue: widget.product.backOrders,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.backOrders = value;
                    });
                  }
                  Navigator.pop(context);
                }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("notify")),
                value: 'notify',
                groupValue: widget.product.backOrders,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.backOrders = value;
                    });
                  }
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }
}
