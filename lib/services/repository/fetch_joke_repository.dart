import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platter/services/models/joke_model.dart';

class FetchJokeRepositoryImpl implements FetchJokeRepository {
  FetchJokeRepositoryImpl(this.dio);
  final Dio dio;

  @override
  Future<Joke> fetchJoke() async {
    debugPrint('fetching joke2');

    final response = await dio.get(
      'https://official-joke-api.appspot.com/random_joke',
    );
    debugPrint('fetching joke3 : $response');

    final joke = Joke.fromJson(response.data);
    debugPrint('fetching joke4 : $joke');

    return joke;
  }
}

abstract class FetchJokeRepository {
  Future<Joke> fetchJoke();
}
