import 'package:equatable/equatable.dart';
import 'package:training_partner/core/resources/gpt/gpt_message.dart';

class GptState extends Equatable {
  const GptState();

  @override
  List<Object> get props => [];
}

class GptUninitializedState extends GptState {}

class GptResponseLoading extends GptState {}

class GptResponseLoaded extends GptState {
  final GptMessage message;

  const GptResponseLoaded({required this.message});

  @override
  List<Object> get props => [message];
}

class GptResponseError extends GptState {
  final String message;

  const GptResponseError({required this.message});

  @override
  List<Object> get props => [message];
}
