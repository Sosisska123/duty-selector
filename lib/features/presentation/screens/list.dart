import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/presentation/screens/lists/attendance_list.dart';
import 'package:duty_selector/features/presentation/screens/lists/duty_list.dart';
import 'package:duty_selector/features/presentation/screens/lists/group_list.dart';
import 'package:duty_selector/features/presentation/widgets/buttons_group/buttons_group.dart';
import 'package:duty_selector/features/presentation/widgets/buttons_group/group_button.dart';
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
        title: const TitleText(text: 'Записи'),
      ),
      body: ButtonsGroup(
        children: [
          GroupButton(
            icon: Ionicons.people_circle,
            text: 'Список группы',
            tapCallback: () => _openList(context, 'group'),
          ),
          GroupButton(
            icon: Ionicons.people_circle,
            text: 'Дежурства',
            tapCallback: () => _openList(context, 'duty'),
          ),
          GroupButton(
            icon: Ionicons.people_circle,
            text: 'Посещаемость (пока недоступно)',
            tapCallback: () => {},
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
