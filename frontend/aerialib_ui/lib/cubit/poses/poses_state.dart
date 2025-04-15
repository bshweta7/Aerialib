part of 'poses_cubit.dart';


sealed class PosesState extends Equatable {
  const PosesState();

  @override
  List<Object?> get props => [];
}

final class PoseInitial extends PosesState {
  const PoseInitial();
}

final class PoseLoading extends PosesState {
  const PoseLoading();
}

final class AddNewPoseSuccess extends PosesState {
  final PoseModel poseModel;
  const AddNewPoseSuccess(this.poseModel);

  @override
  List<Object?> get props => [poseModel];
}

final class GetPosesSuccess extends PosesState {
  final List<PoseModel> poses;
  const GetPosesSuccess(this.poses);

  @override
  List<Object?> get props => [poses];
}

final class UpdatePoseSuccess extends PosesState {
  final PoseModel poseModel;
  const UpdatePoseSuccess(this.poseModel);

  @override
  List<Object?> get props => [poseModel];
}

final class PoseError extends PosesState {
  final String error;
  const PoseError(this.error);

  @override
  List<Object?> get props => [error];
}
