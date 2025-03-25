import 'dart:io';
import 'package:admin/src/ui/accounts/login/loading_button.dart';
import 'package:admin/src/ui/custom_card.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/products/selects/select_product_backorders.dart';
import 'package:admin/src/ui/products/selects/select_product_catalog_viisibility.dart';
import 'package:admin/src/ui/products/selects/select_product_status.dart';
import 'package:admin/src/ui/products/selects/select_product_tax_status.dart';
import 'package:admin/src/ui/products/selects/select_product_type.dart';
import 'package:admin/src/ui/products/selects/select_tax_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin/src/resources/api_provider.dart';
import '../../../functions.dart';
import '../../../models/app_state_model.dart';
import '../../../blocs/products/vendor_bloc.dart';
import '../../../models/product/product_variation_model.dart';
import '../../../models/product/vendor_product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../text_editor.dart';
import '../../variation_products/vatiation_product_list.dart';
import 'attributes.dart';
import '../buttons/buttons.dart';
import 'package:intl/intl.dart';

import 'date_time_item.dart';
import 'select_categories.dart';

class EditVendorProduct extends StatefulWidget {
  final VendorBloc vendorBloc;
  final VendorProduct product;


  EditVendorProduct({Key? key, required this.vendorBloc, required this.product}) : super(key: key);
  @override
  _EditVendorProductState createState() => _EditVendorProductState();
}

class _EditVendorProductState extends State<EditVendorProduct> {
  AppStateModel _appStateModel = AppStateModel();
  final _formKey = GlobalKey<FormState>();
  final _apiProvider = ApiProvider();

  bool isImageUploading = false;
  final ImagePicker _picker = ImagePicker();
  PickedFile? imageFile;

  @override
  void initState() {
    super.initState();
  }

  void handleTypeValueChanged(String value) {
    setState(() {
      widget.product.type = value;
    });
  }

  void handleStatusTypeValueChanged(String value) {
    setState(() {
      widget.product.status = value;
    });
  }

  void handlestockStatusValueChanged(String value) {
    setState(() {
      widget.product.stockStatus = value;
    });
  }

  void handlecatalogVisibilityTypeValueChanged(String value) {
    setState(() {
      widget.product.catalogVisibility = value;
    });
  }

  void handlebackOrdersValueChanged(String value) {
    setState(() {
      widget.product.backOrders = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 3, name: _appStateModel.selectedCurrency);
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("edit_product")),
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomCard(
                      child: ListTile(
                        isThreeLine: true,
                        trailing: Icon(Icons.arrow_right_rounded),
                        title: Text(AppLocalizations.of(context).translate("product_name")),
                        subtitle: widget.product.name.isEmpty || widget.product.name == null ? null : Text(parseHtmlString(widget.product.name), maxLines: 2),
                        onTap: () async {
                          String text = await Navigator.push(context, MaterialPageRoute( builder: (context) => TextEditorPage(text: widget.product.name)));
                          if(text != null) {
                            setState(() => widget.product.name = text);
                          }
                        },
                      ),
                    ),
                    CustomCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                /*  RaisedButton(
                                    onPressed: _choose,
                                    child: Text("Choose Image")
                                ),*/
                              ],
                            ),
                            widget.product.images.length >= 0
                                ? GridView.builder(
                                shrinkWrap: true,
                                itemCount: widget.product.images.length + 1,
                                gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),
                                itemBuilder: (BuildContext context, int index) {
                                  if (widget.product.images.length > index) {
                                    return Stack(
                                      children: <Widget>[
                                        Card(
                                            clipBehavior: Clip.antiAlias,
                                            elevation: 1.0,
                                            margin: EdgeInsets.all(4.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(4.0),
                                            ),
                                            child: Image.network(
                                                widget
                                                    .product.images[index].src,
                                                fit: BoxFit.cover)),
                                        Positioned(
                                          top: -5,
                                          right: -5,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                            ),
                                            onPressed: () => removeImage(
                                                widget.product.images[index]),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (widget.product.images.length ==
                                      index &&
                                      isImageUploading) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return Container(
                                        child: GestureDetector(
                                          child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            elevation: 1.0,
                                            margin: EdgeInsets.all(4.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(4.0),
                                            ),
                                            child: Image.asset(
                                              'assets/images/upload_placeholder.png',
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          onTap: () => _choose(),
                                        ));
                                  }
                                })
                                : Container(),
                          ],
                        ),
                      ),
                    ),


                    CustomCard(
                      child: ListTile(
                        isThreeLine: widget.product.shortDescription.isNotEmpty && widget.product.shortDescription != null,
                        trailing: Icon(Icons.arrow_right_rounded),
                        title: Text(AppLocalizations.of(context).translate("short_description")),
                        subtitle: widget.product.shortDescription.isEmpty || widget.product.shortDescription == null ? null : Text(parseHtmlString(widget.product.shortDescription), maxLines: 2),
                        onTap: () async {
                          String? text = await Navigator.push(context, MaterialPageRoute( builder: (context) => TextEditorPage(text: widget.product.shortDescription)));
                          if(text != null) {
                            setState(() => widget.product.shortDescription = text);
                          }
                        },
                      ),
                    ),

                    CustomCard(
                      child: ListTile(
                        isThreeLine: widget.product.description.isNotEmpty && widget.product.description != null,
                        trailing: Icon(Icons.arrow_right_rounded),
                        title: Text(AppLocalizations.of(context).translate("description")),
                        subtitle: widget.product.description.isEmpty || widget.product.description == null ? null : Text(parseHtmlString(widget.product.description), maxLines: 2),
                        onTap: () async {
                          String? text = await Navigator.push(context, MaterialPageRoute( builder: (context) => TextEditorPage(text: widget.product.description)));
                          if(text != null) {
                            setState(() => widget.product.description = text);
                          }
                        },
                      ),
                    ),

                    _buildCategoryTile(),

                    _buildAttributesTile(),

                    CustomCard(
                      child: ListTile(
                        trailing: Icon(Icons.arrow_right_rounded),
                        title: Text(AppLocalizations.of(context).translate("type")),
                        subtitle: Text(widget.product.type),
                        onTap: () async {
                          String type = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SelectProductType(product: widget.product)),
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    CustomCard(
                      child: ListTile(
                        trailing: Icon(Icons.arrow_right_rounded),
                        title: Text(AppLocalizations.of(context).translate("status")),
                        subtitle: Text(widget.product.status),
                        onTap: () async {
                          String type = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SelectProductStatus(product: widget.product)),
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    CustomCard(
                      child: ListTile(
                        trailing: Icon(Icons.arrow_right_rounded),
                        title: Text(AppLocalizations.of(context).translate("catalog_visibility")),
                        subtitle: Text(widget.product.catalogVisibility),
                        onTap: () async {
                          String type = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SelectProductCatalogVisibility(product: widget.product)),
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    CustomCard(
                      child: ListTile(
                        trailing: Icon(Icons.arrow_right_rounded),
                        title: Text('Tax Status'),
                        subtitle: widget.product.taxStatus != null ? Text(widget.product.taxStatus!) : null,
                        onTap: () async {
                          String? type = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SelectProductTaxStatus(product: widget.product)),
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    if(widget.product.taxStatus == 'taxable' || widget.product.taxStatus == 'shipping')
                      CustomCard(
                        child: ListTile(
                          trailing: Icon(Icons.arrow_right_rounded),
                          title: Text('Tax Class'),
                          subtitle: widget.product.taxClass != null ? Text(widget.product.taxClass!) : null,
                          onTap: () async {
                            String? type = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SelectTaxClasses(product: widget.product)),
                            );
                            setState(() {});
                          },
                        ),
                      ),


                    /* SizedBox(height: 16),
                    TextFormField(
                      initialValue: widget.product.stockQuantity.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Stock Quantity"),
                      onSaved: (val) => setState(
                              () => widget.product.stockQuantity = int.parse(val)),
                    ),*/


                    CustomCard(
                      child: SwitchListTile(
                        title: Text('Manage Stock', style: Theme.of(context).textTheme.titleMedium),
                        value: widget.product.manageStock,
                        onChanged: (value)=>setState((){
                          widget.product.manageStock = value;
                        }),
                      ),
                    ),

                    if(widget.product.manageStock == true)
                      CustomCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            initialValue: widget.product.stockQuantity.toString(),
                            decoration: InputDecoration(
                              labelText: "Stock Quantity",
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (val) {
                              if(val != null) {
                                setState(() => widget.product.stockQuantity = int.parse(val));
                              }
                            },
                          ),
                        ),
                      )
                    else Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCard(
                          child: ListTile(
                            trailing: Icon(Icons.arrow_right_rounded),
                            title: Text(AppLocalizations.of(context).translate("stock_status")),
                            subtitle: Text(widget.product.stockStatus),
                            onTap: () async {
                              String type = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SelectProductStatus(product: widget.product)),
                              );
                              setState(() {});
                            },
                          ),
                        ),
                        CustomCard(
                          child: ListTile(
                            trailing: Icon(Icons.arrow_right_rounded),
                            title: Text(AppLocalizations.of(context).translate("back_orders")),
                            subtitle: Text(widget.product.backOrders),
                            onTap: () async {
                              String type = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SelectProductBackorder(product: widget.product)),
                              );
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),

                    /*CustomCard(
                      child: SwitchListTile(
                        title: Text('On Sale'),
                        value: widget.product.onSale,
                        onChanged: (bool value) {
                          setState(() {
                            widget.product.onSale = value;
                          });
                        },
                      ),
                    ),
                    if (widget.product.onSale == true) */Column(
                      children: [
                        SaleDateTimeItem(
                          title: 'On Sale From',
                          dateTime: widget.product.dateOnSaleFromGmt != null ? DateTime.parse(widget.product.dateOnSaleFromGmt) : null,
                          onChanged: (DateTime value) {
                            setState(() {
                              widget.product.dateOnSaleFromGmt = value.toIso8601String();
                            });
                          },
                        ),
                        SaleDateTimeItem(
                          title: 'On Sale To',
                          dateTime: widget.product.dateOnSaleToGmt != null ? DateTime.parse(widget.product.dateOnSaleToGmt) : null,
                          onChanged: (DateTime value) {
                            setState(() {
                              widget.product.dateOnSaleToGmt = value.toIso8601String();
                            });
                          },
                        ),
                        if(widget.product.dateOnSaleToGmt != null || widget.product.dateOnSaleFromGmt != null)
                          CustomCard(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: TextButton(onPressed: () {
                                  setState(() {
                                    widget.product.dateOnSaleToGmt = null;
                                    widget.product.dateOnSaleFromGmt = null;
                                  });
                                }, child: Text('Cancel')),
                              ),
                            ),
                          )
                      ],
                    )/* else Container()*/,

                    CustomCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("weight"),),
                          onSaved: (val) => setState(() => widget.product.weight),
                        ),
                      ),
                    ),

                    CustomCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          initialValue: widget.product.sku,
                          decoration: InputDecoration(
                            labelText:  AppLocalizations.of(context).translate("sku"),
                          ),
                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.product.sku = val);
                            }
                          },
                        ),
                      ),
                    ),

                    CustomCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          initialValue: widget.product.regularPrice,
                          keyboardType:
                          TextInputType.numberWithOptions(decimal: true, signed: false),
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("regular_price"),),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context).translate("please_enter_regular_price");
                            }
                          },
                          onSaved: (val) {
                            if(val != null) {
                              setState(() {
                                widget.product.regularPrice = val;
                                widget.product.price = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    CustomCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          initialValue: widget.product.salePrice != null ? widget.product.salePrice.toString() : null,
                          keyboardType:
                          TextInputType.numberWithOptions(decimal: true, signed: false),
                          //widget.product.salePrice.toString(),
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("sale_price"),),
                          /*validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context).translate("please_enter_sale_price");
                            }
                          },*/
                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.product.salePrice = val);
                            }
                          },
                        ),
                      ),
                    ),

                    CustomCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          initialValue: widget.product.purchaseNote,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("purchase_note"),),
                          onSaved: (val) {
                            if(val != null) {
                              setState(() => widget.product.purchaseNote = val);
                            }
                          },
                        ),
                      ),
                    ),


                    widget.product.type == "variable" ?
                    CustomCard(
                      child: ListTile(
                          title: Text(AppLocalizations.of(context).translate("variations")),
                          trailing: Icon(CupertinoIcons.forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VariationProductList(
                                      product: widget.product,
                                    ),
                              ),
                            );
                          }
                      ),
                    )
                    /*FlatButton(
                       child: Text("Variations"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VariationProductList(
                                vendorBloc: widget.vendorBloc,
                              product: widget.product,
                              ),
                            ),
                          );
                        })*/
                        : Container(),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: LoadingButton(
                            onPressed: () => save(),
                            text: AppLocalizations.of(context).translate("submit")
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _choose() async {
    //set state image uploading true
    //imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = pickedFile;
    });
    if (imageFile != null) {
      _upload();
    }
  }

  void _upload() async {
    setState(() {
      isImageUploading = true;
    });
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(_apiProvider.wc_api.url +
            "/wp-admin/admin-ajax.php?action=build-app-online-admin_upload_image"));
    var pic = await http.MultipartFile.fromPath("file", imageFile!.path);
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    Map<String, dynamic> fileUpload = jsonDecode(responseString);
    FileUploadResponse uploadedFile = FileUploadResponse.fromJson(fileUpload);

    if (uploadedFile.url != null) {
      ProductImage? picture = ProductImage(src: uploadedFile.url!);
      setState(() {
        widget.product.images.add(picture);
        isImageUploading = false;
      });
    }
  }

  removeImage(ProductImage imag) {
    if (widget.product.images.length > 1) {
      setState(() {
        widget.product.images.remove(imag);
      });
    } else {
      //TODO toas caanot remove only one image
    }
  }

  _buildCategoryTile() {
    String option = '';
    widget.product.categories.forEach((value) => {
      option = option.isEmpty ? value.name : option + ', ' + value.name
    });
    return CustomCard(
      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectCategories(product: widget.product))),
        title: Text("Categories"),
        subtitle: option.isNotEmpty ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
        trailing: Icon(Icons.arrow_right_rounded),
      ),
    );
  }

  _buildAttributesTile() {
    String option = '';
    widget.product.attributes.where((element) => element.options.length != 0).forEach((value) => {
      option = option.isEmpty ? value.name : option + ', ' + value.name
    });
    return CustomCard(
      child: ListTile(
          title: Text(AppLocalizations.of(context).translate("attributes"),),
          trailing: Icon(Icons.arrow_right_rounded),
          subtitle: option.isNotEmpty ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
          onTap: () async {
            final data = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SelectAttributes(
                      vendorBloc: widget.vendorBloc,
                      product: widget.product,
                    ),
              ),
            );
            setState(() {
              widget.product;
            });
          }
      ),
    );
  }

  save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await widget.vendorBloc.editProduct(widget.product);
      Navigator.pop(context);
      return;
    }
  }

}

class FileUploadResponse {
  final String? url;

  FileUploadResponse(this.url);

  FileUploadResponse.fromJson(Map<String, dynamic> json) : url = json['url'];

  Map<String, dynamic> toJson() => {
    'url': url,
  };
}
