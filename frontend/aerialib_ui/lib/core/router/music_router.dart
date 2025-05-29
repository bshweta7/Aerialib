import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/domain/entities/music_entity.dart';
import 'package:frontend/presentation/cubit/music/music_cubit.dart';
import 'package:frontend/presentation/cubit/navigation/nav_history_cubit.dart';

import 'package:frontend/presentation/pages/music/music_library_page.dart';
// import 'package:frontend/presentation/pages/music/add_new_music_page.dart';
// import 'package:frontend/presentation/pages/music/music_view_page.dart';
// import 'package:frontend/presentation/pages/music/music_edit_page.dart';

List<GoRoute> musicRoutes = [
  /// Music Library Page
  GoRoute(
    path: '/music',
    name: 'music-library',
    builder: (context, state) {
      context.read<NavHistoryCubit>().push(
        state.uri.queryParameters['from'],
      );
      return const MusicLibraryPage();
    },
  ),

  // /// Add New Music Page
  // GoRoute(
  //   path: '/music/new',
  //   name: 'add-new-music',
  //   builder: (context, state) => const AddNewMusicPage(),
  // ),
  //
  // /// View Music Page
  // GoRoute(
  //   path: '/music/view/:musicId',
  //   name: 'music-view',
  //   builder: (context, state) {
  //     context.read<NavHistoryCubit>().push(
  //       state.uri.queryParameters['from'],
  //     );
  //
  //     final musicId = state.pathParameters['musicId']!;
  //     final musicState = context.read<MusicCubit>().state;
  //
  //     if (musicState is GetMusicSuccess) {
  //       final music = musicState.musicList.firstWhere(
  //             (m) => m.id == musicId,
  //         orElse: () => throw Exception('Music not found'),
  //       );
  //
  //       return MusicViewPage(music: music);
  //     }
  //
  //     log('[MusicRouter] $musicState');
  //     return const Scaffold(
  //       body: Center(child: CircularProgressIndicator()),
  //     );
  //   },
  // ),
  //
  // /// Edit Music Page
  // GoRoute(
  //   path: '/music/edit/:musicId',
  //   name: 'music-edit',
  //   builder: (context, state) {
  //     final music = state.extra as MusicEntity;
  //     return MusicEditPage(music: music);
  //   },
  // ),
];
