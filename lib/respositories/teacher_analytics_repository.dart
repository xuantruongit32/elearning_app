import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// ================= MODEL DỮ LIỆU THỐNG KÊ =================
class TeacherAnalyticsData {
  final int totalStudents;
  final int activeCourses;
  final double totalRevenue;
  final double averageRating;
  final List<double> chartData; 
  final List<String> chartLabels; 
  final double completionRate;
  final double revenueGrowth;
  final Map<String, double> revenueByCourse;

  TeacherAnalyticsData({
    this.totalStudents = 0,
    this.activeCourses = 0,
    this.totalRevenue = 0.0,
    this.averageRating = 0.0,
    this.chartData = const [],
    this.chartLabels = const [],
    this.completionRate = 0.0,
    this.revenueGrowth = 0.0,
    this.revenueByCourse = const {},
  });
}

class TeacherAnalyticsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<TeacherAnalyticsData> getAnalytics(
    String teacherId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final coursesSnapshot = await _firestore
          .collection('courses')
          .where('instructorId', isEqualTo: teacherId)
          .get();

      if (coursesSnapshot.docs.isEmpty) {
        return TeacherAnalyticsData();
      }

      final courseIds = coursesSnapshot.docs.map((e) => e.id).toList();
      final activeCourses = coursesSnapshot.docs.length;

      final paymentsSnapshot = await _firestore
          .collection('payments')
          .where('teacherId', isEqualTo: teacherId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      double totalRevenue = 0.0;
      Map<String, double> revenueMap = {};

      for (var doc in paymentsSnapshot.docs) {
        final data = doc.data(); 
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        final courseId = data['courseId'] as String? ?? 'unknown';

        totalRevenue += amount;
        revenueMap[courseId] = (revenueMap[courseId] ?? 0) + amount;
      }

      List<QueryDocumentSnapshot> allEnrollments = [];

      for (var i = 0; i < courseIds.length; i += 10) {
        final end = (i + 10 < courseIds.length) ? i + 10 : courseIds.length;
        final chunk = courseIds.sublist(i, end);

        final enrollQuery = await _firestore
            .collection('enrollments')
            .where('courseId', whereIn: chunk)
            .where(
              'enrolledAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
            )
            .where(
              'enrolledAt',
              isLessThanOrEqualTo: Timestamp.fromDate(endDate),
            )
            .get();

        allEnrollments.addAll(enrollQuery.docs);
      }

      final totalStudents = allEnrollments.length;

      double totalProgress = 0.0;
      for (var doc in allEnrollments) {
        final data = doc.data() as Map<String, dynamic>;
        totalProgress += (data['progress'] as num? ?? 0).toDouble();
      }
      double avgCompletion = totalStudents > 0
          ? totalProgress / totalStudents / 100
          : 0.0;

      final isMonthView = endDate.difference(startDate).inDays > 31;
      Map<String, double> chartMap = {};

      for (var doc in allEnrollments) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = data['enrolledAt'] as Timestamp?;

        if (timestamp != null) {
          final date = timestamp.toDate();
          String key = isMonthView
              ? DateFormat('MM/yyyy').format(date)
              : DateFormat('dd/MM').format(date);

          chartMap[key] = (chartMap[key] ?? 0) + 1;
        }
      }

      List<String> chartLabels = chartMap.keys.toList();


      List<double> chartData = chartMap.values.toList();

      Map<String, double> namedRevenueMap = {};
      for (var entry in revenueMap.entries) {
        final courseDoc = coursesSnapshot.docs.firstWhereOrNull(
          (d) => d.id == entry.key,
        );
        final courseName = courseDoc != null
            ? ((courseDoc.data() as Map<String, dynamic>)['title'] as String? ??
                  'Khóa học')
            : 'Không xác định';

        // Cắt ngắn tên nếu quá dài
        final shortName = courseName.length > 15
            ? '${courseName.substring(0, 15)}...'
            : courseName;
        namedRevenueMap[shortName] = entry.value;
      }

      return TeacherAnalyticsData(
        totalStudents: totalStudents,
        activeCourses: activeCourses,
        totalRevenue: totalRevenue,
        averageRating: 4.8, 
        chartData: chartData,
        chartLabels: chartLabels,
        completionRate: avgCompletion,
        revenueByCourse: namedRevenueMap,
        revenueGrowth: 0.0,
      );
    } catch (e) {
      print("Error fetching analytics: $e");
      return TeacherAnalyticsData();
    }
  }
}

extension ListExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
