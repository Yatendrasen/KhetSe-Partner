import 'package:admin/src/blocs/products/attribute_terms_bloc.dart';
import 'package:admin/src/ui/orders/custom_card.dart';
import 'package:flutter/material.dart';
import '../../models/product/vendor_product_model.dart';
import '../../models/product/product_attribute_model.dart';

class AttributeOptionsPage extends StatefulWidget {
  AttributeTermBloc attributeTermBloc = AttributeTermBloc();
  ProductAttribute productAttribute;
  VendorProduct product;

  AttributeOptionsPage(
      {Key? key,
      required this.productAttribute,
        required this.product})
      : super(key: key);
  @override
  _AttributeOptionsPageState createState() => _AttributeOptionsPageState();
}

class _AttributeOptionsPageState extends State<AttributeOptionsPage> {

  @override
  void initState() {
    super.initState();
    widget.attributeTermBloc.fetchAllTerms(widget.productAttribute.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.productAttribute.name),
        ),
        body: StreamBuilder<List<AttributeTerms>>(
            stream: widget.attributeTermBloc.allTerms,
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
    var contains = false;

    if(widget.product.attributes.any((item) => item.id == widget.productAttribute.id)) {
      if(widget.product.attributes.singleWhere((item) => item.id == widget.productAttribute.id).options.contains(attributesTerm.name)) {
        contains = true;
      }
    }
    return CustomCard(
      child: CheckboxListTile(
          value: contains,
          onChanged: (value) => _onAttributesTermsTap(attributesTerm),
          title: Text(attributesTerm.name),
      ),
    );/*ListTile(
      onTap: () => _onAttributesTermsTap(attributesTerm),
      title: Text(attributesTerm.name),
      trailing: Checkbox(
        value: contains,
        onChanged: (bool value) =>
          _onAttributesTermsTap(attributesTerm),
      ),
    );*/
  }

  _onAttributesTermsTap(AttributeTerms term) {

    if(widget.product.attributes.any((item) => item.id == widget.productAttribute.id)) {
      if(widget.product.attributes.singleWhere((item) => item.id == widget.productAttribute.id).options.contains(term.name)) {
        setState(() {
          widget.product.attributes.singleWhere((item) => item.id == widget.productAttribute.id).options.remove(term.name);
        });
      } else {
        setState(() {
          widget.product.attributes.singleWhere((item) => item.id == widget.productAttribute.id).options.add(term.name);
        });
      }
    } else {
      Attribute attribute = Attribute(
          options: [],
          id: widget.productAttribute.id,
          name: widget.productAttribute.name,
          variation: false,
          position: 0,
          visible: true
      );
      attribute.options.add(term.name);
      setState(() {
        widget.product.attributes.add(attribute);
      });
    }
  }
}
