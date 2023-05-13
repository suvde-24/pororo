import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../models/cart.dart';
import '../models/favorite.dart';
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
    fetchFavorites();
  }

  // User action query

  CollectionReference carts = Database.firestore.collection('carts');
  CollectionReference orders = Database.firestore.collection('orders');
  CollectionReference favorites = Database.firestore.collection('favorites');

  ValueNotifier<List<Cart>> cartItems = ValueNotifier([]);
  ValueNotifier<List<Favorite>> favoriteItems = ValueNotifier([]);

  Future<List<Cart>> fetchCarts() async {
    final result = await carts.where('customer_id', isEqualTo: uid).get();
    List<Cart> data = result.docs.map((e) => Cart.fromSnapshot(e)).toList();
    cartItems.value = data;

    return data;
  }

  void fetchOrders() async {
    await orders.where('customer_id', isEqualTo: uid).get();
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
  void newOrder() {}
}
