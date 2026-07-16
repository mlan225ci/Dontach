import 'package:flutter/material.dart';
import 'package:dontach/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../models/intrusion_event.dart';
import '../services/protection_coordinator.dart';

class IntrusionHistoryScreen extends StatefulWidget {
  const IntrusionHistoryScreen({super.key});

  @override
  State<IntrusionHistoryScreen> createState() => _IntrusionHistoryScreenState();
}

class _IntrusionHistoryScreenState extends State<IntrusionHistoryScreen> {
  final ProtectionCoordinator _coordinator = ProtectionCoordinator.instance;

  @override
  void initState() {
    super.initState();
    _coordinator.addListener(_onChanged);
    _coordinator.refreshIntrusionHistory();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _confirmClear(AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(l10n.clearHistory, style: const TextStyle(color: Colors.white)),
        content: Text(
          l10n.clearHistoryConfirm,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE53935)),
            child: Text(l10n.clearHistory),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _coordinator.clearIntrusionHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.historyCleared)),
        );
      }
    }
  }

  @override
  void dispose() {
    _coordinator.removeListener(_onChanged);
    super.dispose();
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).add_Hm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final events = _coordinator.intrusionHistory;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        title: Text(l10n.intrusionHistory, style: const TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          if (events.isNotEmpty)
            IconButton(
              tooltip: l10n.clearHistory,
              onPressed: () => _confirmClear(l10n),
              icon: const Icon(Icons.delete_outline_rounded),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text(
              l10n.intrusionHistoryCount(events.length),
              style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
            ),
          ),
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.intrusionHistoryEmpty,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _EventTile(
                      event: events[index],
                      dateLabel: _formatDate(context, events[index].timestamp),
                      photoLabel: events[index].photoCaptured
                          ? l10n.intrusionPhotoCaptured
                          : l10n.intrusionPhotoMissing,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({
    required this.event,
    required this.dateLabel,
    required this.photoLabel,
  });

  final IntrusionEvent event;
  final String dateLabel;
  final String photoLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_active_rounded, color: Color(0xFFE53935)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  photoLabel,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
