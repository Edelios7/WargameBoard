import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/back_link.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/catalog_provider.dart';
import '../widgets/datasheet_detail_panel.dart';

class DatasheetFullPage extends ConsumerWidget {
  final String datasheetId;

  const DatasheetFullPage({super.key, required this.datasheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final detailAsync = ref.watch(datasheetByIdProvider(datasheetId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
            child: BackLink(
              label: l10n.commonBack,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: DatasheetDetailPanel(
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
