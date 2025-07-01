part of 'transition_cubit.dart';

abstract class TransitionState extends Equatable {
  const TransitionState();

  @override
  List<Object?> get props => [];
}

class TransitionInitial extends TransitionState {
  const TransitionInitial();
}

class TransitionLoading extends TransitionState {
  const TransitionLoading();
}

class GetTransitionsSuccess extends TransitionState {
  final List<TransitionEntity> transitions;

  const GetTransitionsSuccess(this.transitions);

  @override
  List<Object?> get props => [transitions];
}

class AddNewTransitionSuccess extends TransitionState {
  final TransitionEntity transition;

  const AddNewTransitionSuccess(this.transition);

  @override
  List<Object?> get props => [transition];
}

class UpdateTransitionSuccess extends TransitionState {
  final TransitionEntity transition;

  const UpdateTransitionSuccess(this.transition);

  @override
  List<Object?> get props => [transition];
}

class TransitionError extends TransitionState {
  final String message;

  const TransitionError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteTransitionSuccess extends TransitionState {
  final String deletedTransitionId;
  const DeleteTransitionSuccess(this.deletedTransitionId);

  @override
  List<Object?> get props => [deletedTransitionId];
}
