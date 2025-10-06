import 'package:flutter/material.dart';

class RedeemVoucherPage extends StatefulWidget {
  const RedeemVoucherPage({super.key});

  @override
  State<RedeemVoucherPage> createState() => _RedeemVoucherPageState();
}

class _RedeemVoucherPageState extends State<RedeemVoucherPage> {
  // Điểm ban đầu
  int currentPoints = 0;

  // Cấu hình các loại voucher demo ĐA DẠNG HƠN
  final List<_VoucherOption> _options = const [
    _VoucherOption(title: 'Voucher 10.000đ', cost: 100, type: 'Giảm giá tiền mặt'),
    _VoucherOption(title: 'Voucher 20.000đ', cost: 180, type: 'Giảm giá tiền mặt'),
    // Thêm các loại voucher như MoMo
    _VoucherOption(title: 'Giảm 30K Hóa đơn Internet', cost: 250, type: 'Giảm giá dịch vụ'),
    _VoucherOption(title: 'Giảm 2K Di động Trả sau', cost: 120, type: 'Giảm giá dịch vụ'),
    _VoucherOption(title: 'Hoàn 10K Thanh toán Bảo hiểm', cost: 350, type: 'Hoàn tiền'),
    _VoucherOption(title: 'Tặng 10K Nạp ePass', cost: 150, type: 'Thưởng nạp tiền'),
    _VoucherOption(title: 'Ưu đãi 35K Phúc Long Coffee', cost: 400, type: 'Ăn uống'),
    _VoucherOption(title: 'Ưu đãi 50K KATINAT', cost: 450, type: 'Ăn uống'),
    _VoucherOption(title: 'Freeship 20K', cost: 150, type: 'Vận chuyển'),
    _VoucherOption(title: 'Giảm 10% (Max 50K)', cost: 250, type: 'Giảm giá phần trăm'),
  ];

  _VoucherOption? _selected;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selected = _options.first;
  }

  void _addPoints(int pointsToAdd) {
    setState(() {
      currentPoints += pointsToAdd;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Tích thành công $pointsToAdd điểm! Điểm hiện có: $currentPoints'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _redeemVoucher() {
    if (!canRedeem) return;

    final cost = totalCost;
    final voucherTitle = _selected!.title;
    final quantity = _quantity;

    setState(() {
      currentPoints -= cost;
      _quantity = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Đổi thành công $quantity x $voucherTitle với $cost điểm!'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  int get totalCost => (_selected?.cost ?? 0) * _quantity;
  bool get canRedeem => totalCost > 0 && totalCost <= currentPoints;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi điểm sang voucher'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xfff5f6fa),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Nút Mô phỏng Tích điểm
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _addPoints(150),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Mô phỏng: Quét mã/Đóng góp (+150 điểm)'),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Thẻ điểm hiện có
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.stars_rounded, color: cs.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Điểm hiện có',
                              style: TextStyle(
                                  color: cs.onPrimaryContainer.withOpacity(.8))),
                          const SizedBox(height: 4),
                          Text(
                            '$currentPoints điểm',
                            style: TextStyle(
                              color: cs.onPrimaryContainer,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: (currentPoints % 1000) / 1000,
                            backgroundColor: cs.onPrimaryContainer.withOpacity(.12),
                            color: cs.primary,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Còn ${(1000 - (currentPoints % 1000))} điểm để lên hạng',
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onPrimaryContainer.withOpacity(.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Chọn loại voucher
              _Section(
                title: 'Chọn loại voucher',
                child: DropdownButtonFormField<_VoucherOption>(
                  value: _selected,
                  isExpanded: true, // ✅ tránh tràn viền, cho dropdown full width
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Chọn voucher',
                    isDense: true, // gọn gàng hơn, có thể bỏ nếu muốn cao hơn
                  ),
                  items: _options.map((o) {
                    return DropdownMenuItem<_VoucherOption>(
                      value: o,
                      // ❗ KHÔNG dùng Expanded/Flexible ở đây
                      child: Text(
                        '${o.title} (${o.type}) • ${o.cost} điểm',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // ✅ cắt bớt nếu quá dài
                      ),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _selected = v),
                ),
              ),
              const SizedBox(height: 12),

              // Số lượng
              _Section(
                title: 'Số lượng',
                child: Row(
                  children: [
                    _RoundIconBtn(
                      icon: Icons.remove,
                      onTap: () => setState(() {
                        if (_quantity > 1) _quantity--;
                      }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border:
                          Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _RoundIconBtn(
                      icon: Icons.add,
                      onTap: () => setState(() => _quantity++),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Xem trước (Thêm hiển thị Loại voucher để minh họa)
              _Section(
                title: 'Xem trước',
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_selected?.title ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Loại: ${_selected?.type ?? ''}', style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 6),
                      Text('Số lượng: $_quantity'),
                      const SizedBox(height: 6),
                      Text('Tổng điểm cần: $totalCost'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            canRedeem ? Icons.check_circle : Icons.error,
                            color: canRedeem ? Colors.green : Colors.redAccent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              canRedeem
                                  ? 'Đủ điểm để đổi.'
                                  : 'Điểm không đủ. Hãy giảm số lượng hoặc chọn voucher khác.',
                              style: TextStyle(
                                color: canRedeem
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Điều khoản
              _Section(
                title: 'Điều kiện sử dụng',
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    '• Voucher không có giá trị quy đổi thành tiền mặt.\n'
                        '• Mỗi đơn hàng chỉ dùng 1 voucher.\n'
                        '• Hạn dùng 30 ngày kể từ ngày đổi.\n'
                        '• Áp dụng theo điều khoản của chương trình.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Nút Đổi điểm
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: canRedeem ? _redeemVoucher : null,
                  icon: const Icon(Icons.card_giftcard),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Đổi điểm ngay'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _RoundIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}

class _VoucherOption {
  final String title;
  final int cost; // điểm cần dùng
  final String type; // Thêm trường mới để phân loại voucher
  const _VoucherOption({required this.title, required this.cost, this.type = 'Khác'});
}