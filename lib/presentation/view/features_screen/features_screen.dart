import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeaturesScreen extends StatelessWidget {
  final List<_Feature> features = [
    _Feature(
      'Authentication',
      'Secure login with Firebase/Auth support',
      Icons.lock,
    ),
    _Feature(
      'Notifications',
      'Push and local notifications ready',
      Icons.notifications_active,
    ),
    _Feature('Analytics', 'Track user events and behavior', Icons.insights),
    _Feature(
      'Error Handling',
      'Global error capture and logging',
      Icons.warning,
    ),
    _Feature(
      'State Management',
      'Provider / Riverpod / Bloc options',
      Icons.smart_toy,
    ),
    _Feature('Routing', 'Modular, scalable navigation setup', Icons.alt_route),
    _Feature(
      'Dependency Injection',
      'Preconfigured GetIt/Injectable',
      Icons.electrical_services,
    ),
    _Feature('Shared Preferences', 'Local storage made easy', Icons.save),
    _Feature(
      'Responsive UI',
      'Adaptive design for all screen sizes',
      Icons.devices_fold,
    ),
    _Feature(
      'Clean Architecture',
      'Layered and scalable folder structure',
      Icons.auto_awesome_mosaic,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 Features of Flutter Platter'),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: features.length,
          separatorBuilder:
              (_, __) => Divider(color: Theme.of(context).colorScheme.tertiary),
          itemBuilder: (context, index) {
            final feature = features[index];
            return ListTile(
              leading: Icon(
                size: 30,
                feature.icon,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: Text(
                feature.title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                feature.subtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Feature {
  _Feature(this.title, this.subtitle, this.icon);
  final String title;
  final String subtitle;
  final IconData icon;
}
