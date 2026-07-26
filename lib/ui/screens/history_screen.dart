import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../models/scan_result.dart';
import '../../data/repositories/scan_repository.dart';
import '../widget/scan_row.dart';
import 'home_screen.dart'; // for AppBottomNav
import 'result_screen.dart';

// Screen 4 - History
// Now fetches its own data from ScanRepository (screens are only
// supposed to talk to the repository, not the database directly).
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScanRepository repository = ScanRepository();

  List<ScanResult> allScans = [];
  bool isLoading = true;

  String searchText = '';
  String selectedFilter = 'All'; // All | High Risk | Suspicious | Safe

  @override
  void initState() {
    super.initState();
    _loadScans();
  }

  // get the scans from the database through the repository
  Future<void> _loadScans() async {
    setState(() => isLoading = true);
    final scans = await repository.getAllScans();
    setState(() {
      allScans = scans;
      isLoading = false;
    });
  }

  // filter the scans by search text and the selected pill
  List<ScanResult> get _filteredScans {
    return allScans.where((scan) {
      final matchesSearch = scan.url.toLowerCase().contains(
        searchText.toLowerCase(),
      );
      final matchesFilter =
          selectedFilter == 'All' || scan.verdict == selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  // group scans into "Today" and "Yesterday" (and "Earlier" for the rest)
  Map<String, List<ScanResult>> _groupByDate(List<ScanResult> scans) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<ScanResult>> groups = {
      'Today': [],
      'Yesterday': [],
      'Earlier': [],
    };

    for (final scan in scans) {
      final date = DateTime.fromMillisecondsSinceEpoch(scan.timestamp);
      final justDate = DateTime(date.year, date.month, date.day);

      if (justDate == today) {
        groups['Today']!.add(scan);
      } else if (justDate == yesterday) {
        groups['Yesterday']!.add(scan);
      } else {
        groups['Earlier']!.add(scan);
      }
    }

    return groups;
  }

  // shows a bottom sheet asking "are you sure?" before deleting one scan
  void _confirmDeleteOne(ScanResult scan) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Delete this scan?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              const Text(
                'This action cannot be undone.',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        if (scan.id != null) {
                          await repository.deleteScan(scan.id!);
                          _loadScans(); // refresh the list after delete
                        }
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // shows a bottom sheet asking "are you sure?" before clearing everything
  void _confirmClearAll() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Clear all history?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              const Text(
                'This action cannot be undone.',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await repository.deleteAllScans();
                        _loadScans(); // refresh the list after clearing
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _openResult(ScanResult scan) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(scan: scan)),
    ).then((_) => _loadScans()); // reload after coming back
  }

  Widget _buildFilterPill(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFF8FAFC),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6366F1)
                : const Color(0xFFE2E8F0),
          ),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate(_filteredScans);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'History',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(TablerIcons.trash, color: Color(0xFF1E293B)),
            onPressed: _confirmClearAll,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // search bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => searchText = value),
                    decoration: InputDecoration(
                      hintText: 'Search past scans...',
                      prefixIcon: const Icon(TablerIcons.search, size: 18),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                // filter pills
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterPill('All'),
                        _buildFilterPill('High Risk'),
                        _buildFilterPill('Suspicious'),
                        _buildFilterPill('Safe'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // the list, grouped by date
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    children: [
                      for (final groupName in ['Today', 'Yesterday', 'Earlier'])
                        if (grouped[groupName]!.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              groupName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                          for (final scan in grouped[groupName]!)
                            ScanRow(
                              url: scan.url,
                              verdict: scan.verdict,
                              timestamp: scan.timestamp,
                              source: scan.source,
                              onTap: () => _openResult(scan),
                              onLongPress: () => _confirmDeleteOne(scan),
                            ),
                        ],
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}
