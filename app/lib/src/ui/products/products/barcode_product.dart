import 'package:admin/src/blocs/products/products_bloc_new.dart';
import 'package:admin/src/models/product/vendor_product_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/products/products/product_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FindBarCodeProduct extends StatefulWidget {
  const FindBarCodeProduct({
    Key? key,
    required this.result,
    required this.context,
  }) : super(key: key);

  final String result;
  final BuildContext context;

  @override
  _FindBarCodeProductState createState() => _FindBarCodeProductState();
}

class _FindBarCodeProductState extends State<FindBarCodeProduct> {
  bool loading = false;
  VendorProduct product = VendorProduct.fromJson({});
  final ProductBloc productBloc = ProductBloc();

  @override
  void initState() {
    _getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (product.name.isNotEmpty) {
      return AlertDialog(
        content: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            width: 60,
            height: 60,
            child: CachedNetworkImage(
              imageUrl: product.images[0].src,
              imageBuilder: (context, imageProvider) => Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Ink.image(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return VendorProductDetail(product: product);
                      }));
                    },
                  ),
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              placeholder: (context, url) => Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.black12,
              ),
            ),
          ),
          title: Text(product.name),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)
                .translate("cancel"),),
            //color: const Color(0xFF1BC0C5),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return VendorProductDetail(product: product);
              }));
            },
            child: Text(AppLocalizations.of(context)
                .translate("view"),),
            //color: const Color(0xFF1BC0C5),
          ),
        ],
      );
    } else {
      return AlertDialog(
        content: loading
            ? Container(
            height: 100, child: Center(child: CircularProgressIndicator()))
            : Text(AppLocalizations.of(context)
            .translate("Product_not_found" + '!'),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)
                .translate("cancel"),),
            //color: const Color(0xFF1BC0C5),
          ),
        ],
      );
    }
  }

  _getProduct() async {
    setState(() {
      loading = true;
    });
    List<VendorProduct> newProduct =
    await productBloc.getProductBySKU(widget.result);
    if (newProduct.length > 0) {
      setState(() {
        product = newProduct[0];
      });
    }
    setState(() {
      loading = false;
    });
  }
}
