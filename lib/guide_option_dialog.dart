import 'package:flutter/material.dart';
import 'package:moonbase_explore/screen/create_guide/create_guide_screen.dart';
import 'package:moonbase_explore/widgets/common_text.dart';
import 'package:moonbase_theme/themes/moonbase_dark_theme.dart';
import 'package:tempo_x/tempo_plugin_handler.dart';

import 'guide_ai_screen.dart';

void showGuidanceDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: TText(
            'Guide Creation Method',
            variant: TypographyVariant.h1,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OptionCard(
              icon: Icons.memory,
              title: 'AI-Guided',
              description: 'Let AI guide you through the process.',
              color: MoonbaseDarkTheme.getTheme().indicatorColor,
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GuideAIScreen()),
                );
              },
            ),
            const SizedBox(height: 16.0),
            OptionCard(
              icon: Icons.settings,
              title: 'Manual',
              description: 'Manually choose your options.',
              color: MoonbaseDarkTheme.getTheme().primaryColorDark,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MoonbaseExplorePluginHandler(
                          child: CreateGuideScreen())),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

class OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onPressed;

  const OptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64.0,
                color: color,
              ),
              const SizedBox(height: 16.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16.0,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
