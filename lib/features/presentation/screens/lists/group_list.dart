import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class GroupList extends StatelessWidget {
  const GroupList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: TitleText(text: 'Список группы'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: onPressed,
        child: Icon(Ionicons.pencil, color: AppColors.text),
      ),
      body: Placeholder(),
    );
  }

  void onPressed() {
    logger.i('Pressed');
  }
}
