import 'package:admin/src/blocs/gift_cards/gift_card_bloc.dart';
import 'package:admin/src/models/gift_card/gift_card_model.dart';
import 'package:admin/src/ui/gift_cards/create_gift_card.dart';
import 'package:admin/src/ui/gift_cards/filter_gift_card.dart';
import 'package:admin/src/ui/gift_cards/gift_card_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GiftCardList extends StatefulWidget {
  final GiftCardBloc giftCardBloc = GiftCardBloc();
  GiftCardList({Key? key}) : super(key: key);

  @override
  State<GiftCardList> createState() => _GiftCardListState();
}

class _GiftCardListState extends State<GiftCardList> {

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    widget.giftCardBloc.fetchItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && widget.giftCardBloc.moreItems) {
        widget.giftCardBloc.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          /*IconButton(
            icon: new Icon(CupertinoIcons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SearchCoupon()
                  ));
            },
          ),*/
          IconButton(
            icon: Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => FilterGiftCard(giftCardBloc: widget.giftCardBloc),
                fullscreenDialog: true,
              ));
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: widget.giftCardBloc.results,
          builder: (context, AsyncSnapshot<List<GiftCardModel>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GiftCardDetails(giftCard: snapshot.data![index])),
                          );
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshot.data![index].code),
                            Text(snapshot.data![index].balance.toString()),
                          ],
                        ),
                        subtitle: Text(snapshot.data![index].recipient),
                      ),
                      Divider(height: 0)
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CreateGiftCard(giftCardBloc: widget.giftCardBloc)),
          );
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
