import 'package:admin/src/blocs/gift_cards/gift_card_bloc.dart';
import 'package:admin/src/models/gift_card/gift_card_model.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:flutter/material.dart';

class CreateGiftCard extends StatefulWidget {
  final GiftCardBloc giftCardBloc;
  CreateGiftCard({Key? key, required this.giftCardBloc}) : super(key: key);

  @override
  State<CreateGiftCard> createState() => _CreateGiftCardState();
}

class _CreateGiftCardState extends State<CreateGiftCard> {

  final _formKey = GlobalKey<FormState>();
  final giftCard = GiftCardModel.fromJson({});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Gift Card'),
      ),
      body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Recipient Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter recipient email';
                          }
                        },
                        onSaved: (val) {
                          if (val != null) {
                            setState(() => giftCard.recipient = val);
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Sender',
                        ),
                        onSaved: (val) {
                          if (val != null) {
                            setState(() => giftCard.sender = val);
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Amount',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                        },
                        onSaved: (val) {
                          if (val != null) {
                            setState(() => giftCard.balance = double.parse(val));
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: AccentButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await widget.giftCardBloc.addItem(giftCard);
                                widget.giftCardBloc.fetchItems();
                                Navigator.pop(context);
                              }
                            },
                            text: 'Submit',
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          )),
    );
  }
}
