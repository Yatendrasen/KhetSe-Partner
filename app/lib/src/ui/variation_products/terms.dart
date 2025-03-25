
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../models/product/product_variation_model.dart';
import '../../blocs/products/attribute_bloc.dart';
import '../../blocs/products/vendor_bloc.dart';
import '../../models/product/product_attribute_model.dart';

class TermsPage extends StatefulWidget {
  AttributeBloc attributeBloc;
  ProductAttribute productAttribute;
  ProductVariation variationProduct;

  TermsPage(
      {Key? key,
      required this.productAttribute,
        required this.variationProduct,
        required this.attributeBloc})
      : super(key: key);
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
   // if (widget.variationProduct.attributes == null)
   //   widget.variationProduct.attributes = [];
    widget.attributeBloc.fetchAllTerms(widget.productAttribute.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)
              .translate("variation_options"),),
        ),
        body: StreamBuilder<List<AttributeTerms>>(
            stream: widget.attributeBloc.allTerms,
            builder: (context, snapshot) {
              return snapshot.hasData && snapshot.data != null
                  ? ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext ctxt, int index) =>
                          buildBody(ctxt, snapshot.data![index]))
                  : Center(child: CircularProgressIndicator());
            }));
  }

  buildBody(BuildContext ctxt, AttributeTerms attributesTerm) {
    return ListTile(
      onTap: () => _onAttributesTermsTap(attributesTerm),
      title: Text(attributesTerm.name),
      trailing: Checkbox(
        value: widget.variationProduct.attributes != null &&
            widget.variationProduct.attributes
                .any((item) => item.option == attributesTerm.name),
        onChanged: (bool? value) {
          setState(() {
            //monVal = value;
          });
        },
      ),
    );
  }

  _onAttributesTermsTap(AttributeTerms term) {
    VariationAttribute attribute = new VariationAttribute(
      id: widget.productAttribute.id,
      name: widget.productAttribute.name,
      option: term.name
    );
    if (!widget.variationProduct.attributes
        .any((item) => item.option == term.name)) {
      setState(() {
        widget.variationProduct.attributes.add(attribute);
      });
    } else {
      setState(() {
        widget.variationProduct.attributes
            .removeWhere((item) => item.option == term.name);
      });
    }
  }
}
