import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trivioso/screens/home_screen.dart';
import 'package:trivioso/screens/quiz_screen.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) {
        return const QuizScreen();
      },
    ),
  ],
);
