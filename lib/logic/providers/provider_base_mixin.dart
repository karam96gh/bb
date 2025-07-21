// lib/logic/providers/provider_base_mixin.dart
import 'package:flutter/material.dart';

/// Mixin to handle safe notifyListeners calls to avoid build-time issues
mixin SafeNotifierMixin on ChangeNotifier {
  /// Safely notify listeners by scheduling the notification for after the current build
  void safeNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!hasListeners) return;
      notifyListeners();
    });
  }

  /// Schedule a function to run after the current build frame
  void schedulePostFrame(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}