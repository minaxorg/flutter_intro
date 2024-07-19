library flutter_intro;

import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

part 'delay_rendered_widget.dart';
part 'flutter_intro_exception.dart';
part 'global_keys.dart';
part 'intro_button.dart';
part 'intro_status.dart';
part 'intro_step_builder.dart';
part 'overlay_position.dart';
part 'step_widget_builder.dart';
part 'step_widget_params.dart';
part 'throttling.dart';

/// Class to encompass groups of [IntroStepBuilder] widgets and provide overall
/// settings for their behavior and display. Use at top level of widget tree for
/// global access to child steps.
///
/// Use [start] to begin the guide. To safely start a guide on initial route
/// load, call [start] within [IntroStepBuilder.onWidgetLoad] of the first step.
/// Consider using [Future.delayed] for ~10ms to ensure that all steps are
/// ready.
class Intro extends InheritedWidget {
  static String _group = 'default';
  static BuildContext? _context;
  static OverlayEntry? _overlayEntry;
  static bool _removed = false;
  static Size _screenSize = const Size(0, 0);
  static Widget _overlayWidget = const SizedBox.shrink();
  static IntroStepBuilder? _currentStep;
  static Size _widgetSize = const Size(0, 0);
  static Offset _widgetOffset = const Offset(0, 0);

  static const EdgeInsets defaultPadding = EdgeInsets.all(8);
  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(Radius.circular(4));
  static const Color defaultMaskColor = Color.fromRGBO(0, 0, 0, .6);
  static const bool defaultAnimate = false;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const bool defaultMaskClosable = false;

  final List<String> _finishedGroups = [];

  final _Throttling _th =
      _Throttling(duration: const Duration(milliseconds: 500));

  /// [Map] of all steps that need to be displayed. This is generated with
  /// first-frame callbacks on routes (see `intro_step_builder.dart`).
  final Map<String, List<IntroStepBuilder>> _stepsMap = {
    "default": [],
  };

  /// [Duration] of the animation between steps
  late final Duration _animationDuration;

  /// [Widget] [padding] of the selected area (default [EdgeInsets.all(8)])
  final EdgeInsets padding;

  /// [Widget] [borderRadius] of the selected area (default
  /// [BorderRadius.all(Radius.circular(4))])
  final BorderRadiusGeometry borderRadius;

  /// Mask color of step page (default translucent black)
  final Color maskColor;

  /// [bool] to not animate the steps (default false)
  final bool noAnimation;

  /// [bool] for whether the mask can be closed (default false)
  final bool maskClosable;

  /// [ValueNotifier] of [IntroStatus], which can be used with
  /// [ValueListenableBuilder] for instant UI updates. See readme for example.
  /// Default is not open.
  final ValueNotifier<IntroStatus> statusNotifier =
      ValueNotifier(IntroStatus(isOpen: false));

  /// Nullable [Function], with [int] parameter for step `order`, to build
  /// custom buttons for steps (default `null`)
  final String Function(int order)? buttonTextBuilder;

  /// Constructor for [Intro] widget, requiring only [child] but with further
  /// customization available
  Intro({
    super.key,
    this.padding = defaultPadding,
    this.borderRadius = defaultBorderRadius,
    this.maskColor = defaultMaskColor,
    this.noAnimation = defaultAnimate,
    this.maskClosable = defaultMaskClosable,
    this.buttonTextBuilder,
    required super.child,
  }) {
    _animationDuration = noAnimation ? Duration.zero : defaultAnimationDuration;
  }

  /// Get [IntroStatus] for whether the intro is open or closed
  IntroStatus get status => statusNotifier.value;

  /// Return [List] of [IntroStepBuilder] widgets ordered by `order` property
  /// ascending. Return empty list if nothing for the [_group] is found.
  List<IntroStepBuilder> get _steps {
    return (_stepsMap[_group] ?? [])..sort((a, b) => a.order - b.order);
  }

  /// Get [bool] for whether the step has one following it, judged by if there
  /// is a step with a higher `order` value detected.
  bool get hasNextStep =>
      _currentStep == null ||
      _steps.where((e) => e.order > _currentStep!.order).isNotEmpty;

  /// Get [bool] for whether the step has one before it, judged by if there
  /// is a step with a lower `order` value detected.
  bool get hasPrevStep =>
      _currentStep != null &&
      _steps.firstWhereOrNull((e) => e.order < _currentStep!.order) != null;

  /// Return nullable [IntroStepBuilder] for the next step in the sequence as
  /// compared to [_currentStep].
  IntroStepBuilder? _getNextStep({
    bool isUpdate = false,
  }) {
    if (isUpdate) {
      return _currentStep;
    }

    final List<IntroStepBuilder> steps = _steps;

    if (_currentStep == null) return steps.firstOrNull;

    return steps.firstWhereOrNull(
        (IntroStepBuilder s) => s.order > _currentStep!.order);
  }

  /// Return nullable [IntroStepBuilder] for the previous step in the sequence
  /// as compared to [_currentStep].
  IntroStepBuilder? _getPrevStep({
    bool isUpdate = false,
  }) {
    if (isUpdate) {
      return _currentStep;
    }

    if (_currentStep == null) return null;

    return _steps.lastWhereOrNull(
      (e) => e.order < _currentStep!.order,
    );
  }

  /// Store [overlayEntry] and update [statusNotifier].
  void _setOverlay(OverlayEntry? overlayEntry) {
    _overlayEntry = overlayEntry;
    statusNotifier.value = IntroStatus(isOpen: overlayEntry != null);
  }

  /// Return [Widget] using various parameters
  Widget _widgetBuilder({
    double? width,
    double? height,
    BlendMode? backgroundBlendMode,
    required double left,
    required double top,
    double? bottom,
    double? right,
    BorderRadiusGeometry? borderRadiusGeometry,
    Widget? child,
    VoidCallback? onTap,
  }) {
    final decoration = BoxDecoration(
      color: Colors.white,
      backgroundBlendMode: backgroundBlendMode,
      borderRadius: borderRadiusGeometry,
    );
    return AnimatedPositioned(
      duration: _animationDuration,
      left: left,
      top: top,
      bottom: bottom,
      right: right,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          padding: padding,
          decoration: decoration,
          width: width,
          height: height,
          duration: _animationDuration,
          child: child,
        ),
      ),
    );
  }

  /// Remove the intro overlay after [_animationDuration] has passed.
  void _onFinish() {
    if (_overlayEntry == null) return;

    _removed = true;
    _overlayEntry?.markNeedsBuild();

    Timer(_animationDuration, () {
      if (_overlayEntry == null) return;

      _finishedGroups.add(_group);
      _currentStep = null;
      _overlayEntry?.remove();
      _removed = false;
      _setOverlay(null);
    });
  }

  /// Move to the next or previous step, or finish the guide if there are no
  /// more steps.
  void _render({
    bool isUpdate = false,
    bool reverse = false,
  }) {
    IntroStepBuilder? step = reverse
        ? _getPrevStep(isUpdate: isUpdate)
        : _getNextStep(isUpdate: isUpdate);
    _currentStep = step;

    if (step == null) {
      _onFinish();
      return;
    }

    BuildContext? currentContext = step._key.currentContext;

    if (currentContext == null) {
      throw FlutterIntroException(
        'The current context is null because there is no widget in the tree '
        'that matches this global key. Please check whether the key in '
        'IntroStepBuilder(group: ${step.group}, order: ${step.order}) has been '
        'applied to a widget. If so, this may be a bug. Let us know!',
      );
    }

    RenderBox renderBox = currentContext.findRenderObject() as RenderBox;

    _screenSize = MediaQuery.of(_context!).size;
    _widgetSize = Size(
      renderBox.size.width + (step.padding?.horizontal ?? padding.horizontal),
      renderBox.size.height + (step.padding?.vertical ?? padding.vertical),
    );
    _widgetOffset = Offset(
      renderBox.localToGlobal(Offset.zero).dx -
          (step.padding?.left ?? padding.left),
      renderBox.localToGlobal(Offset.zero).dy -
          (step.padding?.top ?? padding.top),
    );

    OverlayPosition position = _StepWidgetBuilder.getOverlayPosition(
      screenSize: _screenSize,
      size: _widgetSize,
      offset: _widgetOffset,
    );

    if (step.overlayBuilder != null) {
      _overlayWidget = Stack(
        children: [
          Positioned(
            width: position.width,
            left: position.left,
            top: position.top,
            bottom: position.bottom,
            right: position.right,
            child: SizedBox(
              child: step.overlayBuilder!(
                StepWidgetParams(
                  group: step.group,
                  order: step.order,
                  onNext: hasNextStep ? _render : null,
                  onPrev: hasPrevStep
                      ? () {
                          _render(reverse: true);
                        }
                      : null,
                  onFinish: _onFinish,
                  screenSize: _screenSize,
                  size: _widgetSize,
                  offset: _widgetOffset,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (step.text != null) {
      _overlayWidget = Stack(
        children: [
          Positioned(
            left: position.left,
            top: position.top,
            bottom: position.bottom,
            right: position.right,
            child: SizedBox(
              width: position.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: position.crossAxisAlignment,
                children: [
                  Text(
                    step.text!,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  IntroButton(
                    text: buttonTextBuilder == null
                        ? 'Next'
                        : buttonTextBuilder!(step.order),
                    onPressed: _render,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (_overlayEntry == null) {
      _createOverlay();
    } else {
      _overlayEntry?.markNeedsBuild();
    }
  }

  /// Create [OverlayEntry] and apply it.
  void _createOverlay() {
    _setOverlay(OverlayEntry(
      builder: (BuildContext context) {
        Size currentScreenSize = MediaQuery.of(context).size;

        if (_screenSize.width != currentScreenSize.width ||
            _screenSize.height != currentScreenSize.height) {
          _screenSize = currentScreenSize;

          _th.throttle(() {
            _render(
              isUpdate: true,
            );
          });
        }

        return _DelayRenderedWidget(
          removed: _removed,
          childPersist: true,
          duration: _animationDuration,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    maskColor,
                    BlendMode.srcOut,
                  ),
                  child: Stack(
                    children: [
                      _widgetBuilder(
                        backgroundBlendMode: BlendMode.dstOut,
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        onTap: maskClosable
                            ? () {
                                Future.delayed(
                                  const Duration(milliseconds: 200),
                                  _render,
                                );
                              }
                            : null,
                      ),
                      _widgetBuilder(
                        width: _widgetSize.width,
                        height: _widgetSize.height,
                        left: _widgetOffset.dx,
                        top: _widgetOffset.dy,
                        borderRadiusGeometry:
                            _currentStep?.borderRadius ?? borderRadius,
                        onTap: _currentStep?.onHighlightWidgetTap,
                      ),
                    ],
                  ),
                ),
                _DelayRenderedWidget(
                  duration: _animationDuration,
                  child: _overlayWidget,
                ),
              ],
            ),
          ),
        );
      },
    ));
    Overlay.of(_context!).insert(_overlayEntry!);
  }

  /// Begin the intro for [group] (default is `default`). If the group has
  /// already completed, throw a [FlutterIntroException] unless [reset] is true.
  void start({
    String group = 'default',
    bool reset = false,
  }) {
    if (_finishedGroups.contains(group)) {
      if (!reset) {
        throw FlutterIntroException(
          'The group $group has already been completed. If you want to start '
          'again, please call the start method with reset = true.',
        );
      } else {
        _finishedGroups.remove(group);
      }
    }
    _group = group;
    _render();
  }

  /// Refresh the overlay.
  void refresh() => _render(isUpdate: true);

  /// Find [Intro] widget within [context], store it, and return it. Throw
  /// [FlutterIntroException] if not found.
  static Intro of(BuildContext context) {
    _context = context;
    Intro? intro = context.dependOnInheritedWidgetOfExactType<Intro>();
    if (intro == null) {
      throw FlutterIntroException(
        'The context does not contain an Intro widget.',
      );
    }
    return intro;
  }

  /// Dispose of the overlay by calling [_onFinish]. See readme example for how
  /// this can be used to safely close an intro if the user uses the OS back
  /// functionality.
  void dispose() {
    _onFinish();
  }

  @override
  bool updateShouldNotify(Intro oldWidget) {
    return false;
  }
}
