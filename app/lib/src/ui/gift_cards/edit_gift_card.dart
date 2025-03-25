import 'package:admin/src/blocs/gift_cards/gift_card_bloc.dart';
import 'package:admin/src/models/gift_card/gift_card_model.dart';
import 'package:admin/src/ui/products/buttons/buttons.dart';
import 'package:flutter/material.dart';

class EditGiftCard extends StatefulWidget {
  final GiftCardBloc giftCardBloc = GiftCardBloc();
  final GiftCardModel giftCard;
  EditGiftCard({Key? key, required this.giftCard}) : super(key: key);

  @override
  State<EditGiftCard> createState() => _EditGiftCardState();
}

class _EditGiftCardState extends State<EditGiftCard> {

  final _formKey = GlobalKey<FormState>();

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
                        initialValue: widget.giftCard.recipient,
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
                            setState(() => widget.giftCard.recipient = val);
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: widget.giftCard.sender,
                        decoration: InputDecoration(
                          labelText: 'Sender',
                        ),
                        onSaved: (val) {
                          if (val != null) {
                            setState(() => widget.giftCard.sender = val);
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: widget.giftCard.senderEmail,
                        decoration: InputDecoration(
                          labelText: 'Sender',
                        ),
                        onSaved: (val) {
                          if (val != null) {
                            setState(() => widget.giftCard.senderEmail = val);
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        initialValue: widget.giftCard.balance.toString(),
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
                            setState(() => widget.giftCard.balance = double.parse(val));
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      SwitchListTile(
                          value: widget.giftCard.isActive == 'on',
                          onChanged: (value) {
                            setState(() {
                              widget.giftCard.isActive = value ? 'on' : 'off';
                            });
                          },
                        title: Text('Activer'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: AccentButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await widget.giftCardBloc.editItem(widget.giftCard);
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
