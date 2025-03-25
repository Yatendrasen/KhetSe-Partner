import 'dart:convert';

import 'package:admin/src/models/gift_card/gift_card_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/error/error_model.dart';

class GiftCardBloc with ChangeNotifier {
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool moreItems = true;
  final apiProvider = ApiProvider();
  List<GiftCardModel> items = [];

  final _hasMoreResultsFetcher = BehaviorSubject<bool>();
  final _resultLoadingFetcher = BehaviorSubject<bool>();
  final _resultFetcher = BehaviorSubject<List<GiftCardModel>>();

  ValueStream<List<GiftCardModel>> get results => _resultFetcher.stream;
  ValueStream<bool> get hasMoreItems => _hasMoreResultsFetcher.stream;
  ValueStream<bool> get searchLoading => _resultLoadingFetcher.stream;

  fetchItems() async {
    page = 1;
    filter['page'] = page.toString();
    filter['per_page'] = 20;
    _resultLoadingFetcher.sink.add(true);
    final response = await apiProvider.get("gift-cards" + getQueryString(filter));
    _resultLoadingFetcher.sink.add(false);
    items = giftCardModelFromJson(response);
    _resultFetcher.sink.add(items);
    if (items.length == 0) {
      moreItems = false;
      _hasMoreResultsFetcher.sink.add(moreItems);
    } else {
      _hasMoreResultsFetcher.sink.add(true);
    }
  }

  loadMore() async {
    page = page + 1;
    filter['page'] = page.toString();
    _hasMoreResultsFetcher.sink.add(true);
    final response = await apiProvider.get("gift-cards" + getQueryString(filter));
    List<GiftCardModel> moreCards = giftCardModelFromJson(response);
    items.addAll(moreCards);
    _resultFetcher.sink.add(items);
    if (moreCards.length == 0) {
      moreItems = false;
      _hasMoreResultsFetcher.sink.add(false);
    }
  }

  Future<bool> addItem(GiftCardModel giftCard) async {
    final response = await apiProvider.wc_api.postAsync("gift-cards", giftCard.toJson(), 'Adding New Gift Card...');
    if (response.statusCode == 200 || response.statusCode == 201) {
      GiftCardModel giftCard =  GiftCardModel.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to add customer');
    }
    return true;
  }

  Future<bool> deleteItem(GiftCardModel giftCard) async {
    final response = await apiProvider.wc_api.deleteAsync("gift_cards/" + giftCard.id.toString() + '?force=true', 'Deleting Gift Card...');
    if (response.statusCode == 200 || response.statusCode == 201) {
      GiftCardModel giftCard =  GiftCardModel.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to add customer');
    }
    return true;
  }

  editItem(GiftCardModel giftCard) async {
    final response = await apiProvider.wc_api.putAsync("customers/" + giftCard.id.toString(), giftCard.toJson(), 'Updating Gift Card...');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return GiftCardModel.fromJson(json.decode(response.body));
    } else {
      Errors errors = Errors.fromJson(json.decode(response.body));
      throw Exception('Failed to edit customer');
    }
  }

  dispose() {
    _hasMoreResultsFetcher.close();
    _resultFetcher.close();
    _resultLoadingFetcher.close();
  }
}
