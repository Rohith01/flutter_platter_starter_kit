part of 'fetch_joke_cubit.dart';

abstract class FetchJokeState extends Equatable {
  const FetchJokeState();

  @override
  List<Object> get props => [];
}

class FetchJokeInitial extends FetchJokeState {}

class FetchJokeLoading extends FetchJokeState {}

class FetchJokeLoaded extends FetchJokeState {
  const FetchJokeLoaded({required this.joke});
  final Joke joke;
  @override
  List<Object> get props => [joke];
}

class RevealJokeLoaded extends FetchJokeState {
  const RevealJokeLoaded({required this.joke});
  final Joke joke;
  @override
  List<Object> get props => [joke];
}

class FetchJokeError extends FetchJokeState {
  const FetchJokeError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
