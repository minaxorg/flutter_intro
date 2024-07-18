part of 'flutter_intro.dart';

/// Button [Widget] underneath intro text, using [text] as its content and
/// [onPressed] as its action.
///
/// Customize with [width] (default null), [height] (default 28), [fontSize]
/// (default 12), and [color] (default white).
class IntroButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  const IntroButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          side: onPressed == null
              ? null
              : const BorderSide(
                  color: Colors.white,
                ),
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 8,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
