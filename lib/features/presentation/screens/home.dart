import 'dart:async';

import 'package:duty_selector/features/data/duties_eventbus.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:duty_selector/features/presentation/widgets/quick_access/last_duties.dart';
import 'package:duty_selector/features/presentation/widgets/quick_access/select_duty.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseService databaseService;
  const HomeScreen({super.key, required this.databaseService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    sub = DutiesEventBus.stream.listen((e) {
      if (e.isNotEmpty) {
        showSnack(e);
      }
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xlarge,
        children: [
          SizedBox(height: AppSpacing.medium),
          LastDuties(databaseService: widget.databaseService),
          SelectDuty(databaseService: widget.databaseService),
        ],
      ),
    );
  }

  void showSnack(List<Student> e) {
    // FIXME: The following assertion was thrown during a scheduler callback:
    // There are multiple heroes that share the same tag within a subtree.
    // Within each subtree for which heroes are to be animated (i.e. a PageRoute subtree), each Hero must
    // have a unique non-null tag.
    // In this case, multiple heroes had the following tag: <SnackBar Hero tag - Text("Выбрано ")>
    // ├# Here is the subtree for one of the offending heroes: Hero
    final snackBar = SnackBar(
      content: Text('Выбрано ${e.map((e) => e.initials).join(', ')}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
