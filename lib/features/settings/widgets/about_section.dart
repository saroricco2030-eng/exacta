/// About section - privacy policy, terms, version
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:exacta/core/extensions/build_context_ext.dart';
import 'package:exacta/core/theme/app_theme.dart';
import 'package:exacta/l10n/generated/app_localizations.dart';
import 'package:exacta/features/settings/widgets/settings_tile.dart';
import 'package:exacta/core/transitions.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({
    super.key,
    required this.l,
  });

  final AppLocalizations l;

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  String _versionText = '...';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _versionText = '${info.version} (${info.buildNumber})';
      });
    } catch (e) {
      if (mounted) setState(() => _versionText = '—');
    }
  }

  void _showLegalPage(BuildContext context, String title, String body) {
    Navigator.of(context).push(
      SlideRightRoute(page: LegalScreen(title: title, body: body)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(icon: LucideIcons.info, label: l.settingsAbout),
        const SizedBox(height: 12),

        SettingsTile(
          onTap: () => _showLegalPage(context, l.privacyTitle, l.privacyBody),
          icon: LucideIcons.shieldCheck,
          label: l.settingsPrivacyPolicy,
          trailing: Icon(LucideIcons.chevronRight,
              size: 16, color: context.text3),
        ),
        const SizedBox(height: 8),

        SettingsTile(
          onTap: () => _showLegalPage(context, l.termsTitle, l.termsBody),
          icon: LucideIcons.fileText,
          label: l.settingsTerms,
          trailing: Icon(LucideIcons.chevronRight,
              size: 16, color: context.text3),
        ),
        const SizedBox(height: 8),

        SettingsTile(
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('onboarding_done', false);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.onboardingReplay)),
            );
          },
          icon: LucideIcons.bookOpen,
          label: l.onboardingReplay,
          trailing: Icon(LucideIcons.chevronRight,
              size: 16, color: context.text3),
        ),
        const SizedBox(height: 8),

        SettingsTile(
          icon: LucideIcons.tag,
          label: l.settingsVersion,
          trailing: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Text(
              _versionText,
              key: ValueKey(_versionText),
              style: TextStyle(
                fontSize: 13,
                fontFamily: AppTheme.monoFontFamily, // version — custom mono
                color: context.text3,
              ),
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
