import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/back_link.dart';
import '../../../core/widgets/retry_error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/catalog_provider.dart';
import '../../../providers/xp_provider.dart';
import '../widgets/datasheet_detail_panel.dart';

class DatasheetFullPage extends ConsumerStatefulWidget {
  final String datasheetId;

  const DatasheetFullPage({super.key, required this.datasheetId});

  @override
  ConsumerState<DatasheetFullPage> createState() => _DatasheetFullPageState();
}

class _DatasheetFullPageState extends ConsumerState<DatasheetFullPage> {
  @override
  void initState() {
    super.initState();
    // Une seule fois par ouverture de la page (pas à chaque rebuild, ex.
    // changement de thème) — sinon "Archiviste" (lib/services/xp_service
    // .dart:awardDatasheetViewed) resterait du code mort jamais appelé.
    ref.read(xpServiceProvider).awardDatasheetViewed(widget.datasheetId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final datasheetId = widget.datasheetId;
    final detailAsync = ref.watch(datasheetByIdProvider(datasheetId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackLink(
                  label: l10n.commonBack,
                  onTap: () => Navigator.of(context).pop(),
                ),
                // Le nom de faction n'est connu qu'une fois la fiche
                // chargée — pas de fil d'Ariane tant que detailAsync.value
                // est null (chargement ou erreur), le BackLink seul reste
                // suffisant à ce moment-là.
                if (detailAsync.value != null) ...[
                  const SizedBox(height: 6),
                  _Breadcrumb(
                    segments: [
                      l10n.navCatalog,
                      detailAsync.value!.factionName,
                      detailAsync.value!.name,
                    ],
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                // Sans ce branchement, une erreur de chargement (id
                // périmé après un ré-import, incident DB...) affichait
                // silencieusement "Sélectionnez une fiche" — un message
                // qui laisse croire qu'aucune fiche n'a été demandée,
                // plutôt que de proposer de réessayer.
                child: detailAsync.hasError
                    ? RetryErrorState(
                        onRetry: () =>
                            ref.invalidate(datasheetByIdProvider(datasheetId)),
                      )
                    : DatasheetDetailPanel(
                        datasheet: detailAsync.value,
                        loading: detailAsync.isLoading,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fil d'Ariane purement informatif (les segments ne sont pas cliquables
/// individuellement — [BackLink] au-dessus couvre déjà la navigation) :
/// situe la fiche dans le Catalogue/la faction sans avoir à deviner d'où
/// on vient.
class _Breadcrumb extends StatelessWidget {
  final List<String> segments;

  const _Breadcrumb({required this.segments});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < segments.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                '›',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          Text(
            segments[i],
            style: i == segments.length - 1
                ? AppTextStyles.caption.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  )
                : AppTextStyles.caption,
          ),
        ],
      ],
    );
  }
}
