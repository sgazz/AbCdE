import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import '../services/haptic_service.dart';

class KeyboardNavigation {
  static final HapticService _hapticService = HapticService();

  // Keyboard navigation widget
  static Widget keyboardNavigable({
    required Widget child,
    required FocusNode focusNode,
    VoidCallback? onEnter,
    VoidCallback? onSpace,
    VoidCallback? onEscape,
    bool enableHaptic = true,
  }) {
    return Focus(
      focusNode: focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.enter:
            case LogicalKeyboardKey.numpadEnter:
              onEnter?.call();
              if (enableHaptic) {
                _hapticService.selection();
              }
              return KeyEventResult.handled;
            case LogicalKeyboardKey.space:
              onSpace?.call();
              if (enableHaptic) {
                _hapticService.light();
              }
              return KeyEventResult.handled;
            case LogicalKeyboardKey.escape:
              onEscape?.call();
              if (enableHaptic) {
                _hapticService.warning();
              }
              return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }

  // Keyboard shortcut widget
  static Widget keyboardShortcut({
    required Widget child,
    required Map<LogicalKeyboardKey, VoidCallback> shortcuts,
    bool enableHaptic = true,
  }) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          final callback = shortcuts[event.logicalKey];
          if (callback != null) {
            callback();
            if (enableHaptic) {
              _hapticService.light();
            }
          }
        }
      },
      child: child,
    );
  }

  // Tab navigation widget
  static Widget tabNavigable({
    required Widget child,
    required FocusNode focusNode,
    VoidCallback? onTab,
    VoidCallback? onShiftTab,
    bool enableHaptic = true,
  }) {
    return Focus(
      focusNode: focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.tab) {
            // For now, just call onTab - shift detection can be added later
            onTab?.call();
            if (enableHaptic) {
              _hapticService.light();
            }
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}

// Keyboard shortcut manager
class KeyboardShortcutManager {
  static final Map<String, Map<LogicalKeyboardKey, VoidCallback>> _shortcuts = {};

  // Register shortcuts for a specific context
  static void registerShortcuts(String context, Map<LogicalKeyboardKey, VoidCallback> shortcuts) {
    _shortcuts[context] = shortcuts;
  }

  // Unregister shortcuts for a context
  static void unregisterShortcuts(String context) {
    _shortcuts.remove(context);
  }

  // Get shortcuts for a context
  static Map<LogicalKeyboardKey, VoidCallback>? getShortcuts(String context) {
    return _shortcuts[context];
  }

  // Clear all shortcuts
  static void clearAllShortcuts() {
    _shortcuts.clear();
  }
}

// Global keyboard listener widget
class GlobalKeyboardListener extends StatefulWidget {
  final Widget child;
  final Map<LogicalKeyboardKey, VoidCallback> shortcuts;
  final bool enableHaptic;

  const GlobalKeyboardListener({
    super.key,
    required this.child,
    required this.shortcuts,
    this.enableHaptic = true,
  });

  @override
  State<GlobalKeyboardListener> createState() => _GlobalKeyboardListenerState();
}

class _GlobalKeyboardListenerState extends State<GlobalKeyboardListener> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          final callback = widget.shortcuts[event.logicalKey];
          if (callback != null) {
            callback();
            if (widget.enableHaptic) {
              HapticService().light();
            }
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: widget.child,
    );
  }
}

// Accessible focus manager
class AccessibleFocusManager {
  static final List<FocusNode> _focusNodes = [];
  static int _currentIndex = 0;

  // Add focus node
  static void addFocusNode(FocusNode node) {
    _focusNodes.add(node);
  }

  // Remove focus node
  static void removeFocusNode(FocusNode node) {
    _focusNodes.remove(node);
  }

  // Move to next focus
  static void nextFocus() {
    if (_focusNodes.isNotEmpty) {
      _currentIndex = (_currentIndex + 1) % _focusNodes.length;
      _focusNodes[_currentIndex].requestFocus();
      HapticService().light();
    }
  }

  // Move to previous focus
  static void previousFocus() {
    if (_focusNodes.isNotEmpty) {
      _currentIndex = (_currentIndex - 1 + _focusNodes.length) % _focusNodes.length;
      _focusNodes[_currentIndex].requestFocus();
      HapticService().light();
    }
  }

  // Move to first focus
  static void firstFocus() {
    if (_focusNodes.isNotEmpty) {
      _currentIndex = 0;
      _focusNodes[_currentIndex].requestFocus();
      HapticService().light();
    }
  }

  // Move to last focus
  static void lastFocus() {
    if (_focusNodes.isNotEmpty) {
      _currentIndex = _focusNodes.length - 1;
      _focusNodes[_currentIndex].requestFocus();
      HapticService().light();
    }
  }

  // Clear all focus nodes
  static void clearFocusNodes() {
    _focusNodes.clear();
    _currentIndex = 0;
  }
} 