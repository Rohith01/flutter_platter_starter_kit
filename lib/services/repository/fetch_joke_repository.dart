import 'package:dio/dio.dart';
import 'package:flutter_platter/services/models/joke_model.dart';

class FetchJokeRepositoryImpl implements FetchJokeRepository {
  FetchJokeRepositoryImpl(this.dio);
  final Dio dio;

  @override
  Future<Joke> fetchJoke() async {
    final response = await dio.get(
      'https://official-joke-api.appspot.com/random_joke',
    );

    final joke = Joke.fromJson(response.data);

    return joke;
  }
}

abstract class FetchJokeRepository {
  Future<Joke> fetchJoke();
}
