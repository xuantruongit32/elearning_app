import 'package:elearning_app/view/notifications/widgets/notification_card.dart';
import 'package:flutter/material.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return NotificationCard(
          title: 'Khóa học mới đã có',
          message: 'Hãy xem ngay khóa học Flutter nâng cao mới!',
          time: '2 giờ trước',
          icon: Icons.school,
          isUnread: index == 0,
        );
      },
    );
  }
}
