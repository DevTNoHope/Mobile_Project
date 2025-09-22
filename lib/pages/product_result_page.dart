import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductResultPage extends StatelessWidget {
  final String barcode;
  final Product? product;
  final String? rawContent; // cho QR URL/text

  const ProductResultPage({
    super.key,
    required this.barcode,
    required this.product,
    this.rawContent,
  });
// --- NEW: bảng dinh dưỡng ---
  Widget _nutrimentsTable(Product p) {
    if (p.nutriments.isEmpty) return const SizedBox.shrink();

    // Map key -> nhãn dễ đọc
    const labelMap = <String, String>{
      'energy-kj': 'Energy',
      'energy-kcal': 'Energy (kcal)',
      'fat': 'Fat',
      'saturated-fat': 'Saturated fat',
      'carbohydrates': 'Carbohydrates',
      'sugars': 'Sugars',
      'fiber': 'Fiber',
      'proteins': 'Proteins',
      'salt': 'Salt',
      'sodium': 'Sodium',
      'calcium': 'Calcium',
    };

    String fmtNum(double v) =>
        (v % 1 == 0) ? v.toStringAsFixed(0) : v.toStringAsFixed(3);

    String fmtValue(NutrientValue v) {
      if (v.per100g == null) return '-';
      final numStr = fmtNum(v.per100g!);
      final unit = (v.unit?.isNotEmpty ?? false) ? ' ${v.unit}' : '';
      return '$numStr$unit';
    }

    final rows = <TableRow>[
      const TableRow(children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text('Nutrition facts',
              style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text('Per 100 g / 100 ml',
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ]),
    ];

    final used = <String>{};

    // 1) Gộp Energy nếu có
    final energyKj = p.nutriments['energy-kj'];
    final energyKcal = p.nutriments['energy-kcal'];
    final hasKj = energyKj?.per100g != null;
    final hasKcal = energyKcal?.per100g != null;
    if (hasKj || hasKcal) {
      String value = '';
      if (hasKj) value = fmtValue(energyKj!);
      if (hasKcal) {
        final kcalStr = fmtValue(energyKcal!);
        value = hasKj ? '$value ($kcalStr)' : kcalStr; // ví dụ: "406 kJ (97 kcal)"
      }
      rows.add(TableRow(children: [
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Text('Energy')),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Text(value, textAlign: TextAlign.right)),
      ]));
      if (hasKj) used.add('energy-kj');
      if (hasKcal) used.add('energy-kcal');
    }

    // 2) Thứ tự ưu tiên cho các chỉ số hay gặp
    const preferredOrder = <String>[
      'fat',
      'saturated-fat',
      'carbohydrates',
      'sugars',
      'fiber',
      'proteins',
      'salt',
      'sodium',
      'calcium',
    ];

    for (final key in preferredOrder) {
      final v = p.nutriments[key];
      if (v?.per100g == null) continue;
      used.add(key);
      rows.add(TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(labelMap[key] ?? key),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(fmtValue(v!), textAlign: TextAlign.right),
        ),
      ]));
    }

    // 3) Thêm các khóa còn lại (nếu có), sắp xếp alphabet
    final remainingKeys = p.nutriments.keys
        .where((k) => !used.contains(k) && p.nutriments[k]?.per100g != null)
        .toList()
      ..sort();
    for (final key in remainingKeys) {
      final v = p.nutriments[key]!;
      rows.add(TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(labelMap[key] ?? key),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(fmtValue(v), textAlign: TextAlign.right),
        ),
      ]));
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Table(
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
        border: const TableBorder(
          horizontalInside: BorderSide(color: Color(0x1F000000)),
          verticalInside: BorderSide(color: Color(0x1F000000)),
          top: BorderSide.none,
          bottom: BorderSide.none,
          left: BorderSide.none,
          right: BorderSide.none,
        ),
        children: rows,
      ),
    );
  }


  Widget _ingredientsSection(Product p) {
    final hasList = p.ingredients.isNotEmpty;
    final text = (p.ingredientsText ?? '').trim();

    if (!hasList && text.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ingredients', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (hasList)
            ...p.ingredients.map((i) => Row(
              children: [
                Expanded(child: Text(i.name)),
                if (i.percent != null)
                  Text('${i.percent!.toStringAsFixed(1)} %',
                      style: const TextStyle(color: Colors.black54)),
              ],
            )),
          if (hasList && text.isNotEmpty) const Divider(height: 16),
          if (text.isNotEmpty)
            Text(text, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _chips(String title, List<String> items, {Color? color}) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6, runSpacing: 6,
            children: items.map((e) => Chip(
              label: Text(e),
              backgroundColor: color?.withOpacity(.12),
              side: BorderSide(color: (color ?? Colors.black12)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRawUrl = () {
      if (rawContent == null) return false;
      final uri = Uri.tryParse(rawContent!);
      return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
    }();

    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (product != null || barcode != '—')
            Text('Mã vạch: $barcode', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          if (product != null) ...[
            if (product!.imageUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(product!.imageUrl!, height: 180, fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 12),
            _kv('Tên sản phẩm', product!.name),
            _kv('Thương hiệu', product!.brand),
            _kv('Quốc gia', product!.country),
            _kv('Quy cách', product!.quantityText),
            _ingredientsSection(product!),
            _chips('Allergens', product!.allergens, color: Colors.red),
            _chips('Additives', product!.additives, color: Colors.orange),
            _chips('Traces', product!.traces),
            _chips('Labels', product!.labels),
            // --- NEW: Nutrition facts ---
            _nutrimentsTable(product!),
            if (product!.nutriScore != null && product!.nutriScore!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('NutriScore: ${product!.nutriScore!.toUpperCase()}'),
              ),
            if (product!.novaGroup != null)
              Text('NOVA group: ${product!.novaGroup}'),

            if (product!.warning != null)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(product!.warning!, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
          ],

          if (product == null && rawContent != null) ...[
            Text('Nội dung mã:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            SelectableText(rawContent!),
            const SizedBox(height: 12),
            if (isRawUrl)
              FilledButton.icon(
                onPressed: () => launchUrl(Uri.parse(rawContent!), mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Mở liên kết'),
              ),
          ],

          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Nguồn: OpenFoodFacts. Các giá trị hiển thị là per 100g/100ml; có thể thiếu với một số sản phẩm.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String label, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
