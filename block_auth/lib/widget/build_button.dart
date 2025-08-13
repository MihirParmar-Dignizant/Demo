import 'package:flutter/material.dart';


Widget buildButton({
  required String text,
  VoidCallback? onPressed,
  bool isGoogle = false,
  Color backgroundColor = Colors.white,
  Color textColor = Colors.black,
  double borderRadius = 8,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 14), SizedBox? child,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Show Google logo if it's a Google button
          if (isGoogle) ...[
            Image.network(
              'https://www.citypng.com/public/uploads/preview/google-logo-icon-gsuite-hd-701751694791470gzbayltphh.png', // Google logo URL
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 10),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    ),
  );
}
