import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foss_warn/class/class_unified_push_handler.dart';
import 'package:foss_warn/views/introduction/widgets/base_slide.dart';

// TODO(PureTryOut): prettify
class IntroductionUnifiedPushSlide extends ConsumerWidget {
  const IntroductionUnifiedPushSlide({
    required this.onDistributorSelected,
    required this.selectedDistributor,
    super.key,
  });

  final String? selectedDistributor;
  final void Function(String distributor) onDistributorSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);

    var unifiedPushDistributors = ref.watch(unifiedPushDistributorsProvider);

    return IntroductionBaseSlide(
      imagePath: "assets/battery.png",
      title: "UnifiedPush",
      text:
          "You seem to have more than one UnifiedPush distributor installed, please select the one you want to use",
      footer: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
        ),
        child: Column(
          children: [
            for (var (index, distributor)
                in unifiedPushDistributors.indexed) ...[
              _DistributorListEntry(
                distributor: distributor,
                selected: selectedDistributor == distributor,
                first: index == 0,
                onPressed: onDistributorSelected,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DistributorListEntry extends StatelessWidget {
  const _DistributorListEntry({
    required this.distributor,
    required this.onPressed,
    this.selected = false,
    this.first = false,
  });

  final String distributor;
  final bool selected;
  final bool first;

  final void Function(String distributor) onPressed;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var topBorder = BorderSide.none;

    if (first) {
      topBorder = const BorderSide();
    }

    if (selected) {
      topBorder = first ? const BorderSide() : BorderSide.none;
    }

    return InkWell(
      onTap: () => onPressed(distributor),
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: topBorder,
            bottom: const BorderSide(),
            left: const BorderSide(),
            right: const BorderSide(),
          ),
          color: selected ? theme.colorScheme.secondaryContainer : null,
        ),
        child: Text(distributor),
      ),
    );
  }
}
