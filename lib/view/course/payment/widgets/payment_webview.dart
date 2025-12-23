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
        title: const Text('Thanh toán MoMo'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Get.back(result: false);
          },
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.paymentUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useShouldOverrideUrlLoading: true,
              userAgent:
                  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },

            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url!;

              if (["http", "https"].contains(uri.scheme)) {
                return NavigationActionPolicy.ALLOW;
              }

              return NavigationActionPolicy.CANCEL;
            },

            // ---------------------------------
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });

              if (url != null) {
                final urlString = url.toString();
                // Kiểm tra xem đã quay về link kết quả chưa
                if (urlString.startsWith(widget.returnUrl)) {
                  final uri = Uri.parse(urlString);
                  final errorCode = uri.queryParameters['errorCode'];

                  // errorCode = 0 là thành công
                  if (errorCode == '0') {
                    Get.back(result: true);
                  } else {
                    Get.back(result: false);
                  }
                }
              }
            },
            onLoadStop: (controller, url) {
              setState(() {
                _isLoading = false;
              });
            },
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
