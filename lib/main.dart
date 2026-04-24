import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nectracker/controllers/auth_controller.dart';
import 'package:nectracker/tela_inicial.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:app_links/app_links.dart';
import 'package:nectracker/tela_confirmar_email.dart';
import 'package:nectracker/tela_reset_senha.dart';
import 'package:nectracker/tela_apiarios.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AuthController.init();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint("Failed to get initial uri: \$e");
    }

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    }, onError: (err) {
      debugPrint("Failed to handle deep link: \$err");
    });
  }

  void _handleDeepLink(Uri uri) {
    if (navigatorKey.currentState == null) {
      // Se o Navigator ainda não estiver montado (cold start), esperamos um pouco
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleDeepLink(uri);
      });
      return;
    }

    switch (uri.path) {
      case '/reset-senha':
        final token = uri.queryParameters['token'];
        final userId = uri.queryParameters['userId'];
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => TelaResetSenha(
              token: token,
              userId: userId,
            ),
          ),
        );
        break;
      case '/confirmar-email':
        final token = uri.queryParameters['token'];
        final userId = uri.queryParameters['userId'];
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => TelaConfirmarEmail(
              token: token,
              userId: userId,
            ),
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Beepona',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: token.value != null ? const TelaApiarios() : const TelaInicial(),
    );
  }
}
