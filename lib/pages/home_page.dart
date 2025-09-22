import 'package:flutter/material.dart';
import 'generate_qr_page.dart';
import 'scan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _todo(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name: tính năng sẽ được thêm sau')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            elevation: 0,
            backgroundColor: cs.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: _Header(),
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 12),
              title: Text('Smart Scan', style: TextStyle(color: cs.onSurface)),
            ),
          ),

          // 2 nút chính
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _PrimaryAction(
                      icon: Icons.qr_code_scanner_rounded,
                      label: 'Quét mã',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ScanPage()),
                      ),
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PrimaryAction(
                      icon: Icons.qr_code_2_rounded,
                      label: 'Tạo QR',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GenerateQRPage()),
                      ),
                      color: cs.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lưới thẻ phụ
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final cross = width > 700 ? 4 : width > 520 ? 3 : 2;
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildListDelegate.fixed([
                    _FeatureCard(
                      icon: Icons.photo_library_rounded,
                      title: 'Ảnh có sẵn',
                      subtitle: 'Chọn ảnh để quét',
                      onTap: () => _todo(context, 'Ảnh có sẵn'),
                    ),
                    _FeatureCard(
                      icon: Icons.history_rounded,
                      title: 'Lịch sử',
                      subtitle: 'Các mã đã quét',
                      onTap: () => _todo(context, 'Lịch sử'),
                    ),
                    _FeatureCard(
                      icon: Icons.info_outline_rounded,
                      title: 'Hướng dẫn',
                      subtitle: 'Cách sử dụng app',
                      onTap: () => _todo(context, 'Hướng dẫn'),
                    ),
                    _FeatureCard(
                      icon: Icons.settings_rounded,
                      title: 'Cài đặt',
                      subtitle: 'Giao diện & quyền',
                      onTap: () => _todo(context, 'Cài đặt'),
                    ),
                  ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primaryContainer,
            cs.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cs.surface.withOpacity(.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.qr_code_rounded, size: 34, color: cs.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Xin chào 👋',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: cs.onPrimaryContainer)),
                    const SizedBox(height: 6),
                    Text(
                      'Quét mã để xem thông tin sản phẩm\nhoặc tạo QR để chia sẻ nhanh.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: cs.onPrimaryContainer.withOpacity(.9)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _PrimaryAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        height: 68,
        decoration: BoxDecoration(
          color: color.withOpacity(.14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(.35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
                letterSpacing: .2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceVariant.withOpacity(.45),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: cs.primary),
              ),
              const Spacer(),
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
