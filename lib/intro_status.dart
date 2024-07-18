part of 'flutter_intro.dart';

/// Intro current status, held in a [isOpen], a [bool].
class IntroStatus {
  /// [bool] for whether intro is showing on the screen or not
  final bool isOpen;

  /// Constructor for [IntroStatus] with only member, `isOpen`, required.
  IntroStatus({
    required this.isOpen,
  });

  @override
  String toString() {
    return 'IntroStatus(isOpen: $isOpen)';
  }
}
