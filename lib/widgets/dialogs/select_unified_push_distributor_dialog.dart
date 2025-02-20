import 'package:flutter/material.dart';

class SelectUnifiedPushDistributorDialog extends StatelessWidget {
  const SelectUnifiedPushDistributorDialog({
    required this.distributors,
    super.key,
  });

  final List<String> distributors;

  @override
  Widget build(BuildContext context) {
    var navigator = Navigator.of(context);

    return SimpleDialog(
      title: const Text('Select push distributor'),
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            "Please select the UnifiedPush distributor which FOSSWarn should use.",
          ),
        ),
        ...distributors.map<Widget>(
          (distributor) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: SimpleDialogOption(
                onPressed: () => navigator.pop(distributor),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(distributor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
