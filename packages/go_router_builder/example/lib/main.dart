// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'shared/data.dart';

part 'main.g.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  App({super.key});

  final LoginInfo loginInfo = LoginInfo();
  static const String title = 'GoRouter Example: Named Routes';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<LoginInfo>.value(
        value: loginInfo,
        child: MaterialApp.router(
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          routeInformationProvider: _router.routeInformationProvider,
          title: title,
          debugShowCheckedModeBanner: false,
        ),
      );

  late final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    routes: $appRoutes,
    navigatorKey: key,

    // redirect to the login page if the user is not logged in
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = loginInfo.loggedIn;

      // check just the subloc in case there are query parameters
      final String loginLoc = const LoginRoute().location;
      final bool goingToLogin = state.subloc == loginLoc;

      // the user is not logged in and not headed to /login, they need to login
      if (!loggedIn && !goingToLogin) {
        return LoginRoute(fromPage: state.subloc).location;
      }

      // the user is logged in and headed to /login, no need to login again
      if (loggedIn && goingToLogin) {
        return const HomeRoute().location;
      }

      // no need to redirect at all
      return null;
    },

    // changes on the listenable will cause the router to refresh it's route
    refreshListenable: loginInfo,
  );
}

const GlobalObjectKey<NavigatorState> key = GlobalObjectKey('navigator_key');

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedShellRoute<FamilyRoute>>[
    TypedShellRoute<FamilyRoute>(
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<FamilyIdRoute>(
          path: 'family/:fid',
          routes: <TypedGoRoute<PersonRoute>>[
            TypedGoRoute<PersonRoute>(
              path: 'person/:pid',
              routes: <TypedGoRoute<GoRouteData>>[
                TypedGoRoute<PersonDetailsRoute>(path: 'details/:details'),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class FamilyRoute extends ShellRouteData {
  const FamilyRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = GlobalKey();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return FamilyScreen(child: navigator);
  }
}

@TypedGoRoute<LoginRoute>(
  path: '/login',
)
class LoginRoute extends GoRouteData {
  const LoginRoute({this.fromPage});

  final String? fromPage;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      LoginScreen(from: fromPage);
}

class FamilyIdRoute extends GoRouteData {
  const FamilyIdRoute(this.fid);

  final String fid;

  @override
  Widget build(BuildContext context, GoRouterState state) => FamilyIdScreen(
        family: familyById(fid),
      );
}

class PersonRoute extends GoRouteData {
  const PersonRoute(this.fid, this.pid);

  final String fid;
  final int pid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final Family family = familyById(fid);
    final Person person = family.person(pid);
    return PersonScreen(family: family, person: person);
  }
}

class PersonDetailsRoute extends GoRouteData {
  const PersonDetailsRoute(this.fid, this.pid, this.details, {this.$extra});

  final String fid;
  final int pid;
  final PersonDetails details;
  final int? $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final Family family = familyById(fid);
    final Person person = family.person(pid);

    return MaterialPage<Object>(
      fullscreenDialog: true,
      key: state.pageKey,
      child: PersonDetailsPage(
        family: family,
        person: person,
        detailsKey: details,
        extra: $extra,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginInfo info = context.read<LoginInfo>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(App.title),
        centerTitle: true,
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => const PersonRoute('f1', 1).push(context),
            child: const Text('Push a route'),
          ),
          IconButton(
            onPressed: info.logout,
            tooltip: 'Logout: ${info.userName}',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          for (final Family f in familyData)
            ListTile(
              title: Text(f.name),
              onTap: () => FamilyIdRoute(f.id).go(context),
            )
        ],
      ),
    );
  }
}

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      );
}

class FamilyIdScreen extends StatelessWidget {
  const FamilyIdScreen({required this.family, super.key});

  final Family family;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(family.name)),
        body: ListView(
          children: <Widget>[
            for (final Person p in family.people)
              ListTile(
                title: Text(p.name),
                onTap: () => PersonRoute(family.id, p.id).go(context),
              ),
          ],
        ),
      );
}

class PersonScreen extends StatelessWidget {
  const PersonScreen({required this.family, required this.person, super.key});

  final Family family;
  final Person person;

  static int _extraClickCount = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(person.name)),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                  '${person.name} ${family.name} is ${person.age} years old'),
            ),
            for (MapEntry<PersonDetails, String> entry
                in person.details.entries)
              ListTile(
                title: Text(
                  '${entry.key.name} - ${entry.value}',
                ),
                trailing: OutlinedButton(
                  onPressed: () => PersonDetailsRoute(
                    family.id,
                    person.id,
                    entry.key,
                    $extra: ++_extraClickCount,
                  ).go(context),
                  child: const Text('With extra...'),
                ),
                onTap: () => PersonDetailsRoute(family.id, person.id, entry.key)
                    .go(context),
              )
          ],
        ),
      );
}

class PersonDetailsPage extends StatelessWidget {
  const PersonDetailsPage({
    required this.family,
    required this.person,
    required this.detailsKey,
    this.extra,
    super.key,
  });

  final Family family;
  final Person person;
  final PersonDetails detailsKey;
  final int? extra;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(person.name)),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                '${person.name} ${family.name}: '
                '$detailsKey - ${person.details[detailsKey]}',
              ),
            ),
            if (extra == null) const ListTile(title: Text('No extra click!')),
            if (extra != null)
              ListTile(title: Text('Extra click count: $extra')),
          ],
        ),
      );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({this.from, super.key});

  final String? from;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // log a user in, letting all the listeners know
                  context.read<LoginInfo>().login('test-user');

                  // if there's a deep link, go there
                  if (from != null) {
                    context.go(from!);
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
}
