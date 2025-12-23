import 'package:elearning_app/models/chat_message.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/models/lesson.dart';
import 'package:elearning_app/models/question.dart';
import 'package:elearning_app/models/quiz.dart';
import 'package:elearning_app/models/quiz_attempt.dart';

class DummyDataService {
  static final List<Course> courses = [
    Course(
      id: '1',
      title: 'Flutter Cơ Bản',
      description:
          'Master Flutter and Dart from scratch. Build real-world cross-platform apps.',
      imageUrl: 'https://i.ytimg.com/vi/z9kOcyk5t8s/maxresdefault.jpg',
      instructorId: 'inst_1',
      categoryId: '1', // Programming
      price: 99.99,
      lessons: _createFlutterLessons(),
      level: 'Intermediate',
      requirements: [
        'Basic programming knowledge',
        'Computer with internet connection',
        'Dedication to learn',
      ],
      whatYouWillLearn: [
        'Build beautiful native apps',
        'Master Dart programming',
        'State management with GetX',
        'REST API integration',
        'Local data storage',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
      rating: 4.8,
      reviewCount: 245,
      enrollmentCount: 1200,
      isPremium: true,
    ),

    Course(
      id: '2',
      title: 'React nâng cao',
      description:
          'Learn to build modern web apps with React and master component-based architecture.',
      imageUrl: 'https://i.ytimg.com/vi/DLX62G4lc44/maxresdefault.jpg',
      instructorId: 'inst_2',
      categoryId: '1',
      price: 89.99,
      lessons: _createReactLessons(),
      level: 'Beginner',
      requirements: [
        'HTML, CSS basics',
        'Desire to learn frontend development',
      ],
      whatYouWillLearn: [
        'React fundamentals',
        'Hooks and state management',
        'Routing and navigation',
        'Building reusable components',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
      updatedAt: DateTime.now(),
      rating: 4.7,
      reviewCount: 190,
      enrollmentCount: 980,
    ),

    Course(
      id: '3',
      title: 'Python for Data Science',
      description:
          'Analyze data, create visualizations, and apply machine learning using Python.',
      imageUrl: 'https://i.ytimg.com/vi/rfscVS0vtbw/maxresdefault.jpg',
      instructorId: 'inst_3',
      categoryId: '2', // Data Science
      price: 109.99,
      lessons: _createPythonLessons(),
      level: 'Intermediate',
      requirements: ['Basic math skills', 'Interest in data analysis'],
      whatYouWillLearn: [
        'Data analysis with Pandas',
        'Visualization with Matplotlib',
        'Intro to Machine Learning',
        'Jupyter Notebooks',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
      rating: 4.9,
      reviewCount: 320,
      enrollmentCount: 2500,
      isPremium: true,
    ),

    Course(
      id: '4',
      title: 'UI/UX Design Fundamentals',
      description:
          'Learn the core principles of great design and how to create user-friendly interfaces.',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-6f9YIlGZMSbzrNS0lRpJVbIHLMeYk8-fhw&s',
      instructorId: 'inst_4',
      categoryId: '3',
      price: 79.99,
      lessons: _createDesignLessons(),
      level: 'Beginner',
      requirements: ['Creative mindset', 'No prior experience required'],
      whatYouWillLearn: [
        'Design thinking process',
        'Wireframing & prototyping',
        'Typography & color theory',
        'User research & testing',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
      rating: 4.6,
      reviewCount: 140,
      enrollmentCount: 830,
    ),

    Course(
      id: '5',
      title: 'Advanced Java Programming',
      description:
          'Deep dive into Java OOP, collections, concurrency, and design patterns.',
      imageUrl: 'https://i.ytimg.com/vi/grEKMHGYyns/maxresdefault.jpg',
      instructorId: 'inst_5',
      categoryId: '1',
      price: 94.99,
      lessons: _createJavaLessons(),
      level: 'Advanced',
      requirements: ['Basic Java knowledge', 'Computer with IDE installed'],
      whatYouWillLearn: [
        'Multithreading and concurrency',
        'Design patterns in Java',
        'File I/O and network programming',
        'Best practices for large apps',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
      updatedAt: DateTime.now(),
      rating: 4.5,
      reviewCount: 210,
      enrollmentCount: 1150,
    ),

    Course(
      id: '6',
      title: 'Kotlin Android Development',
      description:
          'Build powerful Android apps using Kotlin and modern Android tools.',
      imageUrl: 'https://i.ytimg.com/vi/F9UC9DY-vIU/maxresdefault.jpg',
      instructorId: 'inst_6',
      categoryId: '1',
      price: 84.99,
      lessons: _createKotlinLessons(),
      level: 'Intermediate',
      requirements: ['Basic programming knowledge', 'Android Studio setup'],
      whatYouWillLearn: [
        'Kotlin fundamentals',
        'Jetpack Compose basics',
        'Working with APIs',
        'App deployment to Play Store',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now(),
      rating: 4.7,
      reviewCount: 160,
      enrollmentCount: 1050,
    ),

    Course(
      id: '7',
      title: 'Node.js Complete Guide',
      description:
          'Master backend development with Node.js, Express, and MongoDB.',
      imageUrl: 'https://i.ytimg.com/vi/TlB_eWDSMt4/maxresdefault.jpg',
      instructorId: 'inst_7',
      categoryId: '1',
      price: 92.00,
      lessons: _createNodeLessons(),
      level: 'Intermediate',
      requirements: ['JavaScript basics', 'Knowledge of web fundamentals'],
      whatYouWillLearn: [
        'Building REST APIs',
        'Authentication with JWT',
        'CRUD with MongoDB',
        'Deployment with Heroku',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 18)),
      updatedAt: DateTime.now(),
      rating: 4.8,
      reviewCount: 310,
      enrollmentCount: 2100,
    ),

    Course(
      id: '8',
      title: 'Machine Learning with TensorFlow',
      description:
          'A hands-on approach to deep learning and AI using TensorFlow and Keras.',
      imageUrl: 'https://i.ytimg.com/vi/tPYj3fFJGjk/maxresdefault.jpg',
      instructorId: 'inst_8',
      categoryId: '2',
      price: 119.99,
      lessons: _createTensorflowLessons(),
      level: 'Advanced',
      requirements: [
        'Python and math basics',
        'Understanding of linear algebra',
      ],
      whatYouWillLearn: [
        'Neural networks fundamentals',
        'Convolutional and recurrent networks',
        'Training and optimization',
        'AI project deployment',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now(),
      rating: 4.9,
      reviewCount: 270,
      enrollmentCount: 1500,
    ),

    Course(
      id: '9',
      title: 'SQL Masterclass',
      description:
          'Learn how to query, manipulate and manage data with SQL effectively.',
      imageUrl: 'https://i.ytimg.com/vi/9Pzj7Aj25lw/maxresdefault.jpg',
      instructorId: 'inst_9',
      categoryId: '2',
      price: 64.99,
      lessons: _createSqlLessons(),
      level: 'Beginner',
      requirements: ['Basic computer skills'],
      whatYouWillLearn: [
        'Writing SQL queries',
        'Joins and subqueries',
        'Data aggregation',
        'Database design basics',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 35)),
      updatedAt: DateTime.now(),
      rating: 4.6,
      reviewCount: 180,
      enrollmentCount: 900,
    ),

    Course(
      id: '10',
      title: 'Git & GitHub Crash Course',
      description:
          'Version control essentials. Learn how to collaborate and manage code effectively.',
      imageUrl: 'https://i.ytimg.com/vi/USjZcfj8yxE/maxresdefault.jpg',
      instructorId: 'inst_10',
      categoryId: '1',
      price: 49.99,
      lessons: _createGitLessons(),
      level: 'Beginner',
      requirements: ['Any programming experience'],
      whatYouWillLearn: [
        'Git basics and commands',
        'Branching and merging',
        'Working with GitHub',
        'Team collaboration workflow',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      updatedAt: DateTime.now(),
      rating: 4.8,
      reviewCount: 310,
      enrollmentCount: 1900,
    ),
  ];

  static final List<Quiz> quizzes = [
    Quiz(
      id: '1',
      title: 'Kiến Thức Cơ Bản Flutter',
      description:
          'Kiểm tra hiểu biết của bạn về các kiến thức nền tảng Flutter.',
      timeLimit: 30,
      questions: _createFlutterQuizQuestions(),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isActive: true,
    ),
    Quiz(
      id: '2',
      title: 'Lập Trình Dart',
      description:
          'Đánh giá mức độ hiểu biết của bạn về các khái niệm trong Dart.',
      timeLimit: 25,
      questions: _createDartQuizQuestions(),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isActive: true,
    ),
  ];

  static final List<QuizAttempt> quizAttempts = [];

  static List<Lesson> _createFlutterLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Introduction to Flutter',
        description:
            'This is a detailed description for Introduction to Flutter.',
        videoUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: 30,
        resources: _createDummyResources(),
        isPreview: true,
      ),
      Lesson(
        id: '2',
        title: 'Dart Programming Basics',
        description:
            'This is a detailed description for Dart Programming Basics.',
        videoUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: 25,
        resources: _createDummyResources(),
        isPreview: false,
      ),
      //     _createLesson('2', 'Dart Programming Basics', true, false, false),
      _createLesson('3', 'Building UI with Widgets', false, false, false),
      _createLesson('4', 'State Management', false, false, false),
      _createLesson('5', 'Working with APIs', false, false, false),
      _createLesson('6', 'Local Data Storage', false, false, false),
    ];
  }

  static List<Lesson> _createReactLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Getting Started with React',
        description: 'Introduction to React, JSX, and component basics.',
        videoUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: 28,
        resources: _createDummyResources(),
        isPreview: true,
      ),
      _createLesson('2', 'Props and State', false, false, false),
      _createLesson('3', 'React Hooks', false, true, false),
      _createLesson('4', 'React Router', false, false, false),
      _createLesson('5', 'API Integration', false, true, false),
    ];
  }

  static List<Lesson> _createPythonLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Introduction to Python for Data Science',
        description: 'Learn Python basics for data analysis and visualization.',
        videoUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: 35,
        resources: _createDummyResources(),
        isPreview: true,
      ),
      _createLesson('2', 'Data Analysis with Pandas', false, false, false),
      _createLesson('3', 'Visualization with Matplotlib', false, true, false),
      _createLesson('4', 'Intro to Machine Learning', false, true, false),
      _createLesson('5', 'Project: Analyzing Real Data', false, false, false),
    ];
  }

  static List<Lesson> _createDesignLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Design Thinking Basics',
        description:
            'Understand how to approach problems with design thinking.',
        videoUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: 25,
        resources: _createDummyResources(),
        isPreview: true,
      ),
      _createLesson('2', 'Wireframing and Prototyping', false, false, false),
      _createLesson('3', 'Typography and Colors', false, false, false),
      _createLesson('4', 'User Testing', false, false, false),
      _createLesson('5', 'Final Design Project', false, false, false),
    ];
  }

  static List<Lesson> _createJavaLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Java OOP Review',
        description: 'Deep dive into classes, inheritance, and polymorphism.',
        videoUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: 32,
        resources: _createDummyResources(),
        isPreview: true,
      ),
      _createLesson('2', 'Collections Framework', false, false, false),
      _createLesson('3', 'Multithreading in Java', false, true, false),
      _createLesson('4', 'Design Patterns', false, false, false),
      _createLesson('5', 'Networking and File I/O', false, true, false),
    ];
  }

  static List<Lesson> _createKotlinLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Introduction to Kotlin',
        description: 'Kotlin basics and setting up Android Studio.',
        videoUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: 26,
        resources: _createDummyResources(),
        isPreview: true,
      ),
      _createLesson('2', 'Functions and Lambdas', false, true, false),
      _createLesson('3', 'Android Layouts', false, false, false),
      _createLesson('4', 'Networking with Retrofit', false, false, false),
      _createLesson('5', 'Publishing Your App', false, false, true),
    ];
  }

  static List<Lesson> _createNodeLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Intro to Node.js and NPM',
        description: 'Setup Node environment and understand NPM packages.',
        videoUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: 27,
        resources: _createDummyResources(),
        isPreview: true,
      ),
      _createLesson('2', 'Express Framework', false, false, false),
      _createLesson('3', 'MongoDB Basics', false, true, false),
      _createLesson('4', 'Authentication with JWT', false, true, false),
      _createLesson('5', 'Deploying to Cloud', false, true, false),
    ];
  }

  static List<Lesson> _createTensorflowLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Getting Started with TensorFlow',
        description: 'Learn what TensorFlow is and how to install it.',
        videoUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: 33,
        resources: _createDummyResources(),
        isPreview: true,
      ),
      _createLesson('2', 'Neural Networks 101', false, false, false),
      _createLesson('3', 'CNN and Image Data', false, false, false),
      _createLesson('4', 'RNN and Text Data', false, false, false),
      _createLesson('5', 'Model Deployment', false, false, false),
    ];
  }

  static List<Lesson> _createSqlLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Intro to SQL',
        description: 'Learn database basics and how SQL works.',
        videoUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: 20,
        resources: _createDummyResources(),
        isPreview: true,
      ),
      _createLesson('2', 'SELECT and WHERE Clauses', false, false, false),
      _createLesson('3', 'JOIN Operations', false, true, false),
      _createLesson('4', 'GROUP BY and HAVING', false, false, false),
      _createLesson('5', 'Database Design', false, true, false),
    ];
  }

  static List<Lesson> _createGitLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Introduction to Git',
        description: 'Learn version control concepts and Git setup.',
        videoUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        duration: 18,
        resources: _createDummyResources(),
        isPreview: true,
      ),
      _createLesson('2', 'Committing and Branching', false, true, false),
      _createLesson('3', 'Merging and Conflicts', false, false, false),
      _createLesson('4', 'Working with GitHub', false, true, false),
      _createLesson('5', 'Team Workflow', false, false, false),
    ];
  }

  static Lesson _createLesson(
    String id,
    String title,
    bool isPreview,
    bool isCompleted,
    bool isLocked,
  ) {
    return Lesson(
      id: 'lesson_$id',
      title: title,
      description: 'This is a detailed description for $title.',
      videoUrl:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      duration: 25,
      resources: _createDummyResources(),
      isPreview: isPreview,
    );
  }

  static List<Resource> _createDummyResources() {
    return [
      Resource(
        id: 'res1',
        title: 'Lesson Slide',
        type: 'pdf',
        url: 'https://example.com/slides.pdf',
      ),
      Resource(
        id: 'res1',
        title: 'Excersise File',
        type: 'zip',
        url: 'https://example.com/excersise.zip',
      ),
    ];
  }

  static Course getCourseById(String id) {
    return courses.firstWhere(
      (course) => course.id == id,
      orElse: () => courses.first,
    );
  }

  static List<Course> getCoursesByCategory(String categoryId) {
    return courses.where((course) => course.categoryId == categoryId).toList();
  }

  static List<Course> getInstructorCourses(String instructorId) {
    return courses
        .where((course) => course.instructorId == instructorId)
        .toList();
  }

  static bool isCourseCompleted(String courseId) {
    final course = getCourseById(courseId);
    return false;
  }

  static List<Question> _createDartQuizQuestions() {
    return [
      Question(
        id: '1',
        text: 'Dart là gì?',
        options: [
          Option(id: 'a', text: 'Một ngôn ngữ cơ sở dữ liệu'),
          Option(id: 'b', text: 'Một ngôn ngữ lập trình đa mục đích'),
          Option(id: 'c', text: 'Một ngôn ngữ đánh dấu'),
          Option(id: 'd', text: 'Một công cụ scripting'),
        ],
        correctOptionId: 'b',
        points: 1,
      ),
      Question(
        id: '2',
        text: 'Công ty nào phát triển Dart?',
        options: [
          Option(id: 'a', text: 'Facebook'),
          Option(id: 'b', text: 'Microsoft'),
          Option(id: 'c', text: 'Google'),
          Option(id: 'd', text: 'Amazon'),
        ],
        correctOptionId: 'c',
        points: 1,
      ),
      Question(
        id: '3',
        text: 'Từ khóa nào dùng để khai báo hằng số trong Dart?',
        options: [
          Option(id: 'a', text: 'final'),
          Option(id: 'b', text: 'let'),
          Option(id: 'c', text: 'static'),
          Option(id: 'd', text: 'const'),
        ],
        correctOptionId: 'd',
        points: 1,
      ),
    ];
  }

  static List<Question> _createFlutterQuizQuestions() {
    return [
      Question(
        id: '1',
        text: 'Flutter là gì?',
        options: [
          Option(id: 'a', text: 'Một framework UI để xây dựng ứng dụng native'),
          Option(id: 'b', text: 'Một ngôn ngữ lập trình'),
          Option(id: 'c', text: 'Một hệ quản trị cơ sở dữ liệu'),
          Option(id: 'd', text: 'Một công cụ thiết kế'),
        ],
        correctOptionId: 'a',
        points: 1,
      ),
      Question(
        id: '2',
        text: 'Ngôn ngữ lập trình nào được sử dụng trong Flutter?',
        options: [
          Option(id: 'a', text: 'Java'),
          Option(id: 'b', text: 'Kotlin'),
          Option(id: 'c', text: 'Dart'),
          Option(id: 'd', text: 'Swift'),
        ],
        correctOptionId: 'c',
        points: 1,
      ),
      Question(
        id: '3',
        text: 'Ai phát triển Flutter?',
        options: [
          Option(id: 'a', text: 'Facebook'),
          Option(id: 'b', text: 'Google'),
          Option(id: 'c', text: 'Microsoft'),
          Option(id: 'd', text: 'Amazon'),
        ],
        correctOptionId: 'b',
        points: 1,
      ),
      Question(
        id: '4',
        text: 'Widget nào được dùng cho bố cục trong Flutter?',
        options: [
          Option(id: 'a', text: 'Container'),
          Option(id: 'b', text: 'ListView'),
          Option(id: 'c', text: 'Column'),
          Option(id: 'd', text: 'Tất cả các đáp án trên'),
        ],
        correctOptionId: 'd',
        points: 1,
      ),
      Question(
        id: '5',
        text: 'Tính năng "hot reload" trong Flutter dùng để làm gì?',
        options: [
          Option(id: 'a', text: 'Khởi động lại ứng dụng hoàn toàn'),
          Option(
            id: 'b',
            text:
                'Cập nhật thay đổi mã ngay lập tức mà không cần khởi động lại ứng dụng',
          ),
          Option(id: 'c', text: 'Xóa bộ nhớ đệm'),
          Option(id: 'd', text: 'Tự động build APK'),
        ],
        correctOptionId: 'b',
        points: 1,
      ),
    ];
  }

  static Quiz getQuizById(String id) {
    return quizzes.firstWhere(
      (quiz) => quiz.id == id,
      orElse: () => quizzes.first,
    );
  }

  static void saveQuizAttempt(QuizAttempt attempt) {
    quizAttempts.add(attempt);
  }

  static List<QuizAttempt> getQuizAttempts(String userId) {
    return quizAttempts.where((attempt) => attempt.userId == userId).toList();
  }

  static final Set<String> _purchasedCourseIds = {};

  static bool isCourseUnlocked(String courseId) {
    final course = getCourseById(courseId);
    return !course.isPremium || _purchasedCourseIds.contains(courseId);
  }

  static void addPurchasedCourse(String courseId) {
    _purchasedCourseIds.add(courseId);
  }

  static TeacherStats getTeacherStats(String instructorId) {
    final instructorCourses = getInstructorCourses(instructorId);
    final stats = teacherStats[instructorId] ?? TeacherStats.empty();

    return TeacherStats(
      totalStudents: instructorCourses.fold(
        0,
        (sum, course) => sum + course.enrollmentCount,
      ),
      activeCourses: instructorCourses.length,
      totalRevenue: instructorCourses.fold(
        0.0,
        (sum, course) => sum + (course.price * course.enrollmentCount),
      ),
      averageRating: instructorCourses.isEmpty
          ? 0.0
          : instructorCourses.fold(0.0, (sum, course) => sum + course.rating) /
                instructorCourses.length,
      monthlyEnrollments: stats.monthlyEnrollments,
      monthlyRevenue: stats.monthlyRevenue,
      studentEngagement: stats.studentEngagement,
    );
  }

  static final Map<String, TeacherStats> teacherStats = {
    'inst_1': TeacherStats(
      totalStudents: 1234,
      activeCourses: 8,
      totalRevenue: 12345.67,
      averageRating: 4.8,
      monthlyEnrollments: [156, 189, 234, 278, 312, 289],
      monthlyRevenue: [1234, 1567, 1890, 2100, 2345, 2189],
      studentEngagement: StudentEngagement(
        averageCompletionRate: 0.78,
        averageTimePerLesson: 45,
        activeStudentsThisWeek: 156,
        courseCompletionRates: {
          'Flutter Cơ Bản': 0.85,
          'Flutter Nâng Cao': 0.72,
          'Quản lý Trạng Thái Flutter': 0.68,
        },
      ),
    ),
  };

  static final Map<String, List<StudentProgress>> studentProgress = {
    'inst_1': [
      StudentProgress(
        studentId: 'student_1',
        studentName: 'Hoang Truong',
        courseId: '1',
        courseName: 'Flutter cơ bản',
        progress: 0.75,
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
        quizScores: [85, 92, 78, 88],
        completedLessons: 12,
        totalLessons: 16,
        averageTimePerLesson: 45,
      ),
      StudentProgress(
        studentId: 'student_2',
        studentName: 'Hoang Quan',
        courseId: '1',
        courseName: 'Dart nâng cao',
        progress: 0.60,
        lastActive: DateTime.now().subtract(const Duration(days: 1)),
        quizScores: [95, 88, 82],
        completedLessons: 9,
        totalLessons: 16,
        averageTimePerLesson: 38,
      ),
    ],
  };

  static List<StudentProgress> getStudentProgress(String instructorId) {
    final instructorCourses = getInstructorCourses(instructorId);
    final courseIds = instructorCourses.map((c) => c.id).toSet();

    // Filter student progress for instructor's courses only
    return studentProgress[instructorId]
            ?.where((progress) => courseIds.contains(progress.courseId))
            .toList() ??
        [];
  }

  static Stream<List<ChatMessage>> getChatMessages(String courseId) {
    return Stream.value(
      _dummyChats.values
          .expand((messages) => messages)
          .where((msg) => msg.courseId == courseId)
          .toList(),
    );
  }

  static Stream<List<ChatMessage>> getTeacherChats(String instructorId) {
    return Stream.value(_dummyChats[instructorId] ?? []);
  }

  static Map<String, List<ChatMessage>> getTeacherChatsByCourse(
    String instructorId,
  ) {
    final Map<String, List<ChatMessage>> chatsByCourse = {};
    final messages = _dummyChats[instructorId] ?? [];

    for (var message in messages) {
      if (!chatsByCourse.containsKey(message.courseId)) {
        chatsByCourse[message.courseId] = [];
      }
      chatsByCourse[message.courseId]!.add(message);
    }

    return chatsByCourse;
  }

  static final Map<String, List<ChatMessage>> _dummyChats = {
    'inst_1': [
      ChatMessage(
        id: '1',
        senderId: 'student_1',
        receiverId: 'inst_1',
        courseId: '1',
        message: 'Chào thầy, em có một câu hỏi về kiến trúc ứng dụng',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatMessage(
        id: '2',
        senderId: 'student_2',
        receiverId: 'inst_1',
        courseId: '1',
        message: 'Bao giờ có buổi học trực tiếp tiếp theo vậy ạ?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      ChatMessage(
        id: '3',
        senderId: 'student_3',
        receiverId: 'inst_1',
        courseId: '2',
        message: 'Thầy có thể xem giúp em bài thiết kế mới nhất không ạ?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
  };

  static bool isLessonCompleted(String courseId, String lessonId) {
    final course = getCourseById(courseId);
    return false;
  }

  static void updateLessonStatus(
    String courseId,
    String lessonId, {
    bool? isCompleted,
    bool? isLocked,
  }) {
    final courseIndex = courses.indexWhere((c) => c.id == courseId);

    if (courseIndex != -1) {
      final course = courses[courseIndex];
      final lessonIndex = course.lessons.indexWhere((l) => l.id == lessonId);

      if (lessonIndex != -1) {
        var updatedLesson = course.lessons[lessonIndex];

        courses[courseIndex].lessons[lessonIndex] = updatedLesson;
      }
    }
  }
}

class StudentProgress {
  final String studentId;
  final String studentName;
  final String courseId;
  final String courseName;
  final double progress;
  final DateTime lastActive;
  final List<int> quizScores;
  final int completedLessons;
  final int totalLessons;
  final int averageTimePerLesson;

  StudentProgress({
    required this.studentId,
    required this.studentName,
    required this.courseId,
    required this.courseName,
    required this.progress,
    required this.lastActive,
    required this.quizScores,
    required this.completedLessons,
    required this.totalLessons,
    required this.averageTimePerLesson,
  });

  double get averageScore {
    if (quizScores.isEmpty) return 0.0;
    return quizScores.reduce((a, b) => a + b) / quizScores.length / 100;
  }
}

class StudentEngagement {
  final double averageCompletionRate;
  final int averageTimePerLesson;
  final int activeStudentsThisWeek;
  final Map<String, double> courseCompletionRates;

  StudentEngagement({
    required this.averageCompletionRate,
    required this.averageTimePerLesson,
    required this.activeStudentsThisWeek,
    required this.courseCompletionRates,
  });

  factory StudentEngagement.empty() => StudentEngagement(
    averageCompletionRate: 0,
    averageTimePerLesson: 0,
    activeStudentsThisWeek: 0,
    courseCompletionRates: {},
  );
}

class TeacherStats {
  final int totalStudents;
  final int activeCourses;
  final double totalRevenue;
  final double averageRating;
  final List<int> monthlyEnrollments;
  final List<double> monthlyRevenue;
  final StudentEngagement studentEngagement;

  TeacherStats({
    required this.totalStudents,
    required this.activeCourses,
    required this.totalRevenue,
    required this.averageRating,
    required this.monthlyEnrollments,
    required this.monthlyRevenue,
    required this.studentEngagement,
  });

  factory TeacherStats.empty() => TeacherStats(
    totalStudents: 0,
    activeCourses: 0,
    totalRevenue: 0,
    averageRating: 0,
    monthlyEnrollments: [],
    monthlyRevenue: [],
    studentEngagement: StudentEngagement.empty(),
  );
}
