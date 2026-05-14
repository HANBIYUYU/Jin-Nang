import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

/// 按钮音效管理（单例模式，支持资源释放）
class ButtonSounds {
  static final ButtonSounds _instance = ButtonSounds._();
  AudioPlayer? _player;
  bool _isDisposed = false;
  
  ButtonSounds._();
  
  static ButtonSounds get instance => _instance;
  
  AudioPlayer get _audioPlayer {
    if (_isDisposed) {
      throw StateError('ButtonSounds has been disposed');
    }
    _player ??= AudioPlayer();
    return _player!;
  }
  
  /// 播放按下音效
  Future<void> playPressed() async {
    if (_isDisposed) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/btn_pressed.mp3'));
    } catch (e) {
      debugPrint('Failed to play pressed sound: $e');
    }
  }
  
  /// 播放释放音效
  Future<void> playReleased() async {
    if (_isDisposed) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/btn_released.mp3'));
    } catch (e) {
      debugPrint('Failed to play released sound: $e');
    }
  }
  
  /// 释放资源
  void dispose() {
    _isDisposed = true;
    _player?.dispose();
    _player = null;
  }
}

/// 按压反馈配置
class PressFeedback {
  /// 按下时的偏移量
  final Offset offset;
  
  /// 按下时的不透明度
  final double opacity;
  
  /// 按下时的缩放比例（可选）
  final double? scale;
  
  const PressFeedback({
    this.offset = const Offset(2, 2),
    this.opacity = 0.92,
    this.scale,
  });
  
  /// 默认反馈效果
  static const defaultFeedback = PressFeedback();
  
  /// 无反馈效果
  static const none = PressFeedback(
    offset: Offset.zero,
    opacity: 1.0,
  );
}

/// 通用可按下包装器
class Pressable extends StatefulWidget {
  /// 子组件
  final Widget child;
  
  /// 点击回调
  final VoidCallback? onPressed;
  
  /// 长按回调
  final VoidCallback? onLongPress;
  
  /// 是否启用音效
  final bool enableSound;
  
  /// 是否启用触觉反馈
  final bool enableHaptic;
  
  /// 按压视觉反馈配置
  final PressFeedback feedback;
  
  /// 长按触发时长
  final Duration longPressDuration;

  const Pressable({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.enableSound = true,
    this.enableHaptic = true,
    this.feedback = PressFeedback.defaultFeedback,
    this.longPressDuration = const Duration(milliseconds: 500),
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);
  bool _isDisposed = false;
  int _pressId = 0;

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed == null && widget.onLongPress == null) return;
    
    final currentPressId = ++_pressId;
    
    // 立即显示视觉反馈
    if (!_isDisposed && mounted) {
      _isPressed.value = true;
    }
    
    // 播放按下音效
    if (widget.enableSound) {
      _playSound(true, currentPressId);
    }
    
    // 触觉反馈
    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _playSound(bool isPressed, int pressId) async {
    try {
      await ButtonSounds.instance._audioPlayer.stop();
      if (pressId == _pressId) {
        await ButtonSounds.instance._audioPlayer.play(
          AssetSource(isPressed ? 'audio/btn_pressed.mp3' : 'audio/btn_released.mp3'),
        );
      }
    } catch (e) {
      debugPrint('Sound error: $e');
    }
  }

  void _onTapUp(TapUpDetails details) {
    final currentPressId = _pressId;
    
    // 延迟一点重置状态，确保用户能看到反馈
    Future.delayed(const Duration(milliseconds: 30), () {
      if (!_isDisposed && mounted && currentPressId == _pressId) {
        _isPressed.value = false;
      }
    });
    
    // 播放释放音效
    if (widget.enableSound) {
      _playSound(false, currentPressId);
    }
    
    // 触发回调
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    _pressId++;
    if (!_isDisposed && mounted) {
      _isPressed.value = false;
    }
  }
  
  void _onLongPress() {
    _pressId++;
    if (!_isDisposed && mounted) {
      _isPressed.value = false;
    }
    
    if (widget.enableHaptic) {
      HapticFeedback.heavyImpact();
    }
    
    widget.onLongPress?.call();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pressId++;
    _isPressed.value = false;
    _isPressed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onPressed == null && widget.onLongPress == null) {
      return widget.child;
    }
    
    return ValueListenableBuilder<bool>(
      valueListenable: _isPressed,
      builder: (context, pressed, child) {
        Widget result = child!;
        
        // 应用视觉反馈
        if (pressed && widget.feedback != PressFeedback.none) {
          if (widget.feedback.scale != null) {
            result = Transform.scale(
              scale: widget.feedback.scale!,
              child: result,
            );
          }
          
          result = Transform.translate(
            offset: widget.feedback.offset,
            child: result,
          );
          
          result = Opacity(
            opacity: widget.feedback.opacity,
            child: result,
          );
        }
        
        return GestureDetector(
          onTapDown: widget.onPressed != null || widget.onLongPress != null ? _onTapDown : null,
          onTapUp: widget.onPressed != null ? _onTapUp : null,
          onTapCancel: _onTapCancel,
          onLongPress: widget.onLongPress != null ? _onLongPress : null,
          behavior: HitTestBehavior.opaque,
          child: result,
        );
      },
      child: widget.child,
    );
  }
}