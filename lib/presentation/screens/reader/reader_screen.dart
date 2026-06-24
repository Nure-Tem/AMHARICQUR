import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/injection.dart';
import '../../../domain/entities/book_content.dart';
import '../../../domain/entities/reading_position.dart';
import '../../widgets/content_block_widget.dart';

/// Reader screen — structured book content rendering with lazy loading.
class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({
    super.key,
    this.initialBlockId,
    this.initialSortOrder,
    this.initialScrollOffset,
  });

  final int? initialBlockId;
  final int? initialSortOrder;
  final double? initialScrollOffset;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<ContentBlock> _loadedBlocks = [];
  
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentSortOrder = 0;
  Timer? _scrollDebouncer;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeReader();
  }

  @override
  void dispose() {
    _scrollDebouncer?.cancel();
    _saveReadingPosition();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeReader() async {
    // Determine starting sort order
    if (widget.initialSortOrder != null) {
      _currentSortOrder = widget.initialSortOrder!;
    } else if (widget.initialBlockId != null) {
      // Load block to get its sort order
      final service = ref.read(bookContentServiceProvider);
      final block = await service.getBlock(widget.initialBlockId!);
      _currentSortOrder = block?.sortOrder ?? 0;
    } else {
      // Try to load continue reading position
      final positionService = ref.read(readingPositionServiceProvider);
      final continueReading = await positionService.getContinueReading();
      if (continueReading != null) {
        final service = ref.read(bookContentServiceProvider);
        final block = await service.getBlock(continueReading.contentBlockId);
        _currentSortOrder = block?.sortOrder ?? 0;
      }
    }

    // Load initial page
    await _loadNextPage();

    // Restore scroll position if provided
    if (widget.initialScrollOffset != null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(widget.initialScrollOffset!);
        }
      });
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final service = ref.read(bookContentServiceProvider);
      final page = await service.loadPage(startSortOrder: _currentSortOrder);

      if (mounted) {
        setState(() {
          _loadedBlocks.addAll(page.blocks);
          _hasMore = page.hasMore;
          if (page.blocks.isNotEmpty) {
            _currentSortOrder = page.blocks.last.sortOrder + 1;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load content: $e')),
        );
      }
    }
  }

  void _onScroll() {
    // Load more when near bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      _loadNextPage();
    }

    // Debounced save of scroll position
    _scrollDebouncer?.cancel();
    _scrollDebouncer = Timer(const Duration(milliseconds: 500), () {
      _saveReadingPosition();
    });
  }

  void _saveReadingPosition() {
    if (!_scrollController.hasClients || _loadedBlocks.isEmpty) return;

    // Find the first visible block
    final scrollOffset = _scrollController.offset;
    
    // Estimate which block is visible (simplified)
    final visibleIndex = (scrollOffset / 100).floor().clamp(0, _loadedBlocks.length - 1);
    final visibleBlock = _loadedBlocks[visibleIndex];

    final position = ReadingPosition(
      id: 0, // Will be auto-generated
      contentBlockId: visibleBlock.id,
      scrollOffset: scrollOffset,
      scrollFraction: scrollOffset / _scrollController.position.maxScrollExtent,
      visitedAt: DateTime.now(),
      isContinueReading: true,
      sectionTitle: visibleBlock.primaryText,
    );

    final service = ref.read(readingPositionServiceProvider);
    service.savePosition(position, asContinue: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement in-reader search
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: () {
              // TODO: Implement bookmark creation
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Show reader settings (font size, etc.)
            },
          ),
        ],
      ),
      body: _loadedBlocks.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _loadedBlocks.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _loadedBlocks.length) {
                  // Loading indicator at bottom
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final block = _loadedBlocks[index];
                return ContentBlockWidget(
                  key: ValueKey(block.id),
                  block: block,
                  onTap: () {
                    // TODO: Handle block tap (text selection, etc.)
                  },
                );
              },
            ),
    );
  }
}
