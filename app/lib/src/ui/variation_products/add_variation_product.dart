import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/blocs/products/variation_product_bloc_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/models/product/product_model.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import '../../blocs/products/vendor_bloc.dart';
import '../button_text.dart';
import '../../models/product/product_attribute_model.dart';
import '../../models/product/product_variation_model.dart';
import '../../models/product/vendor_product_model.dart';

class AddVariations extends StatefulWidget {
  VariationProductBloc variationProductBloc;
  VendorProduct product;

  AddVariations({Key? key, required this.variationProductBloc, required this.product}) : super(key: key);
  @override
  _AddVariationsState createState() => _AddVariationsState();
}

class _AddVariationsState extends State<AddVariations> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  ProductVariation variationProduct = ProductVariation.fromJson({});
  ProductAttribute attribute = ProductAttribute.fromJson({});


  @override
  void initState() {
    super.initState();
    if (variationProduct.attributes == null) variationProduct.attributes = [];

  }

  void handlestockStatusValueChanged(String? value) {
    if(value != null) {
      setState(() {
        variationProduct.stockStatus = value;
      });
    }
  }


  void handleStatusTypeValueChanged(String? value) {
    if(value != null) {
      setState(() {
        variationProduct.status = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("add_variation")),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(slivers: _buildList()),
        ));
  }

  _buildList() {
    List<Widget> list = [];
    bool hasAttributes = false;
    widget.product.attributes.forEach((attribute) {
      if(attribute.options.length > 0 && attribute.variation == true) {
        hasAttributes = true;
      };
    });

    if(hasAttributes) {
      widget.product.attributes.forEach((attribute) {
          String selected = attribute.options.first;
          if (variationProduct.attributes
              .any((item) => item.name == attribute.name)) {
            selected = variationProduct.attributes
                .singleWhere((item) => item.name == attribute.name)
                .option;
          } else {
            VariationAttribute variationAttribute =
            new VariationAttribute(
                id: attribute.id,
                name: attribute.name,
                option: selected
            );
            variationProduct.attributes.add(variationAttribute);
          }
          list.add(SliverToBoxAdapter(
            child: Container(
              child: Text(attribute.name,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium),
            ),
          ));
          list.add(
            SliverToBoxAdapter(
              child: DropdownButtonFormField<String>(
                value: selected,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 25,
                elevation: 16,
                onChanged: (String? newValue) {
                  if(newValue != null) {
                    VariationAttribute variationAttribute =
                    new VariationAttribute(
                        id: attribute.id,
                        name: attribute.name,
                        option: newValue
                    );
                    if (variationProduct.attributes
                        .any((item) => item.id == attribute.id)) {
                      setState(() {
                        variationProduct.attributes
                            .removeWhere((item) => item.id == attribute.id);
                      });
                      setState(() {
                        variationProduct.attributes.add(variationAttribute);
                      });
                    } else {
                      setState(() {
                        variationProduct.attributes.add(variationAttribute);
                      });
                    }
                  }

                },
                items: attribute.options
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          );
      });
      list.add(SliverToBoxAdapter(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              SizedBox(height: 16),
                    TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).translate("sku"),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).translate(
                        "please_enter_product_sku");
                  }
                },
                onSaved: (val) => setState(() => variationProduct.sku = val),
              ),


              SizedBox(height: 16),
                    TextFormField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate(
                        "description")),
                onSaved: (val) {
                  if(val != null) {
                    setState(() => variationProduct.description = val);
                  }
                },
              ),
              SizedBox(height: 16),
                    TextFormField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate(
                        "regular_price")),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).translate(
                        "please_enter_regular_price");
                  }
                },
                onSaved: (val) =>
                    setState(() => variationProduct.regularPrice = val),
              ),
              SizedBox(height: 16),
                    TextFormField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate(
                        "sale_price")),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).translate(
                        "please_enter_sale_price");
                  }
                },
                onSaved: (val) =>
                    setState(() => variationProduct.salePrice = val),
              ),


              const SizedBox(height: 16.0),
              SwitchListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text('Manage Stock', style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium),
                value: variationProduct.manageStock,
                onChanged: (value) =>
                    setState(() {
                      variationProduct.manageStock = value;
                    }),
              ),

              if(variationProduct.manageStock == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: variationProduct.stockQuantity.toString(),
                      decoration: InputDecoration(
                        labelText: "Stock Quantity",
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (val) {
                        if(val != null) {
                          setState(() =>
                          variationProduct.stockQuantity = int.parse(val));
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Text(AppLocalizations.of(context).translate("back_orders"),
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'no',
                          groupValue: variationProduct.backorders,
                          onChanged: handlebackOrdersValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("no"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'notify ',
                          groupValue: variationProduct.backorders,
                          onChanged: handlebackOrdersValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("notify"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'yes',
                          groupValue: variationProduct.backorders,
                          onChanged: handlebackOrdersValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("yes"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    Text(AppLocalizations.of(context).translate("stock_status"),
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'instock',
                          groupValue: variationProduct.stockStatus,
                          onChanged: handlestockStatusValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("instock"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'outofstock',
                          groupValue: variationProduct.stockStatus,
                          onChanged: handlestockStatusValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("outof_stock"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'onbackorder',
                          groupValue: variationProduct.stockStatus,
                          onChanged: handlestockStatusValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("onbackorder"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() { isLoading = true; });
                    ProductVariation productVariation = await widget.variationProductBloc.addVariationProduct(widget.product.id, variationProduct);
                    widget.product.variations.add(productVariation);
                    setState(() { isLoading = false; });
                    Navigator.of(context).pop();
                  }
                },
                child: ButtonText(text: "Submit", isLoading: isLoading),
              ),

            ],
          ),
        ),
      ));
    }
    return list;
  }

  void handlebackOrdersValueChanged(String? value) {
    if(value != null) {
      setState(() {
        widget.product.backOrders = value;
      });
    }
  }

}