import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platter/presentation/bloc/fetch_joke_cubit.dart';
import 'package:flutter_platter/presentation/view/widgets/rounded_button_widget.dart';
import 'package:flutter_platter/services/models/joke_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class JokeScreen extends StatefulWidget {
  const JokeScreen({super.key});

  @override
  State<JokeScreen> createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  @override
  void initState() {
    BlocProvider.of<FetchJokeCubit>(context).fetchJoke();

    super.initState();
  }

  Joke joke = Joke(id: 0, type: '', setup: 'Loading...', punchline: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: BlocConsumer<FetchJokeCubit, FetchJokeState>(
        listener: (context, state) {
          if (state is FetchJokeLoaded) {
            joke = state.joke;
          }
          if (state is RevealJokeLoaded) {
            joke = state.joke;
          }
          if (state is FetchJokeError) {
            joke.setup = 'Something went wrong! Please try again later.';
          }
        },
        builder: (context, state) {
          return SizedBox(
            height: 640.h,
            width: 360.w,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: Lottie.network(
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint(error.toString());
                      return const SizedBox(height: 30);
                    },
                    'https://lottie.host/1993f724-beed-4979-8997-2a10189ad6a9/WORl1mGIHm.json',
                  ),
                ),
                Container(
                  height: 150,
                  width: 320,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.tertiary.withAlpha(100),
                        Theme.of(context).colorScheme.tertiary,
                      ],
                    ),
                  ),
                  child: Text(
                    joke.setup,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                if (state is RevealJokeLoaded)
                  Container(
                    height: 150,
                    width: 320,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.tertiary.withAlpha(100),
                          Theme.of(context).colorScheme.tertiary,
                        ],
                      ),
                    ),
                    child: Text(
                      joke.punchline,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                else
                  const SizedBox(height: 190),
                Visibility(
                  visible: state is FetchJokeLoaded,
                  child: RoundedButton(
                    title: 'Reveal',
                    width: 320,
                    onTap: () {
                      BlocProvider.of<FetchJokeCubit>(context).revealJoke(joke);
                    },
                    isLoading: false,
                  ),
                ),
                Visibility(
                  visible: state is RevealJokeLoaded || state is FetchJokeError,
                  child: RoundedButton(
                    width: 320,

                    title: state is RevealJokeLoaded ? 'Next Joke' : 'Retry',
                    onTap: () {
                      joke = Joke(
                        id: 0,
                        type: '',
                        setup: 'Loading...',
                        punchline: '',
                      );
                      BlocProvider.of<FetchJokeCubit>(context).fetchJoke();
                    },
                    isLoading: state is FetchJokeLoading,
                  ),
                ),
              ],
            ),
          );
          // return Center(child: Text('Loading'));
        },
      ),
    );
  }
}
