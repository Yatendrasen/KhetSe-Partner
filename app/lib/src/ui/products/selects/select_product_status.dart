import 'package:admin/src/ui/custom_card.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:flutter/material.dart';

class SelectProductStatus extends StatefulWidget {
  final VendorProduct product;

  const SelectProductStatus({Key? key, required this.product}) : super(key: key);
  @override
  _SelectProductStatusState createState() => _SelectProductStatusState();
}

class _SelectProductStatusState extends State<SelectProductStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          CustomCard(
            child: RadioListTile<String>(
              title: Text(AppLocalizations.of(context).translate("publish")),
              value: 'publish',
              groupValue: widget.product.status,
              onChanged: (value) {
                if(value != null) {
                  setState(() {
                    widget.product.status = value;
                  });
                }
                Navigator.pop(context);
              }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("draft")),
                value: 'draft',
                groupValue: widget.product.status,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.status = value;
                    });
                  }
                  Navigator.pop(context);
                }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("pending")),
                value: 'pending',
                groupValue: widget.product.status,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.status = value;
                    });
                  }
                  Navigator.pop(context);
                }),
          ),
          CustomCard(
            child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context).translate("private")),
                value: 'private',
                groupValue: widget.product.status,
                onChanged: (value) {
                  if(value != null) {
                    setState(() {
                      widget.product.status = value;
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
