import 'package:admin/src/models/gift_card/gift_card_model.dart';
import 'package:admin/src/ui/gift_cards/activities.dart';
import 'package:admin/src/ui/gift_cards/edit_gift_card.dart';
import 'package:admin/src/ui/gift_cards/meta_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GiftCardDetails extends StatefulWidget {
  final GiftCardModel giftCard;
  GiftCardDetails({Key? key, required this.giftCard}) : super(key: key);

  @override
  State<GiftCardDetails> createState() => _GiftCardDetailsState();
}

class _GiftCardDetailsState extends State<GiftCardDetails> {

  DateFormat formatter1 = new DateFormat('dd-MM-yyyy  hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(widget.giftCard.code),
            subtitle: Text('Code'),
          ),
          Divider(height: 0),
          ListTile(
            title: Text(widget.giftCard.balance.toString()),
            subtitle: Text('Balance'),
          ),
          Divider(height: 0),
          ListTile(
            title: Text(widget.giftCard.remaining.toString()),
            subtitle: Text('Remaining'),
          ),
          Divider(height: 0),
          ListTile(
            title: Text(widget.giftCard.recipient),
            subtitle: Text('Recipient'),
          ),
          Divider(height: 0),
          if(widget.giftCard.message.isNotEmpty)
          Column(
            children: [
              ListTile(
                title: Text(widget.giftCard.message),
                subtitle: Text('Message'),
              ),
              Divider(height: 0),
            ],
          ),
          ListTile(
            title: Text(widget.giftCard.sender),
            subtitle: Text('Sender'),
          ),
          Divider(height: 0),
          ListTile(
            title: Text(widget.giftCard.senderEmail),
            subtitle: Text('Sender Email'),
          ),
          Divider(height: 0),
          ListTile(
            title: Text(formatter1.format(widget.giftCard.createDate)),
            subtitle: Text('Create Date'),
          ),
          Divider(height: 0),
          if(widget.giftCard.delivered != null)
          Column(
            children: [
              ListTile(
                title: Text(widget.giftCard.delivered!),
                subtitle: Text('Delivered'),
              ),
              Divider(height: 0),
            ],
          ),
          if(widget.giftCard.deliverDate != null)
            Column(
              children: [
                ListTile(
                  title: Text(formatter1.format(widget.giftCard.deliverDate!)),
                  subtitle: Text('Deliver Date'),
                ),
                Divider(height: 0),
              ],
            ),
          if(widget.giftCard.redeemedBy != null)
            Column(
              children: [
                ListTile(
                  title: Text(formatter1.format(widget.giftCard.redeemedBy!)),
                  subtitle: Text('Redeemed By'),
                ),
                Divider(height: 0),
              ],
            ),
          if(widget.giftCard.redeemDate != null)
            Column(
              children: [
                ListTile(
                  title: Text(formatter1.format(widget.giftCard.redeemDate!)),
                  subtitle: Text('Redeem Date'),
                ),
                Divider(height: 0),
              ],
            ),
          if(widget.giftCard.expireDate != null)
            Column(
              children: [
                ListTile(
                  title: Text(formatter1.format(widget.giftCard.expireDate!)),
                  subtitle: Text('Expire Date'),
                ),
                Divider(height: 0),
              ],
            ),
          if(widget.giftCard.orderId != null)
            Column(
              children: [
                ListTile(
                  title: Text(widget.giftCard.orderId.toString()),
                  subtitle: Text('Order Id'),
                ),
                Divider(height: 0),
              ],
            ),
          if(widget.giftCard.orderItemId != null)
            Column(
              children: [
                ListTile(
                  title: Text(widget.giftCard.orderItemId.toString()),
                  subtitle: Text('Order Item Id'),
                ),
                Divider(height: 0),
              ],
            ),
          Divider(height: 0),
          ListTile(
            title: Text(widget.giftCard.isActive),
            subtitle: Text('Is Active'),
          ),
          Divider(height: 0),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Activities(activities: widget.giftCard.activities)),
              );
            },
            title: Text('Activities'),
            trailing: Icon(Icons.arrow_right),
            //subtitle: Text('Is Active'),
          ),
          Divider(height: 0),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MetaDataPage(metaDatum: widget.giftCard.metaData)),
              );
            },
            title: Text('Meta Data'),
            trailing: Icon(Icons.arrow_right),
            //subtitle: Text('Is Active'),
          ),
          Divider(height: 0),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditGiftCard(giftCard: widget.giftCard)),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
