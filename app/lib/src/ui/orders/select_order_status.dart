import 'package:admin/src/models/app_state_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderStatus extends StatefulWidget {
  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)
            .translate("order_status")),
      ),
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
          return ListView(
            children: [
              RadioListTile<String>(
                value: 'pending',
                groupValue: model.order.status,
                onChanged: (value) {
                  model.order.status = value;
                  model.updateOrder(model.order);
                  Navigator.of(context).pop(value);
                },
                title: Text(AppLocalizations.of(context)
                    .translate("pending_payment")),
              ),
              RadioListTile<String>(
                value: 'processing',
                groupValue: model.order.status,
                onChanged: (value) {
                  model.order.status = value;
                  model.updateOrder(model.order);
                  Navigator.of(context).pop(value);
                },
                title: Text(AppLocalizations.of(context)
                    .translate("processing")),
              ),
              RadioListTile<String>(
                value: 'on-hold',
                groupValue: model.order.status,
                onChanged: (value) {
                  model.order.status = value;
                  model.updateOrder(model.order);
                  Navigator.of(context).pop(value);
                },
                title: Text(AppLocalizations.of(context)
                    .translate("on_hold"),),
              ),
              RadioListTile<String>(
                value: 'completed',
                groupValue: model.order.status,
                onChanged: (value) {
                  model.order.status = value;
                  model.updateOrder(model.order);
                  Navigator.of(context).pop(value);
                },
                title: Text(AppLocalizations.of(context)
                    .translate("completed"),),
              ),
              RadioListTile<String>(
                value: 'cancelled',
                groupValue: model.order.status,
                onChanged: (value) {
                  model.order.status = value;
                  model.updateOrder(model.order);
                  Navigator.of(context).pop(value);
                },
                title: Text(AppLocalizations.of(context)
                    .translate("cancelled"),),
              ),
              RadioListTile<String>(
                value: 'refunded',
                groupValue: model.order.status,
                onChanged: (value) {
                  model.order.status = value;
                  model.updateOrder(model.order);
                  Navigator.of(context).pop(value);
                },
                title: Text(AppLocalizations.of(context)
                    .translate("refunded"),),
              ),
              RadioListTile<String>(
                value: 'failed',
                groupValue: model.order.status,
                onChanged: (value) {
                  model.order.status = value;
                  model.updateOrder(model.order);
                  Navigator.of(context).pop(value);
                },
                title: Text(AppLocalizations.of(context)
                    .translate("failed"),),
              )
            ],
          );
        }
      ),
    );
  }
}
