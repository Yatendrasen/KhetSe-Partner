import 'package:admin/src/ui/custom_card.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:flutter/material.dart';

class SelectProductType extends StatefulWidget {
  final VendorProduct product;
  const SelectProductType({Key? key, required this.product}) : super(key: key);
  @override
  _SelectProductTypeState createState() => _SelectProductTypeState();
}

class _SelectProductTypeState extends State<SelectProductType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          CustomCard(
            child: RadioListTile<String>(
              title: Text(AppLocalizations.of(context).translate("simple")),
              value: 'simple',
              groupValue: widget.product.type,
              onChanged: (value) {
                if(value != null) {
                  setState(() {
                    widget.product.type = value;
                  });
                }
                Navigator.pop(context);
              }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("grouped")),
                value: 'grouped',
                groupValue: widget.product.type,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.type = value;
                    });
                  }
                  Navigator.pop(context);
                }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("external")),
                value: 'external',
                groupValue: widget.product.type,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.type = value;
                    });
                  }
                  Navigator.pop(context);
                }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("variable")),
                value: 'variable',
                groupValue: widget.product.type,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.type = value;
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
