part of 'flow_cubit.dart';

sealed class FlowsState {
  const FlowsState();
}
final class FlowInitial extends FlowsState {}

final class FlowLoading extends FlowsState {}

final class FlowError extends FlowsState {
  final String error;
  FlowError(this.error);
}

final class AddNewFlowSuccess extends FlowsState {
  final FlowModel flowModel;
  const AddNewFlowSuccess(this.flowModel);
}

final class GetFlowsSuccess extends FlowsState {
  final List<FlowModel> flows;
  const GetFlowsSuccess(this.flows);
}

final class UpdateFlowSuccess extends FlowsState { // Assuming your states extend FlowsState
  final FlowModel flowModel;
  const UpdateFlowSuccess(this.flowModel);

  @override
  List<Object?> get props => [flowModel]; // If you are using equatable, add this.
}