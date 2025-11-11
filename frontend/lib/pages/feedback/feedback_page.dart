import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final controller = WebViewController()
    ..loadRequest(Uri.parse("https://forms.gle/E8sLgZ1X49kaX5jA6"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            LucideIcons.chevronLeft,
            color: AppColor.onBackgroundVariant,
          ),
        ),
        title: Text(
          "Prześlij opinie",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColor.onBackground,
          ),
        ),
        shape: Border(bottom: BorderSide(color: AppColor.outline)),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
