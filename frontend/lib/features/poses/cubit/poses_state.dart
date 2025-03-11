part of 'poses_cubit.dart';

sealed class PosesState {
  const PosesState();
}
final class PoseInitial extends PosesState {}

final class PoseLoading extends PosesState {}

final class PoseError extends PosesState {
  final String error;
  PoseError(this.error);
}

final class AddNewPoseSuccess extends PosesState {
  final PoseModel poseModel;
  const AddNewPoseSuccess(this.poseModel);
}

final class GetPosesSuccess extends PosesState {
  final List<PoseModel> poses;
  const GetPosesSuccess(this.poses);
}