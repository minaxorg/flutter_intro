# flutter_intro

[![pub package](https://img.shields.io/pub/v/flutter_intro.svg)](https://pub.dartlang.org/packages/flutter_intro)

A better way for new feature introduction and step-by-step user guide for your Flutter project.

| <img src='https://raw.githubusercontent.com/minaxorg/flutter_intro/master/doc/v3/example1.gif' width='300' alt='Simple intro demo' />               | <img src='https://raw.githubusercontent.com/minaxorg/flutter_intro/master/doc/example2.gif' width='300' alt='Screen rotate intro demo' /> |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| <img src='https://raw.githubusercontent.com/minaxorg/flutter_intro/master/doc/v3/example2.gif' width='300' alt='Advanced, customized intro demo' /> | <img src='https://raw.githubusercontent.com/minaxorg/flutter_intro/master/doc/v3/example3.gif' width='300' alt='Multiple groups demo' />  |

## Features

- The guide widget is capable of adapting to device orientation.
- Supports custom rendering of the guide widget overlay content.
- Supports grouping of guide pages, facilitating the display of multiple guide groups on a single page.
- Supports guiding widgets that are rendered with a delay.

## Usage

To use this package, add `flutter_intro` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

### Init

Wrap the app root widget with `Intro`. You can also set some global properties on `Intro` as seen
below.

```dart
import 'package:flutter_intro/flutter_intro.dart';

Intro(
  /// Padding of the highlighted area and the widget
  padding: const EdgeInsets.all(8),

  /// Border radius of the highlighted area
  borderRadius: BorderRadius.all(Radius.circular(4)),

  /// The mask color of step page
  maskColor: const Color.fromRGBO(0, 0, 0, .6);

  /// Toggle animation
  noAnimation: false;

  /// Toggle whether the mask can be closed
  maskClosable: false;

  /// Build custom button text
  buttonTextBuilder: (order) =>
      order == 3 ? 'Custom Button Text' : 'Next',

  /// High-level widget
  child: const YourApp(),
)
```

### Add guided widget

Wrap a widget with `IntroStepBuilder`, placing the original widget inside `builder` and applying the
`key` so it can be found.

`order` must be defined uniquely per route so that the unique `key` can be generated.

```dart
/// See docs for full list of properties, some of which override [Intro] ones
IntroStepBuilder(
  /// Required: use unique int for each step to set guide order
  order: 1,
  
  /// Use either `text` or `overlayBuilder` to create guide content (see "Advanced Usage" for latter
  /// example).

  /// Use text to quickly add leading text
  text: 'Use this widget to...',
  
  /// Required: provide function that returns a `Widget` with the key
  builder: (BuildContext context, GlobalKey key) => NeedGuideWidget(
    /// Bind the key to whatever is returned
    key: key,
  ),
)
```

<img src='https://raw.githubusercontent.com/minaxorg/flutter_intro/master/doc/v3/img1.png'
width='500' alt='Intro screenshot showing subjects of above parameters' />

### Run

That's it!

```dart
Intro.of(context).start();
```

## Advanced Usage

```dart
/// See `example/lib/advanced_usage.dart` for more details
IntroStepBuilder(
  order: 2,
  
  /// Create a customized guide widget
  overlayBuilder: (StepWidgetParams params) {
    return YourCustomOverlay();
  },
)
```

`StepWidgetParams` provides many useful parameters to generate the guide overlay, as seen below.

<img src='https://raw.githubusercontent.com/minaxorg/flutter_intro/master/doc/img2.png' width='300'
alt='Intro screenshot showing definitions of spacing and sizing' />

## Troubleshooting

### Q1. What if the highlighted area is not displayed completely?

<img src='https://raw.githubusercontent.com/minaxorg/flutter_intro/master/doc/img3.jpg' width='300'
alt='Highlighted icon with padding that goes off-screen' />

A1. That's because Intro provides 8px padding by default.

<img src='https://raw.githubusercontent.com/minaxorg/flutter_intro/master/doc/img4.jpg' width='300'
alt='Highlighted icon with icon selecting to show padding' />

We can change it by setting the value of `padding`.

```dart
Intro(
  /// Set padding to zero (or negative) to reduce highlight size
  padding: EdgeInsets.zero,
  child: const YourApp(),
);
```
<img src='https://raw.githubusercontent.com/minaxorg/flutter_intro/master/doc/img5.jpg' width='300'
alt='Highlighted icon with smaller padding' />

### Q2. Can I set different configurations for each step?

A2. Yes, you can configure every `IntroStepBuilder`.

```dart
IntroStepBuilder(
  order: 3,
  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  borderRadius: const BorderRadius.all(Radius.circular(64)),
  builder: (context, key) => YourWidget(),
)
```

### Q3. Can I make the highlight area smaller?

A3. Yes, can do it by setting `padding` to a negative number.

```dart
IntroStepBuilder(
  order: 4,
  /// Reduce highlight size further
  padding: const EdgeInsets.symmetric(
    vertical: -5,
    horizontal: -5,
  ),
  builder: (context, key) => YourWidget(),
)
```
<img src='https://raw.githubusercontent.com/minaxorg/flutter_intro/master/doc/img6.jpg' width='300'
alt='Highlighted icon with even smaller padding' />

### Q4. If the user presses or gestures "back", an exception happens. How do I avoid this?

A4. You can call the dispose method of the intro instance.

```dart
WillPopScope(
  child: Scaffold(...),
  onWillPop: () async {
    final Intro intro = Intro.of(context);

    if (intro.status.isOpen == true) {
      intro.dispose();
      return false;
    }
    return true;
  },
)
```

### Q5. `WillPopScope` is deprecated, is there any better solution?

A5. As of v3.1.0, you can use `ValueNotifier<IntroStatus> statusNotifier`.
You can achieve the same effect through the following sample code.

```dart
ValueListenableBuilder(
  valueListenable: intro.statusNotifier,
  builder: (context, value, child) {
    return PopScope(
      canPop: !value.isOpen,
      onPopInvoked: (didPop) {
        if (!didPop) {
          intro.dispose();
        }
      },
      child: Scaffold(...),
    );
  },
)
```

## Example

Please check the example in `example/lib/main.dart`.
