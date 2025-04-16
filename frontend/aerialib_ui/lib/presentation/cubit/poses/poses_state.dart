part of 'poses_cubit.dart';


abstract class PosesState extends Equatable {
  const PosesState();

  @override
  List<Object?> get props => [];
}

class PoseInitial extends PosesState {
  const PoseInitial();
}

class PoseLoading extends PosesState {
  const PoseLoading();
}

class GetPosesSuccess extends PosesState {
  final List<Pose> poses;
  const GetPosesSuccess(this.poses);

  @override
  List<Object?> get props => [poses];
}

class AddNewPoseSuccess extends PosesState {
  final Pose pose;
  const AddNewPoseSuccess(this.pose);

  @override
  List<Object?> get props => [pose];
}

class UpdatePoseSuccess extends PosesState {
  final Pose updatedPose;
  const UpdatePoseSuccess(this.updatedPose);

  @override
  List<Object?> get props => [updatedPose];
}

class PoseError extends PosesState {
  final String message;
  const PoseError(this.message);

  @override
  List<Object?> get props => [message];
}
