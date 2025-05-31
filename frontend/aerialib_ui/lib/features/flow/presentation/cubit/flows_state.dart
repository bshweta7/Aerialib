part of 'flows_cubit.dart';

abstract class FlowsState extends Equatable {
  const FlowsState();

  @override
  List<Object?> get props => [];
}

/// Initial loading state
class FlowInitial extends FlowsState {
  const FlowInitial();
}

/// Generic loading state
class FlowLoading extends FlowsState {
  const FlowLoading();
}

/// Success when getting list of flows
class GetFlowsSuccess extends FlowsState {
  final List<FlowEntity> flows;
  const GetFlowsSuccess(this.flows);

  @override
  List<Object?> get props => [flows];
}

/// Success when creating a new flow
class AddNewFlowSuccess extends FlowsState {
  final FlowEntity flow;
  const AddNewFlowSuccess(this.flow);

  @override
  List<Object?> get props => [flow];
}

/// Success when updating an existing flow
class UpdateFlowSuccess extends FlowsState {
  final FlowEntity updatedFlow;
  const UpdateFlowSuccess(this.updatedFlow);

  @override
  List<Object?> get props => [updatedFlow];
}

/// Generic error state
class FlowError extends FlowsState {
  final String message;
  const FlowError(this.message);

  @override
  List<Object?> get props => [message];
}

class EditFlowState extends FlowsState {
  final FlowEntity flow;
  final bool isSaving;
  final bool saveSuccess;
  final String? errorMessage;
  final List<PoseEntity> availablePoses;

  const EditFlowState({
    required this.flow,
    this.isSaving = false,
    this.saveSuccess = false,
    this.errorMessage,
    this.availablePoses = const [],
  });

  EditFlowState copyWith({
    FlowEntity? flow,
    bool? isSaving,
    bool? saveSuccess,
    String? errorMessage,
    List<PoseEntity>? availablePoses,
  }) {
    return EditFlowState(
      flow: flow ?? this.flow,
      isSaving: isSaving ?? this.isSaving,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      availablePoses: availablePoses ?? this.availablePoses,
    );
  }

  @override
  List<Object?> get props => [flow, isSaving, saveSuccess, errorMessage, availablePoses];
}
