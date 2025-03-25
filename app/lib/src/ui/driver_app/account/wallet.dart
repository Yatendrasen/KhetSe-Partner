import 'package:admin/src/blocs/account/wallet_bloc.dart';
import 'package:admin/src/models/account/wallet_model.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Wallet extends StatefulWidget {
  final walletBloc = WalletBloc();
  Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  ScrollController _scrollController = new ScrollController();
  DateFormat dateFormatter = DateFormat('dd-MMM-yyyy');
  final appStateModel = AppStateModel();
  late NumberFormat formatter;



  @override
  void initState() {
    super.initState();
    print("this is wallet page ");
    widget.walletBloc.load();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.walletBloc.loadMore();
      }
    });

    formatter = NumberFormat.simpleCurrency(
        decimalDigits: AppStateModel().options.info!.priceDecimal,
        name: AppStateModel().options.info!.currency);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallet"),
      ),
      body: StreamBuilder<List<WalletModel>>(
        stream: widget.walletBloc.allTransactions,
        builder: (context, AsyncSnapshot<List<WalletModel>> snapshot) {
          // Check if data is available
          if (snapshot.hasData && snapshot.data != null) {
            // Check if the list is empty
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No transactions available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            // If the list is not empty, build the ListView
            return buildList(snapshot);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return Center(child: CircularProgressIndicator());
          } else {
            // Show an error message or fallback UI
            return Center(
              child: Text(
                "Failed to load transactions",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
  Widget buildList(AsyncSnapshot<List<WalletModel>> snapshot) {

    TextStyle titleStyle = Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.7);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(16),
                dense: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(snapshot.data![index].type.toUpperCase(), style: titleStyle),
                        SizedBox(width: 8),
                        Text(formatter
                            .format(double.parse(snapshot.data![index].amount)), style: titleStyle),
                      ],
                    ),
                    Text(formatter
                        .format(double.parse(snapshot.data![index].balance))),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(snapshot.data![index].details),
                    SizedBox(height: 4),
                    Text(dateFormatter.format(snapshot.data![index].date)),
                  ],
                ),
              ),
              Divider(thickness: 0, height: 0)
            ],
          );
        },
        childCount: snapshot.data!.length,
      ),
    );
  }

}
