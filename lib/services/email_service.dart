import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  final String _serviceId = 'service_8iadw1h';
  final String _templateId = 'template_kemcm42';
  final String _userId = '0H9TfWOAx6764DwLF';

  Future<void> sendEmail({
    required String toName,
    required String toEmail,
    required String message,
    String subject = 'Thông báo từ TT Elearning',
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _userId,
          'template_params': {
            'to_name': toName,
            'to_email': toEmail,
            'subject': subject,
            'message': message,
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Email sent successfully!');
      } else {
        print('Failed to send email: ${response.body}');
      }
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}
