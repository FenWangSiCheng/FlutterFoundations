import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../injection/injection.dart';
import '../router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    return MaterialApp.router(
      title: appConfig.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: appRouter.router,
      builder: (context, child) {
        return _flavorBanner(
          child: child ?? const SizedBox(),
          show: kDebugMode,
        );
      },
    );
  }

  Widget _flavorBanner({
    required Widget child,
    bool show = true,
  }) =>
      show
          ? Banner(
              location: BannerLocation.topStart,
              message: appConfig.appName,
              color: Colors.green.withValues(alpha: 0.6),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  letterSpacing: 1.0),
              textDirection: TextDirection.ltr,
              child: child,
            )
          : Container(
              child: child,
            );
}
