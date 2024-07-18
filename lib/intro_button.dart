part of 'flutter_intro.dart';

/// Button [Widget] underneath intro text, using [text] as its content and
/// [onPressed] as its action.
///
/// Customize with [width] (default null), [height] (default 28), [fontSize]
/// (default 12), and [color] (default white).
class IntroButton extends StatelessWidget {
  static const double defaultHeight = 28;
  static const Color defaultColor = Colors.white;
  static const double defaultFontSize = 12;

  final String text;
  final double? width;
  final double height;
  final double fontSize;
  final Color color;
  final VoidCallback? onPressed;

  /// Constructor for [IntroButton] with required [text] and optional
  /// parameters.
  const IntroButton({
    super.key,
    required this.text,
    this.width,
    this.height = defaultHeight,
    this.fontSize = defaultFontSize,
    this.color = defaultColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          shape: const StadiumBorder(),
          side: onPressed == null ? null : BorderSide(color: color),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: fontSize)),
      ),
    );
  }
}
