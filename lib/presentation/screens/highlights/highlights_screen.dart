import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/navigation/app_router.dart';
import '../../../di/injection.dart';
import '../../../domain/entities/highlight.dart';

/// Highlights and notes screen.
class HighlightsScreen extends ConsumerWidget {
  const HighlightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Highlights & Notes'),
      ),
      body: FutureBuilder<List<Highlight>>(
        future: ref.read(highlightServiceProvider).getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final highlights = snapshot.data ?? [];

          if (highlights.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.highlight, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No highlights yet',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: highlights.length,
            itemBuilder: (context, index) {
              final highlight = highlights[index];
              return ListTile(
                leading: Icon(
                  Icons.highlight,
                  color: highlight.color.lightOverlay,
                ),
                title: Text(
                  highlight.selectedText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('Created ${_formatDate(highlight.createdAt)}'),
                onTap: () {
                  context.goToReader(blockId: highlight.contentBlockId);
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
