// TODO set this up properly and import to main.dart
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend/data/services/http_service.dart';
//
// import 'package:frontend/data/datasources/poses/pose_local_data.dart';
// import 'package:frontend/data/datasources/poses/music_remote_data.dart';
// import 'package:frontend/data/datasources/user/user_local_data.dart';
// import 'package:frontend/data/datasources/user/user_remote_data.dart';
// import 'package:frontend/data/datasources/transitions/transition_local_data.dart';
// import 'package:frontend/data/datasources/flows/flow_local_data.dart';
// import 'package:frontend/data/datasources/flows/flow_remote_data.dart';
// import 'package:frontend/data/datasources/flow_poses/flow_pose_local_data.dart';
// import 'package:frontend/data/datasources/flow_poses/flow_pose_remote_data.dart';
// import 'package:frontend/data/datasources/media/media_local_data.dart';
// import 'package:frontend/data/datasources/media/media_remote_data.dart';
//
// import 'package:frontend/domain/repositories/pose_repository.dart';
// import 'package:frontend/domain/repositories/user_repository.dart';
// import 'package:frontend/domain/repositories/flow_pose_repository.dart';
// import 'package:frontend/domain/repositories/flow_repository.dart';
// import 'package:frontend/domain/repositories/media_repository.dart';
//
// import 'package:frontend/presentation/cubit/users/auth_cubit.dart';
// import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
// import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
// import 'package:frontend/presentation/cubit/media/media_cubit.dart';
//
// List<BlocProvider> getBlocProviders() {
//   final httpService = HttpService();
//
//   final poseRepo = PoseRepository(
//     localDataSource: PoseLocalDataSource(),
//     remoteDataSource: PoseRemoteDataSource(httpService: httpService),
//   );
//
//   final userRepo = UserRepository(
//     localDataSource: UserLocalDataSource(),
//     remoteDataSource: UserRemoteDataSource(httpService: httpService),
//   );
//
//   final flowRepo = FlowRepository(
//     localDataSource: FlowLocalDataSource(),
//     remoteDataSource: FlowRemoteDataSource(httpService: httpService),
//   );
//
//   final flowPoseRepo = FlowPoseRepository(
//     localDataSource: FlowPoseLocalDataSource(),
//     remoteDataSource: FlowPoseRemoteDataSource(httpService: httpService),
//     poseLocalDataSource: PoseLocalDataSource(),
//     transitionLocalDataSource: TransitionLocalDataSource(),
//   );
//
//   final mediaRepo = MediaRepository(
//     localDataSource: MediaLocalDataSource(),
//     remoteDataSource: MediaRemoteDataSource(httpService: httpService),
//   );
//
//   return [
//     BlocProvider(create: (_) => AuthCubit(userRepo)),
//     BlocProvider(create: (_) => PosesCubit(poseRepo)),
//     BlocProvider(create: (_) => MediaCubit(mediaRepo)),
//     BlocProvider(create: (_) => FlowsCubit(flowRepo, flowPoseRepo)),
//   ];
// }
