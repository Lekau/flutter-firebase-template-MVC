import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final functionsServiceProvider = Provider<FunctionsService>((ref) {
  return FunctionsService();
});

class FunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Singleton pattern
  static final FunctionsService _instance = FunctionsService._internal();
  factory FunctionsService() => _instance;
  FunctionsService._internal();

  Future<dynamic> callFunction(String functionName,
      {Map<String, dynamic>? data}) async {
    try {
      final result = await _functions.httpsCallable(functionName).call(data);
      return result.data;
    } catch (e) {
      throw Exception('Failed to call function $functionName: $e');
    }
  }
}
