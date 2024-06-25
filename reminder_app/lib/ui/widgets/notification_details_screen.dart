import 'package:flutter/material.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String startTime;
  final String endTime;

  const NotificationDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          color: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      startTime,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(width: 18.0),
                    const Icon(
                      Icons.access_time,
                    ),
                    Text(
                      endTime,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
