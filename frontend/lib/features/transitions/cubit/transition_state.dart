part of 'transition_cubit.dart';

sealed class TransitionState {
  const TransitionState();
}
final class TransitionInitial extends TransitionState {}

final class TransitionLoading extends TransitionState {}

final class TransitionError extends TransitionState {
  final String error;
  TransitionError(this.error);
}

final class AddNewTransitionSuccess extends TransitionState {
  final TransitionModel transitionModel;
  const AddNewTransitionSuccess(this.transitionModel);
}

final class GetTransitionListSuccess extends TransitionState {
  final List<TransitionModel> transitionList;
  const GetTransitionListSuccess(this.transitionList);
}