part of 'flow_pose_cubit.dart';


sealed class FlowPoseState {
  const FlowPoseState();
}
final class FlowPoseInitial extends FlowPoseState {}

final class FlowPoseLoading extends FlowPoseState {}

final class FlowPoseError extends FlowPoseState {
  final String error;
  FlowPoseError(this.error);
}

final class AddNewFlowPoseSuccess extends FlowPoseState {
  final FlowPoseModel flowPoseModel;
  const AddNewFlowPoseSuccess(this.flowPoseModel);
}

final class GetFlowPosesSuccess extends FlowPoseState {
  final List<FlowPoseModel> flowPoses;
  const GetFlowPosesSuccess(this.flowPoses);
}

final class UpdateFlowPoseSuccess extends FlowPoseState {
  final FlowPoseModel flowPoseModel;
  const UpdateFlowPoseSuccess(this.flowPoseModel);

  @override
  List<Object?> get props => [flowPoseModel]; // If you are using equatable, add this.
}