/// Named route paths for [go_router].
abstract final class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String toc = '/toc';
  static const String reader = '/reader';
  static const String search = '/search';
  static const String bookmarks = '/bookmarks';
  static const String highlights = '/highlights';
  static const String settings = '/settings';
  static const String about = '/about';
}

/// Query/path parameter keys.
abstract final class RouteParams {
  static const String contentBlockId = 'blockId';
  static const String sortOrder = 'sortOrder';
  static const String scrollOffset = 'scrollOffset';
}
