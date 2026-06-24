import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/navigation/app_router.dart';
import '../../../di/injection.dart';
import '../../../domain/entities/book_content.dart';

/// Table of contents screen — hierarchical book navigation.
class TocScreen extends ConsumerWidget {
  const TocScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table of Contents'),
      ),
      body: FutureBuilder<List<TocEntry>>(
        future: ref.read(bookContentServiceProvider).getTableOfContents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error loading table of contents\n${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Trigger rebuild
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final entries = snapshot.data ?? [];

          if (entries.isEmpty) {
            return const Center(
              child: Text('No table of contents available'),
            );
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _TocEntryTile(
                entry: entry,
                onTap: () {
                  context.goToReader(sortOrder: entry.sortOrder);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _TocEntryTile extends StatelessWidget {
  const _TocEntryTile({
    required this.entry,
    required this.onTap,
  });

  final TocEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Indent based on level
    final indent = (entry.level - 1) * 16.0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 16 + indent, right: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.dividerColor),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  entry.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: entry.level == 1
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
