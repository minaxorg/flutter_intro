part of flutter_intro;

class IntroButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  const IntroButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          shape: StadiumBorder(),
          side: onPressed == null
              ? null
              : BorderSide(
                  color: Colors.white,
                ),
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 8,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
