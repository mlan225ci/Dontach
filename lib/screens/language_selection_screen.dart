import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dontach/l10n/app_localizations.dart';

import '../theme/app_colors.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({
    super.key,
    required this.onSelected,
  });

  final ValueChanged<Locale> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.chooseLanguage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 32),
                  _LanguageButton(
                    flag: '🇫🇷',
                    label: l10n.languageFrench,
                    onTap: () => onSelected(const Locale('fr')),
                  ),
                  const SizedBox(height: 12),
                  _LanguageButton(
                    flag: '🇪🇸',
                    label: l10n.languageSpanish,
                    onTap: () => onSelected(const Locale('es')),
                  ),
                  const SizedBox(height: 12),
                  _LanguageButton(
                    flag: '🇬🇧',
                    label: l10n.languageEnglish,
                    onTap: () => onSelected(const Locale('en')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.flag,
    required this.label,
    required this.onTap,
  });

  final String flag;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: AppColors.brandGreenGradient(),
              boxShadow: AppColors.brandGreenShadow(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(flag, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
