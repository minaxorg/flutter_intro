import 'package:flutter/widgets.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test [Intro], [IntroStepBuilder], and [IntroButton].
void main() {
  test('Intro uses default values', () {
    final Intro intro = Intro(child: Container());

    expect(intro.padding, Intro.defaultPadding);
    expect(intro.borderRadius, Intro.defaultBorderRadius);
    expect(intro.maskColor, Intro.defaultMaskColor);
    expect(intro.noAnimation, Intro.defaultAnimate);
    expect(intro.maskClosable, Intro.defaultMaskClosable);
    expect(intro.buttonTextBuilder, isNull);
    expect(intro.child, isA<Container>());
  });

  test('Intro uses custom values', () {
    const EdgeInsets testPadding = EdgeInsets.all(13);
    final BorderRadius testBorderRadius = BorderRadius.circular(7);
    const Color testColor = Color.fromRGBO(255, 0, 0, 0.4);
    const bool testAnimate = true;
    const bool testMaskClosable = true;

    final Intro intro = Intro(
      padding: testPadding,
      borderRadius: testBorderRadius,
      maskColor: testColor,
      noAnimation: testAnimate,
      maskClosable: testMaskClosable,
      buttonTextBuilder: (int order) => 'Next ($order)',
      child: const SizedBox(),
    );

    expect(intro.padding, testPadding);
    expect(intro.borderRadius, testBorderRadius);
    expect(intro.maskColor, testColor);
    expect(intro.noAnimation, testAnimate);
    expect(intro.maskClosable, testMaskClosable);
    expect(intro.buttonTextBuilder, isNotNull);
    expect(intro.buttonTextBuilder!(3), 'Next (3)');
    expect(intro.child, isA<SizedBox>());
  });

  test('IntroStepBuilder throws without either text or overlayBuilder', () {
    testBuilder(_, __) => Container();
    testOverlayBuilder(_) => Container();
    expect(() => IntroStepBuilder(order: 0, builder: testBuilder),
        throwsAssertionError);

    expect(IntroStepBuilder(order: 1, builder: testBuilder, text: 'Test 1'),
        isNotNull);
    expect(
        IntroStepBuilder(
            order: 3, builder: testBuilder, overlayBuilder: testOverlayBuilder),
        isNotNull);
    expect(
        IntroStepBuilder(
            order: 3,
            builder: testBuilder,
            text: 'Test 3',
            overlayBuilder: testOverlayBuilder),
        isNotNull);
  });

  test('IntroButton uses default values', () {
    const IntroButton introButton = IntroButton(text: 'test');

    expect(introButton.text, 'test');
    expect(introButton.width, isNull);
    expect(introButton.height, IntroButton.defaultHeight);
    expect(introButton.fontSize, IntroButton.defaultFontSize);
    expect(introButton.color, IntroButton.defaultColor);
    expect(introButton.onPressed, isNull);
  });

  test('IntroButton uses custom values', () {
    const double testWidth = 37.0;
    const double testHeight = 42.0;
    const double fontTestSize = 19.0;
    const Color testColor = Color.fromRGBO(0, 0, 255, 0.5);

    final IntroButton introButton = IntroButton(
      text: 'test 2',
      width: testWidth,
      height: testHeight,
      fontSize: fontTestSize,
      color: testColor,
      onPressed: () {},
    );

    expect(introButton.text, 'test 2');
    expect(introButton.width, testWidth);
    expect(introButton.height, testHeight);
    expect(introButton.fontSize, fontTestSize);
    expect(introButton.color, testColor);
    expect(introButton.onPressed, isNotNull);
  });
}
