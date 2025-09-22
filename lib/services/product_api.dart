// lib/services/product_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  final s = v.toString().replaceAll(',', '.');
  return double.tryParse(s);
}

String _labelize(dynamic v) {
  if (v == null) return '';
  final s = v.toString();
  return s.startsWith('en:') || s.contains(':') ? s.split(':').last.replaceAll('-', ' ') : s;
}

List<String> _stringTags(dynamic v) {
  if (v == null) return const [];
  if (v is List) return v.map((e) => _labelize(e)).where((e) => e.isNotEmpty).toList();
  if (v is String && v.isNotEmpty) {
    // OFF đôi khi trả chuỗi “en:milk,en:nuts”
    return v.split(',').map((e) => _labelize(e.trim())).where((e) => e.isNotEmpty).toList();
  }
  return const [];
}

NutrientValue _nv(Map<String, dynamic> n, String key100g) => NutrientValue(
  per100g: _toDouble(n['${key100g}_100g']),
  unit: (n['${key100g}_unit'])?.toString(),
);

class ProductApi {
  static Future<Product?> fetchByBarcode(String barcode) async {
    // Thu gọn payload bằng fields=
    final fields = [
      'product_name','brands','countries','image_url','image_front_url','quantity',
      'nutriments','ingredients_text','ingredients',
      'allergens_tags','additives_tags','traces_tags',
      'labels_tags','categories_tags',
      'nutriscore_grade','nova_group',
    ].join(',');

    final url = Uri.parse(
        'https://world.openfoodfacts.org/api/v2/product/$barcode.json?fields=$fields'
    );

    final res = await http.get(url, headers: {'User-Agent':'SmartScan/1.0 (Flutter student project)'});
    if (res.statusCode != 200) return null;

    final root = jsonDecode(res.body) as Map<String, dynamic>;
    if (root['status'] != 1) {
      return Product(barcode: barcode, warning: 'Chưa có dữ liệu xác thực');
    }

    final p = (root['product'] ?? {}) as Map<String, dynamic>;
    final n = (p['nutriments'] ?? {}) as Map<String, dynamic>;

    // Parse ingredients list
    final ingListRaw = (p['ingredients'] ?? []) as List<dynamic>;
    final ingredients = ingListRaw.map((e) {
      final m = (e ?? {}) as Map<String, dynamic>;
      return IngredientItem(
        name: _labelize(m['text']),
        percent: _toDouble(m['percent']),
        vegan: m['vegan']?.toString(),
        vegetarian: m['vegetarian']?.toString(),
      );
    }).where((it) => it.name.isNotEmpty).toList();

    // Nutriments (ví dụ phổ biến)
    final nutriments = <String, NutrientValue>{
      'energy-kj': NutrientValue(
        per100g: _toDouble(n['energy-kj_100g']) ?? _toDouble(n['energy_100g']),
        unit: (n['energy-kj_unit'] ?? n['energy_unit'])?.toString(),
      ),
      'energy-kcal': NutrientValue(
        per100g: _toDouble(n['energy-kcal_100g']),
        unit: (n['energy-kcal_unit'] ?? 'kcal').toString(),
      ),
      'fat': _nv(n,'fat'),
      'saturated-fat': _nv(n,'saturated-fat'),
      'carbohydrates': _nv(n,'carbohydrates'),
      'sugars': _nv(n,'sugars'),
      'fiber': _nv(n,'fiber'),
      'proteins': _nv(n,'proteins'),
      'salt': _nv(n,'salt'),
      'sodium': _nv(n,'sodium'),
      'calcium': _nv(n,'calcium'),
    };

    return Product(
      barcode: barcode,
      name: (p['product_name'] ?? '') as String?,
      brand: (p['brands'] ?? '') as String?,
      country: (p['countries'] ?? '') as String?,
      imageUrl: (p['image_url'] ?? p['image_front_url'])?.toString(),
      quantityText: (p['quantity'] ?? '') as String?,
      nutriments: nutriments,
      ingredientsText: (p['ingredients_text'] ?? '') as String?,
      ingredients: ingredients,
      allergens: _stringTags(p['allergens_tags']),
      additives: _stringTags(p['additives_tags']),
      traces: _stringTags(p['traces_tags']),
      labels: _stringTags(p['labels_tags']),
      categories: _stringTags(p['categories_tags']),
      nutriScore: (p['nutriscore_grade'] ?? '') as String?,
      novaGroup: (p['nova_group'] is num) ? (p['nova_group'] as num).toInt() : null,
    );
  }
}
