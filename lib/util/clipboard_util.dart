import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipboardUtil {
  static copyToClipboard(String content) async {
    await Clipboard.setData(ClipboardData(text: content));
  }

  static copiedSnackBar() => SnackBar(
      backgroundColor: Colors.green,
      content: const Text('Password was copied to clipboard'));
}
