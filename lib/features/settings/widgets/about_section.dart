/// About section - privacy policy, terms, version
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/theme/app_theme.dart';
import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/features/settings/widgets/settings_tile.dart';
import 'package:exacta/core/transitions.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
    required this.l,
  });

  final AppLocalizations l;

  void _showLegalPage(BuildContext context, String title, String body) {
    Navigator.of(context).push(
      SlideRightRoute(page: LegalScreen(title: title, body: body)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(icon: LucideIcons.info, label: l.settingsAbout),
        const SizedBox(height: 12),

        GestureDetector(
          onTap: () { HapticFeedback.lightImpact(); _showLegalPage(context, l.privacyTitle, l.privacyBody); },
          child: SettingsTile(
            icon: LucideIcons.shieldCheck,
            label: l.settingsPrivacyPolicy,
            trailing: Icon(LucideIcons.chevronRight,
                size: 16, color: context.text3),
          ),
        ),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: () { HapticFeedback.lightImpact(); _showLegalPage(context, l.termsTitle, l.termsBody); },
          child: SettingsTile(
            icon: LucideIcons.fileText,
            label: l.settingsTerms,
            trailing: Icon(LucideIcons.chevronRight,
                size: 16, color: context.text3),
          ),
        ),
        const SizedBox(height: 8),

        SettingsTile(
          icon: LucideIcons.tag,
          label: l.settingsVersion,
          trailing: Text(
            '1.0.0',
            style: TextStyle(
              fontSize: 13,
              fontFamily: AppTheme.monoFontFamily, // version — custom mono
              color: context.text3,
            ),
          ),
        ),
      ],
    );
  }
}

// ── 법적 고지 화면 ────────────────────────────────────────────
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: context.text1),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: context.text1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Text(
          body,
          style: TextStyle(
            fontSize: 14,
            height: 1.8,
            color: context.text2,
          ),
        ),
      ),
    );
  }
}
