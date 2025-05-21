import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the ID of the currently tracked car (if any)
final trackingCarIdProvider = StateProvider<String?>((ref) => null);
