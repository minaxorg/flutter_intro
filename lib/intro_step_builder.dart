part of 'flutter_intro.dart';

/// [StatefulWidget] that creates a step within an [Intro] widget. Build the
/// desired widget to highlight within [builder], applying the `key` argument
/// to ensure it is found by [Intro]. Set a unique [order] value to create a
/// unique key for the step.
class IntroStepBuilder extends StatefulWidget {
  /// Required [Function] that builds and returns a [Widget] using `context` and
  /// `key`, which should be applied to the returned [Widget].
  final Widget Function(
    BuildContext context,
    GlobalKey key,
  ) builder;

  /// Set the group of this step (default is 'default')
  final String group;

  /// Required [int] that establishes a running sequence where lower values take
  /// precedence for execution. [order] is used internally to mark whether a
  /// component participates in guiding, so to avoid bugs we recommend not
  /// modifying this value using variables.
  final int order;

  /// Optional nullable [Function] to generate the content of the guide step,
  /// used internally by [Intro] when the guide page appears. Returns a [Widget]
  /// and takes a [StepWidgetParams] argument. Either [text] or [overlayBuilder]
  /// must be set.
  final Widget Function(StepWidgetParams params)? overlayBuilder;

  /// Optional nullable [VoidCallback] for when highlighted widget is tapped
  final VoidCallback? onHighlightWidgetTap;

  /// [Widget] [borderRadius] of the selected area, the default is
  /// [BorderRadius.all(Radius.circular(4))]
  final BorderRadiusGeometry? borderRadius;

  /// [Widget] [padding] of the selected area, the default is
  /// [EdgeInsets.all(8)]
  final EdgeInsets? padding;

  /// Optional nullable [String] text for the guide step. Either [text] or
  /// [overlayBuilder] must be set.
  final String? text;

  /// Optional nullable [VoidCallback] for when widget is loaded (when the key
  /// is add to context)
  final VoidCallback? onWidgetLoad;

  /// Constructor for [IntroStepBuilder] widget, requiring [order] and [builder]
  /// but with further customization available
  const IntroStepBuilder({
    super.key,
    required this.order,
    required this.builder,
    this.text,
    this.overlayBuilder,
    this.borderRadius,
    this.onHighlightWidgetTap,
    this.padding,
    this.onWidgetLoad,
    this.group = 'default',
  }) : assert(text != null || overlayBuilder != null);

  GlobalKey get _key => GlobalStringKey('${group}_$order');

  @override
  State<IntroStepBuilder> createState() => _IntroStepBuilderState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IntroStepBuilder(group: $group, order: $order)';
  }
}

class _IntroStepBuilderState extends State<IntroStepBuilder> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Intro flutterIntro = Intro.of(context);
      flutterIntro._stepsMap[widget.group] ??= [];
      flutterIntro._stepsMap[widget.group]!
          .removeWhere((e) => e.order == widget.order);
      flutterIntro._stepsMap[widget.group]!.add(widget);
      widget.onWidgetLoad?.call();
    });
  }

  @override
  void didUpdateWidget(covariant IntroStepBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.group != widget.group || oldWidget.order != widget.order) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Intro flutterIntro = Intro.of(context);
        flutterIntro._stepsMap[widget.group] ??= [];
        flutterIntro._stepsMap[oldWidget.group]
            ?.removeWhere((w) => w.order == oldWidget.order);
        flutterIntro._stepsMap[widget.group]
            ?.removeWhere((w) => w.order == widget.order);
        flutterIntro._stepsMap[widget.group]!.add(widget);
        widget.onWidgetLoad?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget._key);
  }
}
