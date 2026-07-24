import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';

/// Lecture du PDF officiel directement dans l'appli (voir
/// [RulePdfSource]) — remplace l'ouverture externe par un vrai lecteur
/// intégré, page par page, avec numéro de page courant.
class RulePdfViewerPage extends StatefulWidget {
  final String title;
  final Uint8List bytes;

  const RulePdfViewerPage({
    super.key,
    required this.title,
    required this.bytes,
  });

  @override
  State<RulePdfViewerPage> createState() => _RulePdfViewerPageState();
}

class _RulePdfViewerPageState extends State<RulePdfViewerPage> {
  late final PdfController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PdfController(
      document: PdfDocument.openData(widget.bytes),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        title: Text(
          widget.title,
          style: AppTextStyles.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          PdfPageNumber(
            controller: _controller,
            builder: (context, loadingState, page, pagesCount) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  loadingState == PdfLoadingState.success
                      ? l10n.rulesPdfPageIndicator(page, pagesCount ?? page)
                      : '',
                  style: AppTextStyles.caption,
                ),
              ),
            ),
          ),
        ],
      ),
      body: PdfView(
        controller: _controller,
        scrollDirection: Axis.vertical,
        backgroundDecoration: const BoxDecoration(color: AppColors.background),
        onDocumentError: (error) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.rulesPdfLoadError)),
        ),
      ),
    );
  }
}
