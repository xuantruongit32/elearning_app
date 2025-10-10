import 'package:elearning_app/models/category.dart';
import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:elearning_app/view/home/widgets/category_section.dart';
import 'package:elearning_app/view/home/widgets/home_app_bar.dart';
import 'package:elearning_app/view/home/widgets/in_progress_section.dart';
import 'package:elearning_app/view/home/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Category> categories = [
    Category(
      id: '1',
      name: 'Programming',
      icon: Icons.code,
      courseCount: DummyDataService.getCoursesByCategory('1').length,
    ),
    Category(
      id: '2',
      name: 'Data Science',
      icon: Icons.data_object,
      courseCount: DummyDataService.getCoursesByCategory('2').length,
    ),
    Category(
      id: '3',
      name: 'Design',
      icon: Icons.design_services,
      courseCount: DummyDataService.getCoursesByCategory('3').length,
    ),
    Category(
      id: '4',
      name: 'Business',
      icon: Icons.business,
      courseCount: DummyDataService.getCoursesByCategory('4').length,
    ),
    Category(
      id: '5',
      name: 'Music',
      icon: Icons.music_note,
      courseCount: DummyDataService.getCoursesByCategory('5').length,
    ),
    Category(
      id: '6',
      name: 'Photography',
      icon: Icons.photo,
      courseCount: DummyDataService.getCoursesByCategory('6').length,
    ),
    Category(
      id: '7',
      name: 'Language',
      icon: Icons.language,
      courseCount: DummyDataService.getCoursesByCategory('7').length,
    ),
    Category(
      id: '8',
      name: 'Personal Development',
      icon: Icons.psychology,
      courseCount: DummyDataService.getCoursesByCategory('8').length,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const HomeAppBar(),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SearchBarWidget(),
              const SizedBox(height: 32),
              CategorySection(categories: categories),
              const InProgressSection(),
            ]),
          ),
        ),
      ],
    );
  }
  
}
