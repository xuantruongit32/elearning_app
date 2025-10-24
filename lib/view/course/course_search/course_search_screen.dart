import 'dart:async';

import 'package:elearning_app/bloc/filtered_course/filtered_course_bloc.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce.run(() {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        context.read<FilteredCourseBloc>().add(SearchCourses(query));
      } else {
        context.read<FilteredCourseBloc>().add(ClearFilteredCourses());
      }
    });
  }

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
