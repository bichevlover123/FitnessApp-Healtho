import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:intl/intl.dart';

/// Weight monitoring screen for tracking user weight over time
/// This screen allows users to:
/// - Enter and save new weight measurements
/// - View their weight history in a line chart
/// - See their current weight
/// The data is stored in Firestore and displayed in a visually appealing chart.
class WeightMonitorScreen extends StatefulWidget {
  const WeightMonitorScreen({super.key});

  @override
  State<WeightMonitorScreen> createState() => _WeightMonitorScreenState();
}

class _WeightMonitorScreenState extends State<WeightMonitorScreen> {
  /// Controller for weight input field
  final TextEditingController _weightController = TextEditingController();

  /// List to store weight entries fetched from Firestore
  List<WeightEntry> _weightEntries = [];

  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// Current weight of the user
  double _currentWeight = 0;

  @override
  void initState() {
    super.initState();
    // Fetch initial weight data when the screen is initialized
    _fetchInitialData();
  }

  /// Fetch initial weight data from Firestore
  Future<void> _fetchInitialData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Get user document
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    try {
      // Extract current weight from user document
      final weightString = userDoc.get('weight')?.toString() ?? '0';
      final cleanWeight = weightString.replaceAll(RegExp(r'[^0-9.]'), '');
      _currentWeight = double.tryParse(cleanWeight) ?? 0;
    } catch (e) {
      _currentWeight = 0;
    }

    // Get weight entries
    final weightEntriesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('weightEntries')
        .get();

    // If no entries exist but current weight is available, create an initial entry
    if (weightEntriesSnapshot.docs.isEmpty && _currentWeight > 0) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('weightEntries')
          .add({
        'weight': _currentWeight,
        'timestamp': Timestamp.now(),
      });
    }

    // Fetch and display weight entries
    await _fetchWeightEntries();
  }

  /// Fetch weight entries from Firestore
  Future<void> _fetchWeightEntries() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Get weight entries sorted by timestamp
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('weightEntries')
        .orderBy('timestamp', descending: false)
        .get();

    setState(() {
      // Convert snapshot documents to WeightEntry objects
      _weightEntries = snapshot.docs.map((doc) {
        return WeightEntry(
          weight: doc['weight'].toDouble(),
          timestamp: doc['timestamp'].toDate(),
        );
      }).toList();

      // Update current weight if entries exist
      if (_weightEntries.isNotEmpty) {
        _currentWeight = _weightEntries.last.weight;
      }
    });
  }

  /// Save new weight entry to Firestore
  Future<void> _saveWeight() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Parse weight from input
    final weight = double.tryParse(_weightController.text);
    if (weight == null) return;

    try {
      // Add new weight entry
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('weightEntries')
          .add({
        'weight': weight,
        'timestamp': Timestamp.now(),
      });

      // Update user document with current weight
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'weight': '$weight KG'});

      // Clear input field and refresh data
      _weightController.clear();
      await _fetchWeightEntries();
    } catch (e) {
      // Show error message if save fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving weight: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Weight input form
            _buildInputForm(),
            const SizedBox(height: 30),
            // Weight chart or empty state
            Expanded(
              child: _weightEntries.isEmpty
                  ? _buildEmptyState()
                  : _buildWeightChart(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty state widget when no weight data is available
  Widget _buildEmptyState() {
    if (_currentWeight > 0) {
      // Show chart with current weight if available
      return _buildWeightChart([
        WeightEntry(
            weight: _currentWeight,
            timestamp: DateTime.now()
        )
      ]);
    }
    // Show message prompting user to start tracking
    return const Center(
      child: Text('No weight data available. Start tracking!'),
    );
  }

  /// Build weight chart widget
  Widget _buildWeightChart([List<WeightEntry>? customEntries]) {
    final displayEntries = customEntries ?? _weightEntries;

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 5,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: _bottomTitles(displayEntries),
            ),
            leftTitles: AxisTitles(
              sideTitles: _leftTitles(),
            ),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: displayEntries
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(
                entry.key.toDouble(),
                entry.value.weight,
              ))
                  .toList(),
              isCurved: true,
              color: TColor.secondary,
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    TColor.secondary.withOpacity(0.3),
                    TColor.secondary.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: const FlDotData(show: true),
            ),
          ],
          minX: 0,
          maxX: displayEntries.length > 1
              ? (displayEntries.length - 1).toDouble()
              : 1,
          minY: _getMinWeight(displayEntries),
          maxY: _getMaxWeight(displayEntries),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (context) => Colors.white,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final date = displayEntries[spot.x.toInt()].timestamp;
                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(1)} KG\n${DateFormat('MMM dd').format(date)}',
                    TextStyle(
                      color: TColor.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Calculate minimum weight for chart Y-axis
  double _getMinWeight(List<WeightEntry> entries) {
    if (entries.isEmpty) return 0;
    final min = entries.map((e) => e.weight).reduce((a, b) => a < b ? a : b);
    return (min - 5).clamp(0, double.infinity);
  }

  /// Calculate maximum weight for chart Y-axis
  double _getMaxWeight(List<WeightEntry> entries) {
    if (entries.isEmpty) return 100;
    final max = entries.map((e) => e.weight).reduce((a, b) => a > b ? a : b);
    return max + 5;
  }

  /// Configure bottom titles for chart
  SideTitles _bottomTitles(List<WeightEntry> entries) => SideTitles(
    showTitles: true,
    interval: 1,
    reservedSize: 35,
    getTitlesWidget: (value, meta) {
      if (value.toInt() >= entries.length) return const SizedBox();
      final date = entries[value.toInt()].timestamp;
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          DateFormat('MMM dd').format(date),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      );
    },
  );

  /// Configure left titles for chart
  SideTitles _leftTitles() => SideTitles(
    showTitles: true,
    interval: 5,
    reservedSize: 40,
    getTitlesWidget: (value, meta) {
      return Text(
        '${value.toInt()} KG',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      );
    },
  );

  /// Build weight input form
  Widget _buildInputForm() {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Weight (KG)',
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter weight';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _saveWeight,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.secondary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data model for weight entries
class WeightEntry {
  final double weight;
  final DateTime timestamp;

  WeightEntry({required this.weight, required this.timestamp});
}