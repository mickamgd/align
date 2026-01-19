import 'package:flutter/foundation.dart';

/// Centralized logging system for the application
///
/// Usage:
/// - AppLogger.info() for informational messages
/// - AppLogger.warning() for warnings
/// - AppLogger.error() for errors with optional stack traces
class AppLogger {
  /// Log informational messages (only in debug mode)
  static void info(String message, [Object? data]) {
    if (kDebugMode) {
      debugPrint('ℹ️ $message');
      if (data != null) debugPrint('   Data: $data');
    }
  }

  /// Log warning messages (only in debug mode)
  static void warning(String message, [Object? data]) {
    if (kDebugMode) {
      debugPrint('⚠️ $message');
      if (data != null) debugPrint('   Data: $data');
    }
  }

  /// Log error messages with optional error object and stack trace
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('❌ $message');
      if (error != null) debugPrint('   Error: $error');
      if (stackTrace != null) debugPrint('   Stack: $stackTrace');
    }
  }
}
