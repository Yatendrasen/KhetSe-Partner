import 'package:admin/src/ui/custom_card.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:flutter/material.dart';

class SelectProductTaxStatus extends StatefulWidget {
  final VendorProduct product;

  const SelectProductTaxStatus({Key? key, required this.product}) : super(key: key);
  @override
  _SelectProductTaxStatusState createState() => _SelectProductTaxStatusState();
}

class _SelectProductTaxStatusState extends State<SelectProductTaxStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          CustomCard(
            child: RadioListTile<String>(
              title: Text(AppLocalizations.of(context)
                  .translate("taxable"),),
              value: 'taxable',
              groupValue: widget.product.taxStatus,
              onChanged: (value) {
                if(value != null) {
                  setState(() {
                    widget.product.taxStatus = value;
                  });
                }
                Navigator.pop(context);
              }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context)
                    .translate("shipping"),),
                value: 'shipping',
                groupValue: widget.product.taxStatus,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.taxStatus = value;
                    });
                  }
                  Navigator.pop(context);
                }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context)
                    .translate("none"),),
                value: 'none',
                groupValue: widget.product.taxStatus,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.taxStatus = value;
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
