import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatelessWidget {
  final String content;
  const ResultPage({super.key, required this.content});

  bool get _isUrl {
    final uri = Uri.tryParse(content);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  Map<String, dynamic>? get _asJson {
    try {
      final decoded = jsonDecode(content);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _openUrl() async {
    final uri = Uri.parse(content);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUrl = _isUrl;
    final json = _asJson;

    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả quét')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Nội dung:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SelectableText(content),
            const SizedBox(height: 16),
            if (isUrl)
              ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text('Mở liên kết'),
                onPressed: _openUrl,
              ),
            if (!isUrl && json != null) ...[
              const SizedBox(height: 8),
              Text('Đã nhận diện JSON:',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              _JsonPrettyView(data: json),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Sao chép'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: content));
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã sao chép nội dung')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _JsonPrettyView extends StatelessWidget {
  final Map<String, dynamic> data;
  const _JsonPrettyView({required this.data});

  @override
  Widget build(BuildContext context) {
    String pretty(Object? v, [int indent = 0]) {
      final sp = ' ' * indent;
      if (v is Map) {
        final entries = v.entries
            .map((e) => '$sp  "${e.key}": ${pretty(e.value, indent + 2)}')
            .join(',\n');
        return '{\n$entries\n$sp}';
      } else if (v is List) {
        final items =
        v.map((e) => '$sp  ${pretty(e, indent + 2)}').join(',\n');
        return '[\n$items\n$sp]';
      } else if (v is String) {
        return '"$v"';
      }
      return '$v';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SelectableText(pretty(data)),
    );
  }
}
