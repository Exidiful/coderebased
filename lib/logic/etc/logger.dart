import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warn,
  error,
}

class Logger {
  static LogLevel _minimumLevel = kDebugMode ? LogLevel.debug : LogLevel.warn;
  static bool _includeTimestamp = true;
  static bool _includeLevel = true;
  
  // Allow dynamic configuration
  static void configure({
    LogLevel? minimumLevel,
    bool? includeTimestamp,
    bool? includeLevel,
  }) {
    if (minimumLevel != null) _minimumLevel = minimumLevel;
    if (includeTimestamp != null) _includeTimestamp = includeTimestamp;
    if (includeLevel != null) _includeLevel = includeLevel;
  }

  static String _formatMessage(LogLevel level, String message) {
    final buffer = StringBuffer();
    
    if (_includeTimestamp) {
      buffer.write('[${DateTime.now().toIso8601String()}] ');
    }
    
    if (_includeLevel) {
      buffer.write('${level.name.toUpperCase()}: ');
    }
    
    buffer.write(message);
    return buffer.toString();
  }

  static void _log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    if (level.index < _minimumLevel.index) return;
    
    final formattedMessage = _formatMessage(level, message);
    
    switch (level) {
      case LogLevel.debug:
        debugPrint(formattedMessage);
        if (error != null) debugPrint('Error: $error');
        if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
        break;
      case LogLevel.info:
        debugPrint('\x1B[34m$formattedMessage\x1B[0m'); // Blue
        if (error != null) debugPrint('Error: $error');
        break;
      case LogLevel.warn:
        debugPrint('\x1B[33m$formattedMessage\x1B[0m'); // Yellow
        if (error != null) debugPrint('Error: $error');
        if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
        break;
      case LogLevel.error:
        debugPrint('\x1B[31m$formattedMessage\x1B[0m'); // Red
        if (error != null) debugPrint('Error: $error');
        if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
        break;
    }
  }

  // Public logging methods
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  static void info(String message, [Object? error]) {
    _log(LogLevel.info, message, error);
  }

  static void warn(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.warn, message, error, stackTrace);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  // Helper methods for common scenarios
  static void functionEntry(String functionName) {
    debug('▶ Entering $functionName');
  }

  static void functionExit(String functionName) {
    debug('◀ Exiting $functionName');
  }

  static void apiCall(String endpoint, {Map<String, dynamic>? params}) {
    info('API Call to $endpoint${params != null ? ' with params: $params' : ''}');
  }

  static void apiResponse(String endpoint, dynamic response) {
    debug('API Response from $endpoint: $response');
  }

  static void stateChange(String provider, String oldState, String newState) {
    debug('State Change in $provider: $oldState -> $newState');
  }
}
