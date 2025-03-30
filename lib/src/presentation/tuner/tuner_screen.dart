import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuner/src/presentation/tuner/tuner_view_model.dart';

class TunerScreen extends ConsumerWidget {
  const TunerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tunerViewModelProvider);
    final notifier = ref.read(tunerViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'チューナー',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "テスト440Hz",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            ElevatedButton(
              onPressed: () {
                notifier.toggleRecording();
              },
              child: Text(state.isRecording ? "停止" : "開始"),
            )
          ],
        ),
      ),
    );
  }
}
