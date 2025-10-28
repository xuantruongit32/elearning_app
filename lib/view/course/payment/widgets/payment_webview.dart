import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String returnUrl;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.returnUrl,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán VNPAY'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Trả về false (thất bại/hủy) khi người dùng tự đóng
            Get.back(result: false);
          },
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.paymentUrl)),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });

              // ĐÂY CHÍNH LÀ "DÒNG CODE CỦA BẠN"
              // Kiểm tra xem URL có phải là URL trả về không
              if (url.toString().startsWith(widget.returnUrl)) {
                // Trích xuất vnp_ResponseCode từ URL
                final responseCode = url?.queryParameters['vnp_ResponseCode'];

                if (responseCode == '00') {
                  // Thanh toán THÀNH CÔNG
                  // Trả về true
                  Get.back(result: true);
                } else {
                  // Thanh toán THẤT BẠI (hoặc bị hủy)
                  // Trả về false
                  Get.back(result: false);
                }
              }
            },
            onLoadStop: (controller, url) {
              setState(() {
                _isLoading = false;
              });
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                _isLoading = false;
              });
              Get.back(result: false); // Lỗi tải trang
            },
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
