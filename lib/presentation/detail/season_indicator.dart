import 'package:flutter/material.dart';

class SeasonIndicator extends StatelessWidget {
  const SeasonIndicator({
    Key? key,
    required this.fruitingMonths,
  }) : super(key: key);

  /// List of integers from 1 to 12 representing the months the mushroom fruits
  final List<int> fruitingMonths;

  static const List<String> _monthNames = [
    'Gen',
    'Feb',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Oct',
    'Nov',
    'Des'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Temporada',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(12, (index) {
            final monthNumber = index + 1;
            final isActive = fruitingMonths.contains(monthNumber);

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 11 ? 2.0 : 0.0),
                height: 32,
                decoration: BoxDecoration(
                  color: isActive
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    _monthNames[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive
                          ? Theme.of(context).colorScheme.onSecondary
                          : Colors.white54,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
