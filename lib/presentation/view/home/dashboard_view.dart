import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platter/core/constants.dart';
import 'package:flutter_platter/core/snackbar_util.dart';
import 'package:flutter_platter/presentation/bloc/auth_bloc.dart';
import 'package:flutter_platter/presentation/bloc/firebase_analytics_cubit.dart';
import 'package:flutter_platter/presentation/bloc/manage_user_profile_cubit.dart';
import 'package:flutter_platter/presentation/bloc/theme_cubit.dart';
import 'package:flutter_platter/presentation/view/widgets/dashboard_tile.dart';
import 'package:flutter_platter/presentation/view/widgets/rounded_button_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(const IsUserLoggedIn());
    super.initState();
  }

  static const WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.dark_mode),
        WidgetState.any: Icon(Icons.light_mode),
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            debugPrint('Auth state is $state');
            if (state is UserLoggedOutState) {
              context.go('/login');
            } else if (state is AuthVerifiedOldUser ||
                state is AuthVerifiedNewUser) {
              BlocProvider.of<ManageUserProfileCubit>(context).getUserProfile();
            }
          },
          builder: (context, state) {
            return BlocConsumer<ManageUserProfileCubit, ManageUserProfileState>(
              listener: (context, state) {
                debugPrint('state is $state');
                if (state is ManageUserProfileError) {
                  showSnackBar(
                    context: context,
                    message:
                        'dashboard:: Something went wrong! Please try again later.',
                    showAction: false,
                  );
                }
              },
              builder: (context, state) {
                if (state is GetUserProfileLoaded) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              BlocProvider.of<FirebaseAnalyticsCubit>(
                                context,
                              ).addEvent(eventName: 'clicked_profile_icon');
                            },
                            child: const CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/image/avatar.jpg',
                              ),
                              radius: 50,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hello, ${state.userProfile.name}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          Text(
                            '${greetings[Random().nextInt(14)]}${DateFormat('EEEE').format(DateTime.now())}!!!',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 30),
                          InkWell(
                            onTap: () {
                              BlocProvider.of<FirebaseAnalyticsCubit>(
                                context,
                              ).addEvent(eventName: 'clicked_features_banner');
                              context.go('/features');
                            },
                            child: Container(
                              height: 150,
                              width: 320,
                              padding: const EdgeInsets.only(
                                left: 20,
                                top: 20,
                                right: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).colorScheme.primary,
                                image: const DecorationImage(
                                  image: AssetImage('assets/image/cover.png'),
                                  fit: BoxFit.cover,
                                  opacity: 0.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary.withAlpha(100),
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Flutter Platter',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'Kickstart your next Flutter app with confidence',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(),
                                  const SizedBox(),

                                  Center(
                                    child: Text(
                                      'Tap to know more',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DashBoardTile(
                                onTap: () {
                                  BlocProvider.of<FirebaseAnalyticsCubit>(
                                    context,
                                  ).addEvent(eventName: 'clicked_website_tile');
                                  context.go('/website');
                                },
                                title: 'Official Website',
                                leadingWidget: const Icon(Icons.web),
                              ),
                              DashBoardTile(
                                onTap: () {
                                  BlocProvider.of<FirebaseAnalyticsCubit>(
                                    context,
                                  ).addEvent(
                                    eventName: 'clicked_feedback_tile',
                                  );
                                },
                                title: 'Feedback',
                                leadingWidget: const Icon(Icons.feedback),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DashBoardTile(
                                onTap: () {
                                  BlocProvider.of<FirebaseAnalyticsCubit>(
                                    context,
                                  ).addEvent(eventName: 'clicked_joke_tile');
                                  context.go('/joke');
                                },
                                leadingWidget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hey,',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                    ),
                                    Text(
                                      'You want to hear a Joke?',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                              DashBoardTile(
                                onTap: () {
                                  BlocProvider.of<ThemeCubit>(
                                    context,
                                  ).toggleTheme();
                                },
                                title: 'Theme',
                                leadingWidget:
                                    BlocBuilder<ThemeCubit, ThemeState>(
                                      builder: (context, state) {
                                        if (state is IsDarkTheme) {
                                          return Switch(
                                            thumbIcon: thumbIcon,
                                            value: state.isDarkTheme,
                                            activeColor:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                            trackColor:
                                                WidgetStateProperty.resolveWith<
                                                  Color
                                                >((Set<WidgetState> states) {
                                                  return Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                      .withAlpha(100);
                                                }),
                                            thumbColor:
                                                WidgetStateProperty.resolveWith<
                                                  Color
                                                >((Set<WidgetState> states) {
                                                  return kPrimaryDark;
                                                }),
                                            onChanged: (bool value) {
                                              debugPrint(value.toString());
                                              BlocProvider.of<ThemeCubit>(
                                                context,
                                              ).toggleTheme();
                                            },
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          RoundedButton(
                            isLoading: state is AuthLoading,
                            title: 'Logout',
                            width: 320,
                            onTap: () {
                              BlocProvider.of<FirebaseAnalyticsCubit>(
                                context,
                              ).addEvent(eventName: 'clicked_logout_button');
                              BlocProvider.of<AuthBloc>(
                                context,
                              ).add(const OnLogOutEvent());
                            },
                            icon: const Icon(Icons.logout),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  );
                }
                return const Text('Loading...');
              },
            );
          },
        ),
      ),
    );
  }
}
