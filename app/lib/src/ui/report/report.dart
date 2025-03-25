import 'package:admin/src/blocs/report/report_bloc.dart';
import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/resources/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:intl/intl.dart';
import '../drawer.dart';
import 'package:admin/src/models/sales/sales_model.dart';
import 'package:admin/src/models/sales/top_sellers_model.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'date_picker.dart';

class Items {
  final String name;
  final String value;
  Items({required this.name, required this.value});
}

class Report extends StatefulWidget {
  final ValueChanged<int> onChangePageIndex;
  final ReportBloc reportBloc;

  Report({Key? key, required this.reportBloc, required this.onChangePageIndex}) : super(key: key);
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> with AutomaticKeepAliveClientMixin<Report> {

  String period = 'week';
  var apiProvider = new ApiProvider();
  var appStateModel = new AppStateModel();

  bool get wantKeepAlive => true;

  var chartColor = charts.MaterialPalette.red;

  @override
  void initState() {
    super.initState();
    //initialize();
  }

  Future<void> initialize() async {
    //appStateModel.getSettings();
    //await apiProvider.initializationDone();
    //widget.reportBloc.periodType.add('month');
    //appStateModel.getActiveAccount();
  }

  void setCartTheme() {
    var command = Theme.of(context).primaryColor.value.toString();
    switch (command) {
      case '4294198070':
        chartColor = charts.MaterialPalette.red;
        break;
      case '4293467747':
        chartColor = charts.MaterialPalette.pink;
        break;
      case '4288423856':
        chartColor = charts.MaterialPalette.purple;
        break;
      case '4284955319':
        chartColor = charts.MaterialPalette.purple;
        break;
      case '4282339765':
        chartColor = charts.MaterialPalette.indigo;
        break;
      case '4280391411':
        chartColor = charts.MaterialPalette.blue;
        break;
      case '4278430196':
        chartColor = charts.MaterialPalette.blue;
        break;
      case '4278238420':
        chartColor = charts.MaterialPalette.cyan;
        break;
      case '4278228616':
        chartColor = charts.MaterialPalette.teal;
        break;
      case '4283215696':
        chartColor = charts.MaterialPalette.green;
        break;
      case '4287349578':
        chartColor = charts.MaterialPalette.green;
        break;
      case '4291681337':
        chartColor = charts.MaterialPalette.lime;
        break;
      case '4294961979':
        chartColor = charts.MaterialPalette.yellow;
        break;
      case '4294951175':
        chartColor = charts.MaterialPalette.deepOrange;
        break;
      case '4294940672':
        chartColor = charts.MaterialPalette.deepOrange;
        break;
      case '4294940672':
        chartColor = charts.MaterialPalette.deepOrange;
        break;
      case '4286141768':
        chartColor = charts.MaterialPalette.gray;
        break;
      case '4288585374':
        chartColor = charts.MaterialPalette.gray;
        break;
      case '4284513675':
        chartColor = charts.MaterialPalette.gray;
        break;
      default:
        chartColor = charts.MaterialPalette.blue;
    }
  }

  @override
  void dispose() {
    //widget.reportBloc.dispose();
    super.dispose();
  }

  void showMenuSelection(String value) {
    setState(() {
      period = value;
    });
    if(value != 'date'){
      widget.reportBloc.periodType.add(value);
    } else {
      Navigator.push(context, MaterialPageRoute<DismissDialogAction>(
        builder: (BuildContext context) => FilterReport(reportBloc: widget.reportBloc),
        fullscreenDialog: true,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var headerText = AppLocalizations.of(context).translate(period);
    return Scaffold(
      appBar: AppBar(
        title: new Text('${headerText[0].toUpperCase()}${headerText.substring(1)}'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: showMenuSelection,
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              CheckedPopupMenuItem<String>(
                value: 'week',
                child: Text(AppLocalizations.of(context).translate("week"),),
                checked: period == 'week',
              ),
              CheckedPopupMenuItem<String>(
                value: 'month',
                child:  Text( AppLocalizations.of(context).translate("month"),),
                checked: period == 'month',
              ),
              CheckedPopupMenuItem<String>(
                value: 'last_month',
                child:  Text( AppLocalizations.of(context).translate("last_month"),),
                checked: period == 'last_month',
              ),
              CheckedPopupMenuItem<String>(
                value: 'year',
                child: Text( AppLocalizations.of(context).translate("year"),),
                checked: period == 'year',
              ),
              /*CheckedPopupMenuItem<String>(
                value: 'date',
                child: Text( AppLocalizations.of(context).translate("date"),),
                checked: period == 'date',
              ),*/
            ],
          ),
        ],
      ),
      drawer: MyDrawer(onChangePageIndex: widget.onChangePageIndex),
      body: SafeArea(
        child: StreamBuilder(
                stream: widget.reportBloc.sales,
                builder: (context, AsyncSnapshot<SalesModel> snapshotSales) {

/*                  if (snapshotSales.hasData && snapshotSales.data != null) {
                    return RefreshIndicator (
                      onRefresh: () async {
                        widget.reportBloc.fetchSalesReport(period);
                        await new Future.delayed(const Duration(seconds: 2));
                      },
                      child: buildAllSalesChart(snapshotSales),
                    );
                  } else if (snapshotSales.hasError) {
                    return Text(snapshotSales.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());*/

                  return StreamBuilder(
                      stream: widget.reportBloc.topSellers,
                      builder: (context, AsyncSnapshot<TopSellersModel> snapshotTopSeller) {
                        if (snapshotTopSeller.hasData && snapshotTopSeller.data != null && snapshotSales.hasData && snapshotSales.data != null) {
                          return RefreshIndicator (
                            onRefresh: () async {
                              widget.reportBloc.fetchSalesReport(period);
                              await new Future.delayed(const Duration(seconds: 2));
                            },
                            child: buildAllSalesChart(snapshotSales, snapshotTopSeller),
                          );
                        } else if (snapshotTopSeller.hasError) {
                          return Text(snapshotTopSeller.error.toString());
                        }
                        return Center(child: CircularProgressIndicator());
                      });
                }),
      ),
    );
  }

  Widget buildAllSalesChart(AsyncSnapshot<SalesModel> snapshot,
      AsyncSnapshot<TopSellersModel> snapshotTopSeller) {

    setCartTheme();

      List<Widget> list = [];
      list.add(buildSalesList(snapshot));
      list.add(buildOrdersList(snapshot));
      list.add(buildItemsList(snapshot));
      list.add(buildCustomersList(snapshot));
      list.add(buildTaxList(snapshot));
      list.add(buildShippingList(snapshot));
      list.add(buildDiscountList(snapshot));
      list.add(buildTopSellersList(snapshotTopSeller));
      list.add(buildTableList(snapshot));

      return new ListView(children: list);
  }

  Widget buildTableList(AsyncSnapshot<SalesModel> snapshot) {

    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: appStateModel.numberOfDecimals, name: appStateModel.currency);

    var _items = <Items>[
      Items(name: AppLocalizations.of(context)
        .translate("total_sales"), value: formatter.format(double.parse(snapshot.data!.sales[0].totalSales))),
      Items(name: AppLocalizations.of(context)
          .translate("net_sales"), value: formatter.format(double.parse(snapshot.data!.sales[0].netSales))),
      Items(name: AppLocalizations.of(context)
        .translate("average_sales"), value: formatter.format(double.parse(snapshot.data!.sales[0].averageSales))),
      Items(name: AppLocalizations.of(context)
        .translate("total_orders"), value: snapshot.data!.sales[0].totalOrders.toString()),
      Items(name:AppLocalizations.of(context)
          .translate("total_items"), value: snapshot.data!.sales[0].totalItems.toString()),
      Items(name: AppLocalizations.of(context)
        .translate("total_tax"), value: formatter.format(double.parse(snapshot.data!.sales[0].totalTax))),
      Items(name: AppLocalizations.of(context)
        .translate("total_shipping"), value: formatter.format(double.parse(snapshot.data!.sales[0].totalShipping))),
      Items(name: AppLocalizations.of(context)
        .translate("total_refund"), value: snapshot.data!.sales[0].totalRefunds.toString()),
      Items(name: AppLocalizations.of(context)
        .translate("total_discount"), value: formatter.format(double.parse(snapshot.data!.sales[0].totalDiscount))),
    ];

    var tableWidget = Card(
        elevation: 0,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: DataTable(
      rows: _items.map((item)=>DataRow(
          cells: [
            DataCell(Text(item.name)),
            DataCell(Text(item.value, textAlign: TextAlign.end))
          ]
      )).toList(),
      columns: <DataColumn>[
        DataColumn(
          label:  Text(AppLocalizations.of(context)
              .translate("items"),),
        ),
        DataColumn(
          label:  Text(AppLocalizations.of(context)
              .translate("values"),textAlign: TextAlign.end),
        ),
      ],

    ));

    return tableWidget;
  }

  Widget buildSalesList(AsyncSnapshot<SalesModel> snapshot) {

    var data = snapshot.data!.sales[0].totals.values.toList();

    var series = [
      new charts.Series<Total, String>(
          id: 'Sales',
          colorFn: (_, __) => chartColor.shadeDefault,
          domainFn: (Total item, _) => item.key,
          measureFn: (Total item, _) => double.parse(item.sales),
          data: data,
          labelAccessorFn: (Total item, _) => '${double.parse(item.sales).toInt()}')
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
      vertical: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      behaviors: [
        new charts.ChartTitle(AppLocalizations.of(context)
            .translate("sales"),
            //subTitleStyleSpec: TextStyle(color: Colors.green[400]),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middle,
            innerPadding: 18),
      ],
    );

    var chartWidget = Card(
      elevation: 0,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: new Container(
        padding: new EdgeInsets.all(4.0),
        height: 300,
        child: chart,
      ),
    );

    return chartWidget;
  }

  Widget buildOrdersList(AsyncSnapshot<SalesModel> snapshot) {
    var data = snapshot.data!.sales[0].totals.values.toList();
    var series = [
      new charts.Series<Total, String>(
          id: 'Orders',
          colorFn: (_, __) => chartColor.shadeDefault,
          domainFn: (Total item, _) => item.key,
          measureFn: (Total item, _) => item.orders,
          data: data,
          labelAccessorFn: (Total item, _) => '${item.orders}')
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
      vertical: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      behaviors: [
        new charts.ChartTitle(AppLocalizations.of(context)
            .translate("orders"),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middle,
            innerPadding: 18),

      ],
    );

    var chartWidget = Card(
      elevation: 0,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: new Container(
        padding: new EdgeInsets.all(.0),
        height: 300,
        child: chart,
      ),
    );

    return chartWidget;
  }

  Widget buildItemsList(AsyncSnapshot<SalesModel> snapshot) {
    var data = snapshot.data!.sales[0].totals.values.toList();
    var series = [
      new charts.Series<Total, String>(
          id: 'Items',
          colorFn: (_, __) => chartColor.shadeDefault,
          domainFn: (Total item, _) => item.key,
          measureFn: (Total item, _) => item.items,
          data: data,
          labelAccessorFn: (Total item, _) => '${item.items}')
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
      vertical: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      behaviors: [
        new charts.ChartTitle(AppLocalizations.of(context)
            .translate("items"),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middle,
            innerPadding: 18),

      ],
    );

    var chartWidget = Card(
      elevation: 0,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: new Container(
        padding: new EdgeInsets.all(4.0),
        height: 300,
        child: chart,
      ),
    );

    return chartWidget;
  }

  Widget buildCustomersList(AsyncSnapshot<SalesModel> snapshot) {
    var data = snapshot.data!.sales[0].totals.values.toList();
    var series = [
      new charts.Series<Total, String>(
          id: 'Customers',
          colorFn: (_, __) => chartColor.shadeDefault,
          domainFn: (Total item, _) => item.key,
          measureFn: (Total item, _) => item.customers,
          data: data,
          labelAccessorFn: (Total item, _) => '${item.customers}')
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
      vertical: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      behaviors: [
        new charts.ChartTitle(AppLocalizations.of(context)
            .translate("customers"),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middle,
            innerPadding: 18),

      ],
    );

    var chartWidget = Card(
      elevation: 0,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: new Container(
        padding: new EdgeInsets.all(4.0),
        height: 300,
        child: chart,
      ),
    );

    return chartWidget;
  }

  Widget buildTaxList(AsyncSnapshot<SalesModel> snapshot) {
    var data = snapshot.data!.sales[0].totals.values.toList();
    var series = [
      new charts.Series<Total, String>(
          id: 'Tax',
          colorFn: (_, __) => chartColor.shadeDefault,
          domainFn: (Total item, _) => item.key,
          measureFn: (Total item, _) => double.parse(item.tax),
          data: data,
          labelAccessorFn: (Total item, _) => '${double.parse(item.tax).toInt()}')
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
      vertical: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      behaviors: [
        new charts.ChartTitle(AppLocalizations.of(context)
            .translate("tax"),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middle,
            innerPadding: 18),

      ],
    );

    var chartWidget = Card(
      elevation: 0,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: new Container(
        padding: new EdgeInsets.all(4.0),
        height: 300,
        child: chart,
      ),
    );

    return chartWidget;
  }

  Widget buildShippingList(AsyncSnapshot<SalesModel> snapshot) {
    var data = snapshot.data!.sales[0].totals.values.toList();
    var series = [
      new charts.Series<Total, String>(
          id: 'Shipping',
          colorFn: (_, __) => chartColor.shadeDefault,
          domainFn: (Total item, _) => item.key,
          measureFn: (Total item, _) => double.parse(item.shipping),
          data: data,
          labelAccessorFn: (Total item, _) => '${double.parse(item.shipping).toInt()}')
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
      vertical: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      behaviors: [
        new charts.ChartTitle(AppLocalizations.of(context)
            .translate("shipping"),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middle,
            innerPadding: 18),

      ],
    );

    var chartWidget = Card(
      elevation: 0,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: new Container(
        padding: new EdgeInsets.all(4.0),
        height: 300,
        child: chart,
      ),
    );

    return chartWidget;
  }

  Widget buildDiscountList(AsyncSnapshot<SalesModel> snapshot) {
    var data = snapshot.data!.sales[0].totals.values.toList();
    var series = [
      new charts.Series<Total, String>(
          id: 'Discounts',
          colorFn: (_, __) => chartColor.shadeDefault,
          domainFn: (Total item, _) => item.key,
          measureFn: (Total item, _) => double.parse(item.discount),
          data: data,
          labelAccessorFn: (Total item, _) => '${double.parse(item.discount).toInt()}')
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
      vertical: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      behaviors: [
        new charts.ChartTitle(AppLocalizations.of(context)
            .translate("discounts"),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middle,
            innerPadding: 18),

      ],
    );

    var chartWidget = Card(
      elevation: 0,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: new Container(
        padding: new EdgeInsets.all(4.0),
        height: 300,
        child: chart,
      ),
    );

    return chartWidget;
  }

  Widget buildTopSellersList(AsyncSnapshot<TopSellersModel> snapshot) {
    var series = [
      new charts.Series<TopSellers, String>(
          id: 'TopSellers',
          colorFn: (_, __) => chartColor.shadeDefault,
          domainFn: (TopSellers item, _) => item.name,
          measureFn: (TopSellers item, _) => item.quantity.round(),
          data: snapshot.data!.topSellers,
          labelAccessorFn: (TopSellers item, _) =>
              '${item.productId} Qty ${item.quantity.round().toString()}')
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
      vertical: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis:
      new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      behaviors: [
        new charts.ChartTitle(AppLocalizations.of(context)
            .translate("top_sellers"),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middle,
            innerPadding: 18),
      ],
    );

    var chartWidget = Card(
      elevation: 0,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: new Container(
        padding: new EdgeInsets.all(4.0),
        height: 300,
        child: chart,
      ),
    );

    return chartWidget;
  }

}
