import 'package:flutter/material.dart';

class TitleDetailRow extends StatelessWidget {
  const TitleDetailRow({
    this.title,
    this.detail,
  });

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            title ?? '',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              detail ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
