import 'package:admin/src/blocs/coupons/coupon_bloc.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/models/coupons/coupons_model.dart';
import 'package:admin/src/ui/language/app_localizations.dart';
import 'edit_coupon.dart';

class CouponDetail extends StatefulWidget {
  CouponsBloc couponsBloc = CouponsBloc();

  final Coupon coupon;
  CouponDetail({Key? key, required this.coupon}) : super(key: key);
  @override
  _CouponDetailState createState() => _CouponDetailState(coupon);
}

class _CouponDetailState extends State<CouponDetail> {
  final Coupon coupon;

  _CouponDetailState(this.coupon);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("coupon_detail")),
        actions: <Widget>[
        /*  IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditCoupon(coupon: coupon)),
                );
              }),*/
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.couponsBloc.deleteItem(coupon);
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: Text(AppLocalizations.of(context).translate("id")),
              subtitle: Text(coupon.id.toString()),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("coupon_code")),
              subtitle: Text(coupon.code),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("discount_type")),
              subtitle: Text(coupon.discountType),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("coupon_amount")),
              subtitle: Text(coupon.amount),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("description")),
              subtitle: Text(coupon.description),
            ),
          ],
        ).toList(),
      ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditCoupon(coupon: coupon)),
            );
          },
        child: Icon(Icons.edit),
      ),
    );
  }
}
