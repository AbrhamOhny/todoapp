import 'package:flutter/material.dart';
import 'package:todoapp/controller/pages.dart';
import 'package:todoapp/main.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final LineChartData lineChartData = LineChartData(
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: true),
      backgroundColor: Theme.of(context).cardTheme.color,
      lineBarsData: [
        LineChartBarData(
          spots: currentUser.tasks.chartSpots,
          color: Theme.of(context).colorScheme.primary,
          barWidth: 2,
          isCurved: true,
          isStrokeCapRound: true,
          preventCurveOverShooting: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5),
                Theme.of(context).colorScheme.surface.withValues(alpha: 0),
              ],
              stops: [0.8, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          dotData: FlDotData(show: true),
        ),
      ],
    );

    return Padding(
      padding: pagesPadding,
      child: Column(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Welcome, ${currentUser.username}!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Card(
            child: Padding(
              padding: pagesPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Wrap(
                    spacing: 5,
                    children: [
                      Icon(Icons.table_chart),
                      Text("Tasks Statistics", style: cardTitleStyle),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Padding(
                        padding: itemsPadding,
                        child: Text(
                          'Active Tasks (${currentUser.tasks.activeTasks.length})',
                        ),
                      ),
                      Padding(
                        padding: itemsPadding,
                        child: Text(
                          'Completed Tasks (${currentUser.tasks.completedTasks.length})',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: pagesPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Wrap(
                    spacing: 5,
                    children: [
                      Icon(Icons.pie_chart),
                      Text("Charts", style: cardTitleStyle),
                    ],
                  ),
                  AspectRatio(
                    aspectRatio: 2.0,
                    child: LineChart(lineChartData),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
