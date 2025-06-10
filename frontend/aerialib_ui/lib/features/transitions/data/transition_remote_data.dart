import 'dart:convert';
import 'dart:developer';

import 'package:frontend/features/transitions/data/transition_model.dart';
import 'package:frontend/core/services/http_service.dart';

class TransitionRemoteDataSource {
  final HttpService httpService;

  TransitionRemoteDataSource({required this.httpService});

  /// Create and return TransitionModel
  Future<TransitionModel> createTransition({
    required TransitionModel transition,
    required String token,
  }) async {
    try {
      final response = await httpService.post(
        path: "/transitions",
        token: token,
        body: transition.toMapRemote(),
      );

      final createdTransition = TransitionModel.fromJson(response.body);
      return createdTransition.copyWith(isSynced: 1);

    } catch (e) {
      // Fallback: return original transition marked as not synced
      return transition.copyWith(isSynced: 0);
    }
  }

  /// Get all transitions from remote database
  Future<List<TransitionModel>> getRemoteTransitions({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/transitions",
      token: token,
    );
    // final decoded = jsonDecode(response.body);
    // log('[TransitionRemoteDataSource] Raw response: $decoded');

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => TransitionModel.fromMap(e).copyWith(isSynced: 1)).toList();
  }

  /// Sync transitions from local to remote
  Future<bool> syncTransitions({
    required String token,
    required List<TransitionModel> transitions,
  }) async {
    final transitionListInMap = transitions.map((transition) => transition.toMapRemote()).toList();

    log('[TransitionRemoteDataSource] Syncing ${transitionListInMap.length} transitions...');
    // for (final map in transitionListInMap) {
    //   log('[TransitionRemoteDataSource] Syncing transition slug: ${map['slug']}');
    // }

    final response = await httpService.post(
      path: "/transitions/sync",
      token: token,
      body: transitionListInMap,
    );

    if (response.statusCode == 201) {
      log('[TransitionRemoteDataSource] Sync successful');
      return true;
    } else {
      log('[TransitionRemoteDataSource] Sync failed: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  /// Delete a transition
  Future<void> deleteTransition({
    required String transitionId,
    required String token,
  }) async {
    final response = await httpService.delete(
      path: "/transitions/delete/$transitionId",
      token: token,
    );

    if (response.statusCode != 200) {
      log("[TransitionRemoteDataSource] Failed to delete transition, status ${response.statusCode}");
      log("[TransitionRemoteDataSource] Body: ${response.body}");
      throw Exception("[TransitionRemoteDataSource] Failed to delete transition remotely");
    }

    log("[TransitionRemoteDataSource] Transition deleted successfully: $transitionId");
  }
}
