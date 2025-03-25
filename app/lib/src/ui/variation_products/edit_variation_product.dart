import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/models/product/product_variation_model.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/blocs/products/variation_product_bloc_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:intl/intl.dart';

class EditVariationProduct extends StatefulWidget {
  VariationProductBloc variationProductBloc;
  VendorProduct product;
  final ProductVariation variationProduct;

  EditVariationProduct({Key? key, required this.variationProductBloc, required this.product, required this.variationProduct}) : super(key: key);
  @override
  _EditVariationProductState createState() => _EditVariationProductState();
}

class _EditVariationProductState extends State<EditVariationProduct> {

  AppStateModel _appStateModel = AppStateModel();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.variationProduct.attributes == null) widget.variationProduct.attributes = [];

  }

  void handlestockStatusValueChanged(String? value) {
    if(value != null) {
      setState(() {
        widget.variationProduct.stockStatus = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("edit_variation"),),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  widget.variationProductBloc.deleteVariationProduct(
                      widget.product.id, widget.variationProduct.id);
                  Navigator.of(context).pop();
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(slivers: _buildList()),
        ));
  }

  _buildList() {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 3, name: _appStateModel.selectedCurrency);
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
          if (widget.variationProduct.attributes
              .any((item) => item.name == attribute.name)) {
            selected = widget.variationProduct.attributes
                .singleWhere((item) => item.name == attribute.name)
                .option;
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

                    if (widget.variationProduct.attributes
                        .any((item) => item.id == attribute.id)) {
                      setState(() {
                        widget.variationProduct.attributes
                            .removeWhere((item) => item.id == attribute.id);
                      });
                      setState(() {
                        widget.variationProduct.attributes.add(
                            variationAttribute);
                      });
                    } else {
                      setState(() {
                        widget.variationProduct.attributes.add(
                            variationAttribute);
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
                initialValue: widget.variationProduct.sku,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate("sku")
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).translate(
                        "please_enter_product_sku");
                  }
                },
                onSaved: (val) {
                  if(val != null) {
                    setState(() => widget.variationProduct.sku = val);
                  }
                },
              ),
              SizedBox(height: 16),
                    TextFormField(
                initialValue: widget.variationProduct.description,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate(
                        "description")),
                onSaved: (val) {
                  if(val != null) {
                    setState(() => widget.variationProduct.description = val);
                  }
                },
              ),
              SizedBox(height: 16),
                    TextFormField(
                initialValue: widget.variationProduct.regularPrice,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate(
                        "regular_price")),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).translate(
                        "please_enter_regular_price");
                  }
                },
                onSaved: (val) {
                  if(val != null) {
                    setState(() => widget.variationProduct.regularPrice = val);
                  }
                },
              ),
              SizedBox(height: 16),
                    TextFormField(
                initialValue: widget.variationProduct.salePrice,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate(
                        "sale_price")),
                /*validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).translate(
                        "please_enter_sale_price");
                  }
                },*/
                onSaved: (val) {
                  if(val != null) {
                    setState(() => widget.variationProduct.salePrice = val);
                  }
                },
              ),


              const SizedBox(height: 16.0),
              SwitchListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text('Manage Stock', style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium),
                value: widget.variationProduct.manageStock,
                onChanged: (value) =>
                    setState(() {
                      widget.variationProduct.manageStock = value;
                    }),
              ),

              if(widget.variationProduct.manageStock == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: widget.variationProduct.stockQuantity
                          .toString(),
                      decoration: InputDecoration(
                        labelText: "Stock Quantity",
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (val) {
                        if(val != null) {
                          setState(() =>
                          widget.variationProduct.stockQuantity =
                              int.parse(val));
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
                          groupValue: widget.variationProduct.backorders,
                          onChanged: handlebackOrdersValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("no"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'notify ',
                          groupValue: widget.variationProduct.backorders,
                          onChanged: handlebackOrdersValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("notify"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'yes',
                          groupValue: widget.variationProduct.backorders,
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
                          groupValue: widget.variationProduct.stockStatus,
                          onChanged: handlestockStatusValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("instock"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'outofstock',
                          groupValue: widget.variationProduct.stockStatus,
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
                          groupValue: widget.variationProduct.stockStatus,
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

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: AccentButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        widget.variationProductBloc.editVariationProduct(widget.product
                            .id, widget.variationProduct);

                        Navigator.pop(context);
                      }
                    },
                    text: AppLocalizations.of(context).translate("submit"),
                  ),
                ),
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
        widget.variationProduct.backorders = value;
      });
    }

  }


}

