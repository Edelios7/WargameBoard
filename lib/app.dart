import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'shell/app_shell.dart';

class WargameBoardApp extends ConsumerWidget {
  const WargameBoardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeOverride = ref.watch(localeOverrideProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      onGenerateTitle: (context) =>
          AppLocalizations.of(context)!.appTitle,

      theme: AppTheme.darkTheme,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: AppLocalizations.supportedLocales,

      locale: localeOverride,

      home: const AppShell(),
    );
  }
}
