import 'package:flutter/material.dart';
import 'package:islamy_app/services/notification_service.dart';

/// Simple test screen to verify adhan notifications work
class AdhanTestScreen extends StatefulWidget {
  const AdhanTestScreen({super.key});

  @override
  State<AdhanTestScreen> createState() => _AdhanTestScreenState();
}

class _AdhanTestScreenState extends State<AdhanTestScreen> {
  int _selectedReciterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adhan Notification Tester'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'Prayer Notification System Test',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              // Selected Reciter
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Adhan:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        NotificationService.selectedReciter?.name ?? 'None',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Select Reciter Dropdown
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Adhan Reciter:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      DropdownButton<int>(
                        value: _selectedReciterIndex,
                        isExpanded: true,
                        items: List.generate(
                          NotificationService.adhanReciters.length,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text(
                              NotificationService.adhanReciters[index].name,
                            ),
                          ),
                        ),
                        onChanged: (newIndex) {
                          if (newIndex != null) {
                            setState(() => _selectedReciterIndex = newIndex);
                            NotificationService.selectAdhanReciter(
                              NotificationService.adhanReciters[newIndex],
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Selected: ${NotificationService.adhanReciters[newIndex].name}',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Test Buttons Section
              Text(
                'Test Notifications:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              // Test with Adhan (20 seconds)
              ElevatedButton.icon(
                onPressed: _testWithAdhan20,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Test: With Adhan (20 sec)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 8),

              // Test with Adhan (30 seconds)
              ElevatedButton.icon(
                onPressed: _testWithAdhan30,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Test: With Adhan (30 sec)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 8),

              // Test without Adhan
              ElevatedButton.icon(
                onPressed: _testWithoutAdhan,
                icon: const Icon(Icons.notifications),
                label: const Text('Test: Notification Only (No Audio)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 8),

              // Stop Adhan
              ElevatedButton.icon(
                onPressed: _stopAdhan,
                icon: const Icon(Icons.stop),
                label: const Text('Stop Adhan Playback'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Info Card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ℹ️ How It Works:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• Click buttons above to test notifications\n'
                        '• If app is open: popup appears at top\n'
                        '• If app is in background: system notification shows\n'
                        '• Adhan plays automatically (check device volume!)\n'
                        '• Try minimizing the app to see background notification',
                        style: TextStyle(height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _testWithAdhan20() async {
    await NotificationService.showInstantNotification(
      'Fajr',
      'It\'s time to pray Fajr',
      playAdhan: true,
      adhanDuration: const Duration(seconds: 20),
    );
  }

  Future<void> _testWithAdhan30() async {
    await NotificationService.showInstantNotification(
      'Dhuhr',
      'It\'s time to pray Dhuhr',
      playAdhan: true,
      adhanDuration: const Duration(seconds: 30),
    );
  }

  Future<void> _testWithoutAdhan() async {
    await NotificationService.showInstantNotification(
      'Asr',
      'It\'s time to pray Asr',
      playAdhan: false,
    );
  }

  Future<void> _stopAdhan() async {
    await NotificationService.stopAdhan();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adhan stopped')),
    );
  }
}
