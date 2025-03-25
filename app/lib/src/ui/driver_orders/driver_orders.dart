import 'package:admin/src/ui/driver_orders/accepted_orders.dart';
import 'package:admin/src/ui/driver_orders/completed_orders.dart';
import 'package:admin/src/ui/driver_orders/new_orders.dart';
import 'package:flutter/material.dart';

class DriverOrders extends StatefulWidget {
  final String driverId;
  const DriverOrders({Key? key, required this.driverId}) : super(key: key);
  @override
  State<DriverOrders> createState() => _DriverOrdersState();
}

class _DriverOrdersState extends State<DriverOrders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text('New')),
              Tab(icon: Text('Accepted')),
              Tab(icon: Text('Completed')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NewOrdersPage(driverId: widget.driverId),
            AcceptedOrdersPage(driverId: widget.driverId),
            CompletedOrdersPage(driverId: widget.driverId),
          ],
        ),
      ),
    );
  }
}

