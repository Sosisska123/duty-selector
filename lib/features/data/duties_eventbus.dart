// duties_event_bus.dart
import 'dart:async';

import 'package:duty_selector/features/data/models/student.dart';

class DutiesEventBus {
  static final _controller = StreamController<List<Student>>.broadcast();

  static Stream<List<Student>> get stream => _controller.stream;

  static void send(List<Student> event) {
    _controller.add(event);
  }
}
