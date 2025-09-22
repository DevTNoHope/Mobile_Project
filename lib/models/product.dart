class NutrientValue {
  final double? per100g;   // giá trị/100g hoặc 100ml
  final String? unit;      // g, mg, kcal, kj, %

  const NutrientValue({this.per100g, this.unit});
}
class IngredientItem {
  final String name;
  final double? percent;
  final String? vegan;
  final String? vegetarian;


  const IngredientItem({
    required this.name,
    this.percent,
    this.vegan,
    this.vegetarian,
  });
}
class Product {
  final String barcode;
  final String? name;
  final String? brand;
  final String? country;
  final String? imageUrl;
  final String? quantityText;
  final String? warning;

  // NEW: dinh dưỡng (key theo OpenFoodFacts)
  final Map<String, NutrientValue> nutriments;

  final String? ingredientsText;
  final List<IngredientItem> ingredients;
  final List<String> allergens;
  final List<String> additives;
  final List<String> traces;
  final List<String> labels;
  final List<String> categories;
  final String? nutriScore;
  final int? novaGroup;

  Product({
    required this.barcode,
    this.name,
    this.brand,
    this.country,
    this.imageUrl,
    this.quantityText,
    this.warning,
    this.nutriments = const {},
    this.ingredientsText,
    this.ingredients = const [],
    this.allergens = const [],
    this.additives = const [],
    this.traces = const [],
    this.labels = const [],
    this.categories = const [],
    this.nutriScore,
    this.novaGroup,
  });
}
