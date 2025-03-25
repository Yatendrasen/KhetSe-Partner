import 'package:admin/src/blocs/gift_cards/gift_card_bloc.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter/material.dart';

class FilterGiftCard extends StatefulWidget {
  final GiftCardBloc giftCardBloc;
  const FilterGiftCard({Key? key, required this.giftCardBloc}) : super(key: key);
  @override
  State<FilterGiftCard> createState() => _FilterGiftCardState();
}

class _FilterGiftCardState extends State<FilterGiftCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("filter")),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(AppLocalizations.of(context).translate("order").toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("ascending")),
                    selected: widget.giftCardBloc.filter.containsKey('order') && widget.giftCardBloc.filter['order'] == 'asc',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.giftCardBloc.filter['order'] = 'asc';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text(AppLocalizations.of(context).translate("descending")),
                    selected: widget.giftCardBloc.filter['order'] == 'desc',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.giftCardBloc.filter['order'] = 'desc';
                      });
                    },
                  ),
                ],
              ),
              Divider(height: 24),
              Text(AppLocalizations.of(context).translate("order_by").toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text('Create Date'),
                    selected: widget.giftCardBloc.filter.containsKey('orderby') && widget.giftCardBloc.filter['orderby'] == 'create_date',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.giftCardBloc.filter['orderby'] = 'create_date';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text('Deliver Date'),
                    selected: widget.giftCardBloc.filter.containsKey('orderby') && widget.giftCardBloc.filter['orderby'] == 'deliver_date',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.giftCardBloc.filter['orderby'] = 'deliver_date';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text('Balance'),
                    selected: widget.giftCardBloc.filter.containsKey('orderby') && widget.giftCardBloc.filter['orderby'] == 'balance',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.giftCardBloc.filter['orderby'] = 'balance';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text('Remaining'),
                    selected: widget.giftCardBloc.filter.containsKey('orderby') && widget.giftCardBloc.filter['orderby'] == 'remaining',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.giftCardBloc.filter['orderby'] = 'remaining';
                      });
                    },
                  ),
                  ChoiceChip(
                    //shape: RoundedRectangleBorder(),
                    label: Text('Order Id'),
                    selected: widget.giftCardBloc.filter.containsKey('orderby') && widget.giftCardBloc.filter['orderby'] == 'order_id',
                    onSelected: (bool selected) {
                      setState(() {
                        widget.giftCardBloc.filter['orderby'] = 'order_id';
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      widget.giftCardBloc.filter.clear();
                      setState(() {});
                    },
                    child: Text('Clear All')),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.onSecondary),
                    onPressed: () async {
                      widget.giftCardBloc.fetchItems();
                      Navigator.of(context).pop();
                    }, child: Text('Apply')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
