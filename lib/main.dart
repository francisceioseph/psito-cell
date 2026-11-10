import 'dart:async';

import 'package:flutter/material.dart';

import 'package:psito_games_ui/psito_games_ui.dart';

import 'l10n/app_localizations.dart';
import 'src/ui/atoms/colors.dart';
import 'src/ui/pages/game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(GameSounds.shared.start());
  runApp(const PsitoCellApp());
}

class PsitoCellApp extends StatelessWidget {
  const PsitoCellApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [
      ...AppLocalizations.localizationsDelegates,
      GamesUiLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    theme: gameTheme(cellPalette),
    home: const GameScreen(),
  );
}
