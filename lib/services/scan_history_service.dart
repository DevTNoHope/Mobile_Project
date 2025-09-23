import '../models/scan_history.dart';

class ScanHistoryService {
  static final List<ScanHistory> _history = [];

  static void addHistory(ScanHistory item) {
    _history.insert(0, item);
  }

  static List<ScanHistory> getHistory() => _history;

  static void clearHistory() {
    _history.clear();
  }
}
