import 'scan_history.dart';

class ScanHistoryService {
  static final List<ScanHistory> _history = [];

  static void addCode(String code) {
    _history.insert(0, ScanHistory(code: code, time: DateTime.now()));
  }

  static List<ScanHistory> getHistory() {
    return _history;
  }

  static void clearHistory() {
    _history.clear();
  }
}
