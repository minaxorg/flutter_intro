import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class AdvancedGuidePage extends StatefulWidget {
  const AdvancedGuidePage({Key? key}) : super(key: key);

  @override
  State<AdvancedGuidePage> createState() => _AdvancedGuidePageState();
}

class _AdvancedGuidePageState extends State<AdvancedGuidePage> {
  bool rendered = false;

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
                  overlayBuilder: (params) {
                    return Container(
                      color: Colors.teal,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            params.onNext != null
                                ? 'Now you can continue.'
                                : 'Click highlight area to add new widget.',
                          ),
                          Row(
                            children: [
                              IntroButton(
                                text: 'Prev',
                                onPressed: params.onPrev,
                              ),
                              IntroButton(
                                text: 'Next',
                                onPressed: params.onNext,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  onHighlightWidgetTap: () {
                    setState(() {
                      rendered = true;
                    });
                  },
                  builder: (context, key) => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Placeholder(
                        key: key,
                        fallbackWidth: 100,
                        fallbackHeight: 100,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                rendered
                    ? IntroStepBuilder(
                        order: 3,
                        onWidgetLoad: () {
                          Intro.of(context)?.refresh();
                        },
                        overlayBuilder: (params) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.teal,
                            child: Column(
                              children: [
                                const Text(
                                  'Haha haha.',
                                ),
                                Row(
                                  children: [
                                    IntroButton(
                                      onPressed: params.onPrev,
                                      text: 'Prev',
                                    ),
                                    IntroButton(
                                      onPressed: params.onNext,
                                      text: 'Next',
                                    ),
                                    IntroButton(
                                      onPressed: params.onFinish,
                                      text: 'Finish',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        builder: (context, key) => Text(
                          'delay render and with custom overlay.',
                          key: key,
                        ),
                      )
                    : const SizedBox.shrink(),
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
