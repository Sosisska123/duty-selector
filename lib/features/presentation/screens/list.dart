import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/presentation/screens/lists/attendance_list.dart';
import 'package:duty_selector/features/presentation/screens/lists/duty_list.dart';
import 'package:duty_selector/features/presentation/screens/lists/group_list.dart';
import 'package:duty_selector/features/presentation/widgets/cards/list_card.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class ListScreen extends StatelessWidget {
  const ListScreen({super.key, required this.databaseService});

  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: TitleText(text: 'Записи'),
      ),
      body: Column(
        spacing: AppSpacing.small,
        children: [
          ListCard(
            tapCallback: () => _openList(context, 'group'),
            icon: Icon(Ionicons.people_circle, color: AppColors.accent),
            text: 'Список группы',
          ),
          ListCard(
            tapCallback: () => _openList(context, 'duty'),
            icon: Icon(Ionicons.people_circle, color: AppColors.accent),
            text: 'Дежурства',
          ),
          ListCard(
            tapCallback: () => _openList(context, 'attendance'),
            icon: Icon(Ionicons.people_circle, color: AppColors.accent),
            text: 'Посещаемость',
          ),
        ],
      ),
    );
  }

  void _openList(BuildContext context, String listName) {
    logger.i('Move to screen $listName');

    switch (listName) {
      case 'attendance':
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: AttendanceList(databaseService: databaseService),
        );
        break;
      case 'duty':
        PersistentNavBarNavigator.pushNewScreen(context, screen: DutyList());
        break;
      case 'group':
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: GroupList(databaseService: databaseService),
        );
        break;
      default:
    }
  }
}
