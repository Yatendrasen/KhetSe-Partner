import 'dart:async';
import 'package:admin/src/models/coupons/coupons_model.dart';
import 'package:admin/src/models/order_note/order_notes_model.dart';
import 'package:admin/src/models/payment/payment_gateways_model.dart';
import 'package:admin/src/models/refund/refund_model.dart';
import 'package:admin/src/models/sales/sales_model.dart';
import 'package:admin/src/models/sales/top_sellers_model.dart';

import 'api_provider.dart';
import 'package:admin/src/models/product/product_model.dart';
import 'package:admin/src/models/category/category_model.dart';
import 'package:admin/src/models/orders/orders_model.dart';
import 'package:admin/src/models/customer/customer_model.dart';

class Repository {
  final productApiProvider = ApiProvider();

  Future<ProductsModel> fetchAllProducts([String? filter]) =>
      productApiProvider.fetchProductList(filter);
  Future<CategoriesModel> fetchAllProductDetail(int id) =>
      productApiProvider.fetchProductDetail(id);
  Future<Product> editProduct(Product product) =>
      productApiProvider.editProduct(product);
  Future<Product> addProduct(Product product) =>
      productApiProvider.addProduct(product);
  Future<Product> deleteProduct(Product product) =>
      productApiProvider.deleteProduct(product);

  Future<CategoriesModel> fetchCategories([String? filter]) =>
      productApiProvider.fetchCategoryList(filter);
  Future<Category> addCategory(Category category) =>
      productApiProvider.addCategory(category);
  Future<Category> deleteCategory(Category category) =>
      productApiProvider.deleteCategory(category);
  Future<Category> editCategory(Category category) =>
      productApiProvider.editCategory(category);

  Future<List<Customer>> fetchAllCustomers([String? filter]) =>
      productApiProvider.fetchCustomerList(filter);
  Future<Customer> addCustomer(Customer customer) =>
      productApiProvider.addCustomer(customer);
  Future<Customer> editCustomer(Customer customer) =>
      productApiProvider.editCustomer(customer);
  Future<Customer> deleteCustomer(Customer customer) =>
      productApiProvider.deleteCustomer(customer);

  Future<OrdersModel> fetchAllOrderDetail(int id) =>
      productApiProvider.fetchOrderDetail(id);
  Future<OrdersModel> fetchAllOrders([String? filter]) =>
      productApiProvider.fetchOrderList(filter);
  Future<Order> addOrders(Order order) => productApiProvider.addOrder(order);
  Future<Order> editOrder(Order order) => productApiProvider.editOrder(order);
  Future<Order> deleteOrder(Order order) =>
      productApiProvider.deleteOrder(order);

  Future<SalesModel> fetchSalesReport(String period) =>
      productApiProvider.fetchSalesReport(period);
  Future<TopSellersModel> fetchTopSellersReport(String period) =>
      productApiProvider.fetchTopSellersReport(period);

  Future<CouponsModel> fetchCoupons([String? filter]) =>
      productApiProvider.fetchCouponList(filter);
  Future<Coupon> addCoupon(Coupon coupon) =>
      productApiProvider.addCoupon(coupon);
  Future<Coupon> editCoupon(Coupon coupon) =>
      productApiProvider.editCoupon(coupon);
  Future<Coupon> deleteCoupon(Coupon coupon) =>
      productApiProvider.deleteCoupon(coupon);

  Future<OrderNotesModel> fetchAllOrderNotes(filter, id) =>
      productApiProvider.fetchAllOrderNotes(filter, id);
  Future<OrderNote> addOrderNotes(OrderNote ordernotes, String id) =>
      productApiProvider.addOrderNotes(ordernotes, id);
  Future<OrderNote> deleteOrderNotes(OrderNote ordernotes, String id) =>
      productApiProvider.deleteOrderNotes(ordernotes, id);

  Future<PaymentGatewaysModel> fetchPaymentGateways([String? filter]) =>
      productApiProvider.fetchPaymentGatewayList(filter);
  Future<PaymentGateway> editPaymentGateway(PaymentGateway paymentGateway) =>
      productApiProvider.editPaymentGateway(paymentGateway);

  Future<RefundsModel> fetchRefunds(filter, id) =>
      productApiProvider.fetchRefundList(filter, id);
  Future<Refund> addRefund(Refund refund, id) =>
      productApiProvider.addRefund(refund, id);
  Future<Refund> deleteRefund(Refund refund, id) =>
      productApiProvider.deleteRefund(refund, id);
}
