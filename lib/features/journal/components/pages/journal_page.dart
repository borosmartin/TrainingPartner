import 'package:flutter/cupertino.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Journal', style: boldNormalBlack),
      ],
    );
  }
}
