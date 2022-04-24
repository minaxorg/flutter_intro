import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class SimpleUse extends StatelessWidget {
  const SimpleUse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: Center(
            child: Column(
              children: [
                IntroStepBuilder(
                  order: 1,
                  text:
                      'Simple use IntroStepBuilder to include widget that need to be guide.',
                  builder: (context, key) => Text(
                    'Tap the floatingActionButton to start.',
                    key: key,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                IntroStepBuilder(
                  order: 2,
                  text:
                      'If you need more customization, please see other examples.',
                  builder: (context, key) => Text(
                    'And you can use `buttonTextBuilder` to set the button text.',
                    key: key,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.play_arrow,
          ),
          onPressed: () {
            Intro.of(context)?.start();
          },
        ),
      ),
      onWillPop: () async {
        Intro? intro = Intro.of(context);

        if (intro?.status.isOpen == true) {
          intro?.dispose();
          return false;
        }
        return true;
      },
    );
  }
}
