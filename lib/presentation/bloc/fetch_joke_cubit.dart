import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platter/services/models/joke_model.dart';
import 'package:flutter_platter/services/repository/fetch_joke_repository.dart';

part 'fetch_joke_state.dart';

class FetchJokeCubit extends Cubit<FetchJokeState> {
  FetchJokeCubit(this.fetchJokeRepository) : super(FetchJokeInitial());
  final FetchJokeRepository fetchJokeRepository;

  void fetchJoke() async {
    emit(FetchJokeLoading());
    try {
      debugPrint('fetching joke1');
      final data = await fetchJokeRepository.fetchJoke();
      debugPrint('fetching joke5 : $data');

      emit(FetchJokeLoaded(joke: data));
    } catch (e) {
      emit(FetchJokeError(message: e.toString()));
    }
  }

  void revealJoke(Joke joke) async {
    emit(RevealJokeLoaded(joke: joke));
  }
}
