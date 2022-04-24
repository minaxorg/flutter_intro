import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class FutureGuidePage extends StatefulWidget {
  const FutureGuidePage({Key? key}) : super(key: key);

  @override
  State<FutureGuidePage> createState() => _FutureGuidePageState();
}

class _FutureGuidePageState extends State<FutureGuidePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Intro? intro = Intro.of(context);

        if (intro?.status.isOpen == true) {
          intro?.dispose();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntroStepBuilder(
                  /// 2nd guide
                  order: 2,
                  text: '2nd guide',
                  builder: (context, key) => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        key: key,
                        width: 50,
                        child: const Placeholder(
                          fallbackHeight: 50,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                FutureBuilder(
                  future: Future.delayed(
                      const Duration(
                        seconds: 1,
                      ), () {
                    return 'Good';
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return IntroStepBuilder(
                        order: 3,
                        onHighlightWidgetTap: () {
                          debugPrint('3333');
                        },
                        overlayBuilder: (_) {
                          return Container(
                            color: Colors.red,
                            child: const Placeholder(
                              fallbackHeight: 100,
                              fallbackWidth: 100,
                            ),
                          );
                        },
                        builder: (context, key) => SizedBox(
                          width: 50,
                          height: 50,
                          key: key,
                          child: const Placeholder(),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: IntroStepBuilder(
          /// 1st guide
          order: 1,
          text: '1st guide',
          padding: const EdgeInsets.symmetric(
            vertical: -5,
            horizontal: -5,
          ),
          onHighlightWidgetTap: () {
            debugPrint('1111');
          },
          borderRadius: const BorderRadius.all(Radius.circular(64)),
          builder: (context, key) => FloatingActionButton(
            key: key,
            child: const Icon(
              Icons.play_arrow,
            ),
            onPressed: () {
              Intro.of(context)?.start();
            },
          ),
        ),
      ),
    );
  }
}
