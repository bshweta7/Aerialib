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

final class UpdatePoseSuccess extends PosesState { // Assuming your states extend PosesState
  final PoseModel poseModel;
  const UpdatePoseSuccess(this.poseModel);

  @override
  List<Object?> get props => [poseModel]; // If you are using equatable, add this.
}