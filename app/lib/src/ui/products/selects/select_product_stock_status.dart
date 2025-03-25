import 'package:admin/src/ui/custom_card.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:flutter/material.dart';

class SelectProductStockStatus extends StatefulWidget {
  final VendorProduct product;

  const SelectProductStockStatus({Key? key, required this.product}) : super(key: key);
  @override
  _SelectProductStockStatusState createState() => _SelectProductStockStatusState();
}

class _SelectProductStockStatusState extends State<SelectProductStockStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          CustomCard(
            child: RadioListTile<String>(
              title: Text(AppLocalizations.of(context).translate("instock")),
              value: 'instock',
              groupValue: widget.product.stockStatus,
              onChanged: (value) {
                if(value != null) {
                  setState(() {
                    widget.product.stockStatus = value;
                  });
                }
                Navigator.pop(context);
              }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("outof_stock")),
                value: 'outofstock',
                groupValue: widget.product.stockStatus,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.stockStatus = value;
                    });
                  }
                  Navigator.pop(context);
                }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("onbackorder")),
                value: 'onbackorder',
                groupValue: widget.product.stockStatus,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.stockStatus = value;
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
