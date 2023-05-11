import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pororo/controller/database.dart';
import 'package:pororo/models/product.dart';

class ProductController {
  // Өгөгдлийн сангийн products table хандаж байгаа
  CollectionReference products = Database.firestore.collection('products');

  // Бүтээгдэхүүнээс нэр болон дэлгүүрээр хайж байгаа
  // Product ийн seller_id - г дэлгүүрийн id гаар шалгаж хайж байгаа
  // Product ийн product_name - г дурын утгыг агуулсан эсэхээр шалгаж хайж байгаа
  Future<List<Product>> searchProducts({required String value, String? storeId}) async {
    Query query = products;

    if (storeId != null) {
      query = query.where('seller_id', isEqualTo: storeId);
    }

    if (value.isNotEmpty) {
      query = query.where('product_name', isGreaterThanOrEqualTo: value, isLessThan: '$value\uf8ff');
    }

    final result = await query.get();
    List<Product> data = result.docs.map((e) => Product.fromSnapshot(e)).toList();
    return data;
  }

  // Бүх барааг хайж байгаа
  Future<List<Product>> getProducts() async {
    final result = await products.limit(5).get();
    List<Product> data = result.docs.map((e) => Product.fromSnapshot(e)).toList();

    return data;
  }

  // Бүтээгдэхүүнээс онцолсон барааг хайж байгаа
  // Product ийн special - г true утгаар хайж байгаа
  Future<List<Product>> getSpecialProducts() async {
    final result = await products.where('special', isEqualTo: true).limit(5).get();
    List<Product> data = result.docs.map((e) => Product.fromSnapshot(e)).toList();

    return data;
  }

  // Бүтээгдэхүүнээс нэмэгдсэн дарааллаар хайж байгаа
  // Product ийн created_at - г буурахаар эрэмбэлж хайж байгаа
  Future<List<Product>> getNewProducts() async {
    final result = await products.orderBy('created_at', descending: true).limit(5).get();
    List<Product> data = result.docs.map((e) => Product.fromSnapshot(e)).toList();

    return data;
  }

  // Бүтээгдэхүүнээс хямдралтай барааг хайж байгаа.
  // Product ийн discount г 0 - ээс их утгаар хайж байгаа
  Future<List<Product>> getDiscountedProducts() async {
    final result = await products.where('discount', isGreaterThan: 0).limit(5).get();
    List<Product> data = result.docs.map((e) => Product.fromSnapshot(e)).toList();

    return data;
  }

  // Дэлгүүрийн бараа бүтээгдэхүүнийг хайж олж байгаа query.
  // Product ийн seller_id г дэлгүүрийн storeId - гаар шалгаж хайж байгаа
  Future<List<Product>> getStoreProducts(String storeId) async {
    final result = await products.where('seller_id', isEqualTo: storeId).get();
    List<Product> data = result.docs.map((e) => Product.fromSnapshot(e)).toList();

    return data;
  }

  Future<Product> getFirstProduct() async {
    final result = await products.where('category_id', isEqualTo: 'category_3').limit(1).get();
    Product data = Product.fromSnapshot(result.docs.first);

    return data;
  }

  Future<Product> getProduct(String productId) async {
    final result = await products.doc(productId).get();
    Product product = Product.fromSnapshot(result);

    return product;
  }
}
