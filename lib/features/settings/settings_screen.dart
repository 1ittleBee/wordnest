import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/colors.dart';
import '../../data/local/hive_service.dart';

/// সেটিংস স্ক্রিন — Settings Screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = HiveService.isSoundEnabled;
  bool _musicEnabled = HiveService.isMusicEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'সেটিংস',
          style: GoogleFonts.hindSiliguri(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Audio Section
          _buildSectionHeader('শব্দ ও সংগীত'),
          _buildSwitchTile(
            title: 'শব্দ প্রভাব (SFX)',
            subtitle: 'ট্যাপ ও জয়ের শব্দ শুনুন',
            icon: Icons.volume_up_rounded,
            value: _soundEnabled,
            onChanged: (val) async {
              await HiveService.setSoundEnabled(val);
              setState(() => _soundEnabled = val);
            },
          ),
          _buildSwitchTile(
            title: 'আবহ সংগীত (BGM)',
            subtitle: 'শান্ত বাঁশি ও প্রকৃতির সুর',
            icon: Icons.music_note_rounded,
            value: _musicEnabled,
            onChanged: (val) async {
              await HiveService.setMusicEnabled(val);
              setState(() => _musicEnabled = val);
            },
          ),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader('তথ্য ও সহায়তা'),
          _buildInfoTile(
            title: 'ভাষা',
            subtitle: 'বাংলা (Bengali)',
            icon: Icons.language_rounded,
          ),
          _buildInfoTile(
            title: 'সংস্করণ',
            subtitle: '১.০.০ (WordNest)',
            icon: Icons.info_outline_rounded,
          ),
          _buildInfoTile(
            title: 'গোপনীয়তা নীতি',
            subtitle: 'শিশু ও পরিবারের জন্য সম্পূর্ণ নিরাপদ • বিস্তারিত দেখুন',
            icon: Icons.privacy_tip_outlined,
            onTap: () => _showPrivacyPolicyModal(context),
            showArrow: true,
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.security_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'গোপনীয়তা নীতি',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Text(
                          'Privacy Policy • Word Nest',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.goldenLight),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🛡️', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Word Nest খেলোয়াড়দের গোপনীয়তাকে সর্বোচ্চ অগ্রাধিকার দেয়। এটি শিশু ও পরিবারের জন্য ১০০% নিরাপদ।',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.earthyBrown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  _buildPolicyItem(
                    icon: '🚫',
                    title: 'ব্যক্তিগত তথ্য সংগ্রহ করা হয় না',
                    desc: 'অ্যাপটি ব্যবহারকারীর নাম, ইমেইল, মোবাইল নম্বর বা ভৌগোলিক অবস্থান নেয় না। কোনো অ্যাকাউন্ট বা রেজিস্ট্রেশনের প্রয়োজন নেই।',
                  ),
                  _buildPolicyItem(
                    icon: '💾',
                    title: '১০০% অফলাইন লোকাল প্রগ্রেস',
                    desc: 'আপনার অর্জিত কয়েন, স্টার এবং আনলক হওয়া লেভেলের তথ্য শুধুমাত্র আপনার ডিভাইসের মেমোরিতেই থাকে। কোনো সার্ভারে আপলোড হয় না।',
                  ),
                  _buildPolicyItem(
                    icon: '👶',
                    title: 'শিশু ও পরিবার-বান্ধব (COPPA)',
                    desc: 'অ্যাপটিতে কোনো অনুপযুক্ত বা ক্ষতিকর উপাদান নেই। এটি শিশুদের জন্য সম্পূর্ণ শিক্ষণীয় ও সুরক্ষিত।',
                  ),
                  _buildPolicyItem(
                    icon: '🔒',
                    title: 'কোনো বিপজ্জনক পারমিশন নেই',
                    desc: 'ক্যামেরা, মাইক্রোফোন, কন্টাক্ট বা গ্যালারির কোনো অনুমতি অ্যাপটির দরকার হয় না।',
                  ),
                  _buildPolicyItem(
                    icon: '✉️',
                    title: 'সহায়তা ও যোগাযোগ',
                    desc: 'যেকোনো প্রশ্ন বা মতামতের জন্য আমাদের ইমেইল করতে পারেন: support@wordnest.app',
                  ),

                  // Live Official Link Card
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.language_rounded, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'অফিসিয়াল লাইভ লিংক:',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () => _openPrivacyUrl(),
                          child: Text(
                            'https://1ittlebee.github.io/wordnest/',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 13,
                              color: Colors.blue.shade700,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openPrivacyUrl(),
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      label: Text(
                        'ব্রাউজারে খুলুন',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'বুঝেছি',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPrivacyUrl() async {
    const urlString = 'https://1ittlebee.github.io/wordnest/';
    final uri = Uri.parse(urlString);
    bool launched = false;

    try {
      launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      }
    } catch (_) {
      launched = false;
    }

    if (!launched && mounted) {
      await Clipboard.setData(const ClipboardData(text: urlString));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'লিংকটি কপি করা হয়েছে: $urlString',
            style: GoogleFonts.hindSiliguri(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          backgroundColor: AppColors.primaryDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Widget _buildPolicyItem({
    required String icon,
    required String title,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title,
        style: GoogleFonts.hindSiliguri(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.earthyBrownLight.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    bool showArrow = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.earthyBrownLight.withValues(alpha: 0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: AppColors.earthyBrown),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showArrow)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
