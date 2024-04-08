import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shapes_drawing/features/shapes_drawing/providers/providers.dart';

class AlignToGridButton extends ConsumerWidget {
  const AlignToGridButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref.read(alignToGridEnabledProvider.notifier).state = !ref.read(alignToGridEnabledProvider);
        if (ref.read(alignToGridEnabledProvider)) {
          ref.read(shapeNotifierProvider.notifier).alignToGrid(ref.read(gridStepProvider));
        }
      },
      icon: (ref.watch(alignToGridEnabledProvider))
          ? Image.asset('assets/icons/hashtag_active.png')
          : Image.asset('assets/icons/hashtag_icon.png'),
    );
  }
}
