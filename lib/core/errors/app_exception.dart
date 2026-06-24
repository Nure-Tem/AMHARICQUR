import 'package:equatable/equatable.dart';

/// Base application exception.
sealed class AppException extends Equatable implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];

  @override
  String toString() => 'AppException: $message';
}

/// Database operation failed.
final class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.cause});
}

/// Bundled book database asset missing or corrupt.
final class BookAssetException extends AppException {
  const BookAssetException(super.message, {super.cause});
}

/// Content block not found.
final class ContentNotFoundException extends AppException {
  const ContentNotFoundException(super.message, {super.cause});
}

/// Search query invalid or failed.
final class SearchException extends AppException {
  const SearchException(super.message, {super.cause});
}
