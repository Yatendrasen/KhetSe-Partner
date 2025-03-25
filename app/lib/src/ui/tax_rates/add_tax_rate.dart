import 'package:admin/src/blocs/tax_rates/tax_rates_bloc.dart';
import 'package:admin/src/models/tax_rates/tax_rates.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:admin/src/ui/loading_button.dart';
import 'package:flutter/material.dart';

class AddTaxRate extends StatefulWidget {
  final TaxRatesBloc taxRatesBloc;
  const AddTaxRate({Key? key, required this.taxRatesBloc}) : super(key: key);

  @override
  State<AddTaxRate> createState() => _AddTaxRateState();
}

class _AddTaxRateState extends State<AddTaxRate> {
  final _formKey = GlobalKey<FormState>();
  TaxRatesModel form = TaxRatesModel.fromJson({});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
            .translate("name"),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)
                      .translate("please_enter_name");
                }
              },
              onSaved: (val) {
                if (val != null) {
                  setState(() => form.name = val);
                }
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Rate',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter rate';
                }
              },
              onSaved: (val) {
                if (val != null) {
                  setState(() => form.rate = val);
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Country',
              ),
              onSaved: (val) {
                if (val != null) {
                  setState(() => form.country = val);
                }
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'State',
              ),
              onSaved: (val) {
                if (val != null) {
                  setState(() => form.state = val);
                }
              },
            ),
            SizedBox(height: 16),
            SwitchListTile(title: Text('Shipping'), value: form.shipping, onChanged: (value) {
              setState(() => form.shipping = value);
            }),
            SizedBox(height: 16),
            SwitchListTile(title: Text('Compound'), value: form.compound, onChanged: (value) {
              setState(() => form.compound = value);
            }),
            SizedBox(height: 16),
            LoadingButton(onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                await widget.taxRatesBloc.addItem(form);
                Navigator.pop(context);
              }
            }, text: 'Save'),
          ],
        ),
      ),
    );
  }
}