import 'dart:convert';
import 'package:admin/src/blocs/products/products_bloc_new.dart';
import 'package:admin/src/functions.dart';
import 'package:admin/src/ui/accounts/login/loading_button.dart';
import 'package:admin/src/ui/products/products/select_categories.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/products/selects/select_product_tax_status.dart';
import 'package:admin/src/ui/products/selects/select_tax_class.dart';
import 'package:admin/src/ui/text_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin/src/resources/api_provider.dart';
import '../../../blocs/products/vendor_bloc.dart';
import '../../../models/product/vendor_product_model.dart';
import 'package:http/http.dart' as http;
import 'attributes.dart';
import '../buttons/buttons.dart';
import 'date_time_item.dart';


class AddVendorProduct extends StatefulWidget {
  final vendorBloc = VendorBloc();
  final ProductBloc productBloc;

  AddVendorProduct({super.key, required this.productBloc});
  @override
  _AddVendorProductState createState() => _AddVendorProductState();
}

class _AddVendorProductState extends State<AddVendorProduct> {
  /*VendorProduct product = new VendorProduct(
    type: 'simple',
    status: 'publish',
    catalogVisibility: 'visible',
    taxStatus: 'taxable',
    stockStatus: 'instock',
    stockQuantity: 1,
    manageStock: false,
    onSale: false,
    backOrders: 'no',
    images: [],
    categories: [],
    attributes: [],
  );*/
  VendorProduct product = new VendorProduct.fromJson({});
  final _formKey = GlobalKey<FormState>();
  final _apiProvider = ApiProvider();
  final ImagePicker _picker = ImagePicker();
  PickedFile? imageFile;
  bool isImageUploading = false;


  @override
  void initState() {
    super.initState();

  }

  void handleTypeValueChanged(String? value) {
    if(value != null) {
      setState(() {
        product.type = value;
      });
    }
  }

  void handleStatusTypeValueChanged(String? value) {
    if(value != null) {
      setState(() {
        product.status = value;
      });
    }
  }

  void handlecatalogVisibilityTypeValueChanged(String? value) {
    if(value != null) {
      setState(() {
        product.catalogVisibility = value;
      });
    }
  }

  void handlestockStatusValueChanged(String? value) {
    if(value != null) {
      setState(() {
        product.stockStatus = value;
      });
    }
  }

  void handlebackOrdersValueChanged(String? value) {
    if(value != null) {
      setState(() {
        product.backOrders = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("add_product")),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).translate("product_name")
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).translate("please_enter_product_name");
                        }
                      },
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => product.name = val);
                        }
                      },
                    ),
                    //Text(urls),

                    const SizedBox(height: 16.0),
                    Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 150,
                            height: 40,
                            child: AccentButton(
                                onPressed: _choose,
                                text: AppLocalizations.of(context).translate("choose_image")),
                          ),
                        ),
                        product.images.length >= 0
                            ? GridView.builder(
                            shrinkWrap: true,
                            itemCount: product.images.length + 1,
                            gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4),
                            itemBuilder: (BuildContext context, int index) {
                              if (product.images.length != index) {
                                return Stack(
                                  children: [
                                    Card(
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 1.0,
                                        margin: EdgeInsets.all(4.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(4.0),
                                        ),
                                        child: Image.network(
                                            product.images[index].src,
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
                                            product.images[index]),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (product.images.length == index &&
                                  isImageUploading) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Container();
                              }
                            })
                            : Text(AppLocalizations.of(context).translate("no_image_selected")),
                      ],
                    ),

                    _buildCategoryTile(),

                    _buildAttributesTile(),

                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      trailing: Icon(Icons.arrow_right_rounded),
                      title: Text('Tax Status'),
                      subtitle: product.taxStatus != null ? Text(product.taxStatus!) : null,
                      onTap: () async {
                        String? type = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectProductTaxStatus(product: product)),
                        );
                        setState(() {});
                      },
                    ),

                    if(product.taxStatus == 'taxable' || product.taxStatus == 'shipping')
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        trailing: Icon(Icons.arrow_right_rounded),
                        title: Text('Tax Class'),
                        subtitle: product.taxClass != null ? Text(product.taxClass!) : null,
                        onTap: () async {
                          String? type = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SelectTaxClasses(product: product)),
                          );
                          setState(() {});
                        },
                      ),

                    const SizedBox(height: 16.0),
                    Text(AppLocalizations.of(context).translate("type"), style: Theme.of(context).textTheme.titleMedium),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'simple',
                          groupValue: product.type,
                          onChanged: handleTypeValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("simple"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'grouped',
                          groupValue: product.type,
                          onChanged: handleTypeValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("grouped"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(children: <Widget>[
                      Radio<String>(
                        value: 'external',
                        groupValue: product.type,
                        onChanged: handleTypeValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("external"),
                        style: new TextStyle(fontSize: 16.0),
                      ),

                      Radio<String>(
                        value: 'variable',
                        groupValue: product.type,
                        onChanged: handleTypeValueChanged,
                      ),
                      new Text(
                        AppLocalizations.of(context).translate("variable"),
                        style: new TextStyle(fontSize: 16.0),
                      ),
                    ]),

                    const SizedBox(height: 16.0),
                    Text( AppLocalizations.of(context).translate("status"), style: Theme.of(context).textTheme.titleMedium),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'draft',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("draft"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'pending',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("pending"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'private',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("private"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'publish',
                          groupValue: product.status,
                          onChanged: handleStatusTypeValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("publish"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0),
                    Text( AppLocalizations.of(context).translate("catalog_visibility"), style: Theme.of(context).textTheme.titleMedium),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'visible',
                          groupValue: product.catalogVisibility,
                          onChanged: handlecatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("visible"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'catalog',
                          groupValue: product.catalogVisibility,
                          onChanged: handlecatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("catalog"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'search',
                          groupValue: product.catalogVisibility,
                          onChanged: handlecatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("search"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        Radio<String>(
                          value: 'hidden',
                          groupValue: product.catalogVisibility,
                          onChanged: handlecatalogVisibilityTypeValueChanged,
                        ),
                        new Text(
                          AppLocalizations.of(context).translate("hidden"),
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0),
                    SwitchListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text('Manage Stock', style: Theme.of(context).textTheme.titleMedium),
                      value: product.manageStock,
                      onChanged: (value)=>setState((){
                        product.manageStock = value;
                      }),
                    ),

                    if(product.manageStock == true)
                      Column(
                        children: [
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: product.stockQuantity.toString(),
                            decoration: InputDecoration(
                              labelText: "Stock Quantity",
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (val) {
                              if(val != null) {
                                setState(() => product.stockQuantity = int.parse(val));
                              }
                            },
                          ),
                        ],
                      )
                    else Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        Text(AppLocalizations.of(context).translate("stock_status"), style: Theme.of(context).textTheme.titleMedium),
                        Row(
                          children: <Widget>[
                            Radio<String>(
                              value: 'instock',
                              groupValue: product.stockStatus,
                              onChanged: handlestockStatusValueChanged,
                            ),
                            new Text(
                              AppLocalizations.of(context).translate("instock"),
                              style: new TextStyle(fontSize: 16.0),
                            ),
                            Radio<String>(
                              value: 'outofstock',
                              groupValue: product.stockStatus,
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
                              groupValue: product.stockStatus,
                              onChanged: handlestockStatusValueChanged,
                            ),
                            new Text(
                              AppLocalizations.of(context).translate("onbackorder"),
                              style: new TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Text(  AppLocalizations.of(context).translate("back_orders"), style: Theme.of(context).textTheme.titleMedium),
                        Row(
                          children: <Widget>[
                            Radio<String>(
                              value: 'no',
                              groupValue: product.backOrders,
                              onChanged: handlebackOrdersValueChanged,
                            ),
                            new Text(
                              AppLocalizations.of(context).translate("no"),
                              style: new TextStyle(fontSize: 16.0),
                            ),
                            Radio<String>(
                              value: 'notify ',
                              groupValue: product.backOrders,
                              onChanged: handlebackOrdersValueChanged,
                            ),
                            new Text(
                              AppLocalizations.of(context).translate("notify"),
                              style: new TextStyle(fontSize: 16.0),
                            ),
                            Radio<String>(
                              value: 'yes',
                              groupValue: product.backOrders,
                              onChanged: handlebackOrdersValueChanged,
                            ),
                            new Text(
                              AppLocalizations.of(context).translate("yes"),
                              style: new TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0),
                    SwitchListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text('On Sale'),
                      value: product.onSale,
                      onChanged: (bool value) {
                        setState(() {
                          product.onSale = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    product.onSale == true
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SaleDateTimeItem(
                          title: 'From',
                          dateTime: product.dateOnSaleFromGmt != null ? DateTime.parse(product.dateOnSaleFromGmt) : null,
                          onChanged: (DateTime value) {
                            setState(() {
                              product.dateOnSaleFromGmt = value.toIso8601String();
                            });
                          },
                        ),
                        SaleDateTimeItem(
                          title: 'To',
                          dateTime: product.dateOnSaleToGmt != null ? DateTime.parse(product.dateOnSaleToGmt) : null,
                          onChanged: (DateTime value) {
                            setState(() {
                              product.dateOnSaleToGmt = value.toIso8601String();
                            });
                          },
                        ),
                      ],
                    ) : Container(),

                    SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      isThreeLine: product.shortDescription.isNotEmpty && product.shortDescription != null,
                      trailing: Icon(Icons.arrow_right_rounded),
                      title: Text(AppLocalizations.of(context).translate("short_description")),
                      subtitle: product.shortDescription.isEmpty || product.shortDescription == null ? null : Text(parseHtmlString(product.shortDescription), maxLines: 2),
                      onTap: () async {
                        String? text = await Navigator.push(context, MaterialPageRoute( builder: (context) => TextEditorPage(text: product.shortDescription)));
                        if(text != null) {
                          setState(() => product.shortDescription = text);
                        }
                      },
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      isThreeLine: product.description.isNotEmpty,
                      trailing: Icon(Icons.arrow_right_rounded),
                      title: Text(AppLocalizations.of(context).translate("description")),
                      subtitle: product.description.isEmpty || product.description == null ? null : Text(parseHtmlString(product.description), maxLines: 2),
                      onTap: () async {
                        String? text = await Navigator.push(context, MaterialPageRoute( builder: (context) => TextEditorPage(text: product.description)));
                        if(text != null) {
                          setState(() => product.description = text);
                        }
                      },
                    ),

                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("weight"),),
                      /* validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter weight';
                        }
                      },*/
                      onSaved: (val) => setState(() => product.weight),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText:AppLocalizations.of(context).translate("sku"),
                      ),
                      onSaved: (val) => setState(() => product.sku = val),
                    ),



                    /*SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: AppLocalizations.of(context).translate("short_description"),),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => product.shortDescription = val);
                        }
                      },
                    ),

                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("description"),),
                      onSaved: (val) {
                        if(val != null) {
                          setState(() => product.description = val);
                        }
                      },
                    ),*/

                    SizedBox(height: 16),
                    TextFormField(
                      keyboardType:
                      TextInputType.numberWithOptions(decimal: true, signed: false),
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("regular_price"),),
                      /*validator: (value) {
                        if (value.isEmpty) {
                          return "please enter regular price";
                        }
                      },*/
                      onSaved: (val) =>
                          setState(() {
                            if(val != null) {
                              setState(() => product.regularPrice = val);
                              setState(() => product.price = val);
                            }
                          }),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: product.salePrice != null ? product.salePrice.toString() : null,
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
                          setState(() => product.salePrice = val);
                        }
                      },
                    ),

                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("purchase_note"),),
                      onSaved: (val) =>
                          setState(() => product.purchaseNote = val),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: LoadingButton(
                            onPressed: () => save(),
                            text: AppLocalizations.of(context).translate("submit")
                        ),/*AccentButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              widget.vendorBloc.addProduct(product);
                              Navigator.pop(context);
                            }
                          },
                          text: AppLocalizations.of(context).translate("submit"),
                        ),*/
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
    // set state image uploading true
    //imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = pickedFile;
      print("file.....");
      print(imageFile);
    });
    if (imageFile != null) {
      print("image uploading....");
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
    print("pic...");
    print(pic.toString());
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();


    var responseString = String.fromCharCodes(responseData);

    Map<String, dynamic> fileUpload = jsonDecode(responseString);
    print("image...");
    print(fileUpload);
    FileUploadResponse uploadedFile = FileUploadResponse.fromJson(fileUpload);
    print("upload file name");
    print(uploadedFile);
    if (uploadedFile.url != null) {
      print("upload file url");
      print(uploadedFile);
      print(uploadedFile.url);
      ProductImage picture = ProductImage(src: uploadedFile.url!);
      setState(() {
        product.images.add(picture);
        isImageUploading = false;
      });
    }
  }

  _buildCategoryTile() {
    String option = '';
    product.categories.forEach((value) =>
    {option = option.isEmpty ? value.name : option + ', ' + value.name});
    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectCategories(product: product)));
        setState(() {});
      },
      title: Text("Categories"),
      //isThreeLine: true,
      subtitle: option.isNotEmpty
          ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis)
          : null,
      trailing: Icon(CupertinoIcons.forward),
    );
  }
  _buildAttributesTile() {
    String option = '';
    product.attributes.forEach((value) =>
    {option = option.isEmpty ? value.name : option + ', ' + value.name});
    return ListTile(
        contentPadding: EdgeInsets.all(0.0),
        title: Text(AppLocalizations.of(context).translate("attributes")),
        //dense: true,
        trailing: Icon(CupertinoIcons.forward),
        subtitle: option.isNotEmpty
            ? Text(option, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        onTap: () async {
          final data = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectAttributes(
                vendorBloc: widget.vendorBloc,
                product: product,
              ),
            ),
          );
          setState(() {});
        });

  }

  removeImage(ProductImage imag) {
    setState(() {
      product.images.remove(imag);
    });
  }

  save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await widget.vendorBloc.addProduct(product);
      widget.productBloc.fetchProducts();
      Navigator.pop(context);
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
