import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/customization_provider.dart';
import 'providers/locale_provider.dart';
import 'shell/app_shell.dart';

class WargameBoardApp extends ConsumerWidget {
  const WargameBoardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeOverride = ref.watch(localeOverrideProvider);
    // AppColors/AppWallpapers sont des statics mutables (voir leurs
    // commentaires) : les widgets déjà construits ne relisent jamais leur
    // nouvelle valeur tout seuls. Observer ce compteur ici et le refléter
    // dans une Key force Flutter à reconstruire tout l'arbre depuis zéro
    // à chaque changement de couleur d'accent ou de fond d'écran.
    final themeVersion = ref.watch(themeVersionProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,

      theme: AppTheme.darkTheme,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: AppLocalizations.supportedLocales,

      locale: localeOverride,

      home: KeyedSubtree(key: ValueKey(themeVersion), child: const AppShell()),
    );
  }
}
