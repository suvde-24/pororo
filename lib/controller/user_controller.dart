import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../models/cart.dart';
import '../models/favorite.dart';
import '../models/order.dart' as model;
import 'database.dart';

class UserController {
  UserController._internal();

  static UserController get instance => _getInstance();
  static UserController? _instance;

  factory UserController() {
    return _getInstance();
  }

  static UserController _getInstance() {
    _instance ??= UserController._internal();

    return _instance!;
  }

  //

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference userStore = Database.firestore.collection('customers');
  ValueNotifier<Map<String, dynamic>> currentUserData = ValueNotifier({});
  String get uid => currentUserData.value['id'];

  void init() {
    if (auth.currentUser != null) {
      fetchUserInfo(auth.currentUser!);
    }
  }

  Future<bool> loginUser({required String email, required String password}) async {
    try {
      EasyLoading.show(status: 'түр хүлээнэ үү');
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      EasyLoading.dismiss();
      fetchUserInfo(credential.user!);

      return true;
    } catch (e) {
      EasyLoading.dismiss();
      switch ((e as FirebaseAuthException).code) {
        case 'invalid-email':
        case 'user-disabled':
        case 'user-not-found':
          EasyLoading.showInfo('Бүртгэлтэй хэрэглэгч олдсонгүй.', dismissOnTap: true);
          break;
        case 'wrong-password':
          EasyLoading.showError('Нууц үг буруу байна.', dismissOnTap: true);
          break;
        default:
      }

      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      EasyLoading.show(status: 'түр хүлээнэ үү');
      await auth.signOut();
      EasyLoading.dismiss();
      currentUserData.value = {};

      return true;
    } catch (e) {
      EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> registerUser({required String email, required String password, required String name}) async {
    try {
      EasyLoading.show(status: 'түр хүлээнэ үү');
      UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      await createUserStore(credential.user!, name: name);
      EasyLoading.dismiss();
      auth.signOut();
      EasyLoading.showSuccess('Амжилттай бүртгэгдлээ.', dismissOnTap: true);

      return true;
    } catch (e) {
      EasyLoading.dismiss();
      switch ((e as FirebaseAuthException).code) {
        case 'email-already-in-use':
          EasyLoading.showInfo('Бүртгэлтэй цахим хаяг байна.', dismissOnTap: true);
          break;
        case 'invalid-email':
          EasyLoading.showError('Цахим хаягаа буруу байна.', dismissOnTap: true);
          break;
        case 'operation-not-allowed':
          EasyLoading.showError('Алдаа гарлаа.', dismissOnTap: true);
          break;
        case 'weak-password':
          EasyLoading.showError('Нууц үг шаардлага хангахгүй байна.', dismissOnTap: true);
          break;
        default:
      }
      return false;
    }
  }

  Future<bool> resetPassword({required String email}) async {
    try {
      EasyLoading.show(status: 'түр хүлээнэ үү');
      await auth.sendPasswordResetEmail(email: email);
      EasyLoading.showSuccess('Та цахим хаягаа шалгана уу.', dismissOnTap: true);

      EasyLoading.dismiss();
      return true;
    } catch (e) {
      EasyLoading.dismiss();
      switch ((e as FirebaseAuthException).code) {
        case 'invalid-email':
        case 'user-not-found':
          EasyLoading.showError('Бүртгэлтэй хэрэглэгч олдсонгүй.');
          break;
        default:
          EasyLoading.showError('Алдаа гарлаа.');
      }
      return false;
    }
  }

  Future<void> createUserStore(User user, {required String name}) async {
    await userStore.doc(user.uid).set({
      'email': user.email,
      'name': name,
      'address': '',
      'created_at': Timestamp.now(),
    });

    return;
  }

  void updateUserInfo({required String name, String address = ''}) async {
    EasyLoading.show(status: 'түр хүлээнэ үү');
    currentUserData.value = currentUserData.value
      ..['name'] = name
      ..['address'] = address;
    await userStore.doc(uid).update(currentUserData.value);
    EasyLoading.showSuccess('Амжилттай');
  }

  void fetchUserInfo(User user) async {
    final result = await userStore.doc(user.uid).get();
    currentUserData.value = result.data() as dynamic;
    currentUserData.value['id'] = user.uid;
    // EasyLoading.showToast('Тавтай морил', dismissOnTap: true);

    fetchCarts();
    fetchOrders();
    fetchFavorites();
  }

  // User action query

  CollectionReference orders = Database.firestore.collection('orders');
  CollectionReference orderItems = Database.firestore.collection('order_items');
  CollectionReference transactions = Database.firestore.collection('transactions');
  CollectionReference shipping = Database.firestore.collection('shipping');
  CollectionReference carts = Database.firestore.collection('carts');
  CollectionReference favorites = Database.firestore.collection('favorites');

  ValueNotifier<List<Cart>> cartItems = ValueNotifier([]);
  ValueNotifier<List<Favorite>> favoriteItems = ValueNotifier([]);
  ValueNotifier<List<model.Order>> userOrders = ValueNotifier([]);

  double get totalCartPrice => cartItems.value.fold(
        0,
        (previousValue, element) => previousValue + (element.product.value?.discountedTotalPrice ?? 1) * element.count.value,
      );

  Future<List<Cart>> fetchCarts() async {
    final result = await carts.where('customer_id', isEqualTo: uid).get();
    List<Cart> data = result.docs.map((e) => Cart.fromSnapshot(e)).toList();
    cartItems.value = data;

    return data;
  }

  Future<List<model.Order>> fetchOrders() async {
    final result = await orders.where('customer_id', isEqualTo: uid).get();
    List<model.Order> data = result.docs.map((e) => model.Order.fromSnapshot(e)).toList();
    for (var item in data) {
      final result = await orderItems.where('order_id', isEqualTo: item.id).get();
      List<model.OrderItem> items = result.docs.map((e) => model.OrderItem.fromSnapshot(e)).toList();
      item.orderItems = items;
    }
    userOrders.value = data;

    return data;
  }

  Future<List<Favorite>> fetchFavorites() async {
    final result = await favorites.where('customer_id', isEqualTo: uid).get();
    List<Favorite> data = result.docs.map((e) => Favorite.fromSnapshot(e)).toList();
    favoriteItems.value = data;

    return data;
  }

  Future<bool> addToCarts(String productId) async {
    try {
      final result = await carts.add({'customer_id': uid, 'product_id': productId, 'count': 1});
      Cart data = Cart.fromSnapshot(await result.get());
      cartItems.value = [data, ...cartItems.value];
      EasyLoading.showSuccess('Амжилттай');
      return true;
    } catch (e) {
      EasyLoading.showInfo('Алдаа');
      return false;
    }
  }

  Future<bool> addToFavorites(String productId) async {
    try {
      final result = await favorites.add({'customer_id': uid, 'product_id': productId});
      Favorite data = Favorite.fromSnapshot(await result.get());
      favoriteItems.value = [data, ...favoriteItems.value];
      EasyLoading.showSuccess('Амжилттай');
      return true;
    } catch (e) {
      EasyLoading.showInfo('Алдаа');
      return false;
    }
  }

  Future<bool> removeFromCarts(String docId) async {
    try {
      await carts.doc(docId).delete();
      cartItems.value = cartItems.value.where((e) => e.id != docId).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCartItem(String docId, int quantity) async {
    try {
      EasyLoading.show();
      await carts.doc(docId).update({'count': quantity});
      EasyLoading.dismiss();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromFavorites(String docId) async {
    try {
      await favorites.doc(docId).delete();
      favoriteItems.value = favoriteItems.value.where((e) => e.id != docId).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Order
  Future<bool> newOrder() async {
    EasyLoading.show(status: 'Түр хүлээнэ үү...');
    //
    final result = await orders.add({
      'created_at': Timestamp.now(),
      'customer_id': uid,
      'modified_at': Timestamp.now(),
      'shipping_id': null,
      'status': 'pending',
      'total_payment': totalCartPrice,
      'transaction_id': null,
    });
    model.Order newOrder = model.Order.fromSnapshot(await result.get());
    List<model.OrderItem> items = [];
    //
    final transactionResult = await transactions.add({
      'amount': newOrder.totalPayment,
      'created_at': Timestamp.now(),
      'modified_at': Timestamp.now(),
      'order_id': newOrder.id,
      'status': 'pending',
    });
    await orders.doc(newOrder.id).update({'transaction_id': transactionResult.id});
    newOrder.transactionId = transactionResult.id;
    //
    final shippingResult = await shipping.add({
      'created_at': Timestamp.now(),
      'customer': newOrder.customerId,
      'modified_at': Timestamp.now(),
      'shipping_address': currentUserData.value['address'],
      'shipping_amount': 0,
      'shipping_status': 'pending',
    });
    await orders.doc(newOrder.id).update({'shipping_id': shippingResult.id});
    newOrder.shippingId = shipping.id;
    //
    for (var item in cartItems.value) {
      final json = {
        'created_at': Timestamp.now(),
        'order_id': newOrder.id,
        'product_id': item.productId,
        'quantity': item.count.value,
      };
      final result = await orderItems.add(json);
      model.OrderItem newOrderItem = model.OrderItem.fromSnapshot(await result.get());
      items.add(newOrderItem);
    }
    //
    newOrder.orderItems = items;
    userOrders.value = [newOrder, ...userOrders.value];
    //
    final queryCarts = await carts.where('customer_id', isEqualTo: uid).get();
    for (var e in queryCarts.docs) {
      carts.doc(e.id).delete();
    }
    cartItems.value = [];
    //
    EasyLoading.dismiss();
    return true;
  }

  Future<void> cancelOrder(String orderId, String transactionId) async {
    EasyLoading.show(status: 'Түр хүлээнэ үү...');
    await orders.doc(orderId).update({'status': 'canceled', 'modified_at': Timestamp.now()});
    await transactions.doc(transactionId).update({'status': 'canceled', 'modified_at': Timestamp.now()});

    final canceledOrder = userOrders.value.firstWhere((e) => e.id == orderId);
    canceledOrder.status = model.OrderStatus.canceled;
    userOrders.value = [...userOrders.value.where((e) => e.id != orderId).toList(), canceledOrder];
    EasyLoading.dismiss();

    return;
  }
}
