import 'package:admin/src/ui/custom_card.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:flutter/material.dart';

class SelectProductCatalogVisibility extends StatefulWidget {
  final VendorProduct product;

  const SelectProductCatalogVisibility({Key? key, required this.product}) : super(key: key);
  @override
  _SelectProductCatalogVisibilityState createState() => _SelectProductCatalogVisibilityState();
}

class _SelectProductCatalogVisibilityState extends State<SelectProductCatalogVisibility> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          CustomCard(
            child: RadioListTile<String>(
              title: Text(AppLocalizations.of(context).translate("visible")),
              value: 'visible',
              groupValue: widget.product.catalogVisibility,
              onChanged: (value) {
                if(value != null) {
                  setState(() {
                    widget.product.catalogVisibility = value;
                  });
                }
                Navigator.pop(context);
              }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("catalog")),
                value: 'catalog',
                groupValue: widget.product.catalogVisibility,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.catalogVisibility = value;
                    });
                  }
                  Navigator.pop(context);
                }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("search")),
                value: 'search',
                groupValue: widget.product.catalogVisibility,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.catalogVisibility = value;
                    });
                  }
                  Navigator.pop(context);
                }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("hidden")),
                value: 'hidden',
                groupValue: widget.product.catalogVisibility,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.catalogVisibility = value;
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
