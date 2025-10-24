import 'dart:async';

import 'package:flutter/material.dart';

class CourseSearchScreen extends StatefulWidget {
  const CourseSearchScreen({super.key});

  @override
  State<CourseSearchScreen> createState() => _CourseSearchScreenState();
}

class _CourseSearchScreenState extends State<CourseSearchScreen> {
  final _searchController = TextEditingController();
  final _debounce = Debouncer(milliseconds: 500);
  final _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}