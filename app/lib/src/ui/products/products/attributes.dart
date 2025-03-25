import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/orders/custom_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../blocs/products/attribute_bloc.dart';
import '../../../blocs/products/vendor_bloc.dart';
import '../../../models/product/product_attribute_model.dart';
import '../../../models/product/vendor_product_model.dart';
import '../terms.dart';

class SelectAttributes extends StatefulWidget {
  final VendorBloc vendorBloc;
  final VendorProduct product;
  AttributeBloc attributeBloc = AttributeBloc();

  SelectAttributes({Key? key, required this.vendorBloc, required this.product}) : super(key: key);
  @override
  _SelectAttributesState createState() => _SelectAttributesState();
}

class _SelectAttributesState extends State<SelectAttributes> {

  @override
  void initState() {
    super.initState();
    if(widget.product.attributes == null)
      widget.product.attributes = [];
    widget.attributeBloc.fetchAllAttributes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("attributes"),),
        ),
        body: StreamBuilder<List<ProductAttribute>>(
            stream: widget.attributeBloc.allAttribute,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return CustomScrollView(slivers: _buildList(snapshot));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  buildBody(BuildContext ctxt, ProductAttribute productAttribute) {
    String option = '';
    widget.product.attributes.forEach((value) {
      if(value.id == productAttribute.id)
      value.options.forEach((name) =>
        option = option.isEmpty ? name : option + ', ' + name
      );
    });

    if(widget.product.attributes.any((element) => element.id == productAttribute.id)) {

    }

    return CustomCard(
      child: Column(
        children: [
          ListTile(
            onTap: () async {
              final data = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AttributeOptionsPage(
                          product: widget.product,
                          productAttribute: productAttribute)));
              setState(() => widget.product);
            },
            title: Text(productAttribute.name),
            subtitle: option.isNotEmpty
                ? Text(option, maxLines: 3, overflow: TextOverflow.ellipsis)
                : null,
            trailing: Icon(CupertinoIcons.forward),
          ),
          widget.product.attributes.any((element) => element.id == productAttribute.id) && widget.product.attributes.firstWhere((element) => element.id == productAttribute.id).variation != null ? SwitchListTile(
              title: Text(AppLocalizations.of(context)
        .translate("used_for_variations"),),
              value: widget.product.attributes.firstWhere((element) => element.id == productAttribute.id).variation,
              onChanged: (value) {
                  setState(() {
                    widget.product.attributes.singleWhere((element) => element.id == productAttribute.id).variation = value;
                  });
              }) : Container()
        ],
      ),
    );
  }

  _buildList(AsyncSnapshot<List<ProductAttribute>> snapshot) {
    List<Widget> list = [];
    list.add(
      SliverList(
        //itemExtent: 56, // I'm forcing item heights
        delegate: SliverChildBuilderDelegate(
              (context, index) => buildBody(context, snapshot.data![index]),
          childCount: snapshot.data!.length,
        ),
      ),
    );
    return list;
  }
}
