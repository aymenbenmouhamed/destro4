import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class DashboardAiInsightWidget extends StatefulWidget {
  const DashboardAiInsightWidget({super.key});

  @override
  State<DashboardAiInsightWidget> createState() =>
      _DashboardAiInsightWidgetState();
}

class _DashboardAiInsightWidgetState extends State<DashboardAiInsightWidget> {
  final _chatController = TextEditingController();
  bool _showChat = false;
  String? _aiResponse;
  bool _isTyping = false;

  // TODO: Replace with real AI API (OpenAI/Gemini) for production
  final List<Map<String, dynamic>> _insights = [
    {
      'icon': Icons.trending_up_rounded,
      'color': AppTheme.success,
      'text': 'Huile Végétale 5L : +34% chez Kamel Trabelsi cette semaine',
    },
    {
      'icon': Icons.schedule_rounded,
      'color': AppTheme.primary,
      'text':
          'Riadh Chaabane doit être visité — dernier passage il y a 2 jours',
    },
    {
      'icon': Icons.warning_amber_rounded,
      'color': AppTheme.warning,
      'text': 'Noureddine Bou Ali : 1 980 TND impayés depuis 5 jours',
    },
  ];

  void _askAI() async {
    if (_chatController.text.trim().isEmpty) return;
    final query = _chatController.text.trim();
    _chatController.clear();
    setState(() => _isTyping = true);

    // TODO: Replace with real AI API call for production
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    String response;
    if (query.toLowerCase().contains('doit') ||
        query.toLowerCase().contains('owe')) {
      response =
          'Riadh Chaabane doit 1 540 TND. Noureddine Bou Ali doit 1 980 TND. Total général: 4 820 TND.';
    } else if (query.toLowerCase().contains('vend') ||
        query.toLowerCase().contains('sell')) {
      response =
          'Produit le plus vendu: Huile Végétale 5L (48 unités/semaine). Meilleur vendeur: Kamel Trabelsi (3 200 TND).';
    } else {
      response =
          'Analyse en cours... Conseil: planifiez une visite chez Noureddine Bou Ali pour recouvrer 1 980 TND.';
    }

    setState(() {
      _aiResponse = response;
      _isTyping = false;
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(77),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analyse IA DistriPro',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Insights de cette semaine',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        color: Colors.white.withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _showChat = !_showChat),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _showChat ? Icons.close_rounded : Icons.chat_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _showChat ? 'Fermer' : 'Demander',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!_showChat) ...[
            ..._insights.map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(38),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(
                        insight['icon'] as IconData,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        insight['text'] as String,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 13,
                          color: Colors.white.withAlpha(230),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            if (_aiResponse != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(38),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _aiResponse!,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 13,
                          color: Colors.white,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Analyse en cours...',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 12,
                        color: Colors.white.withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ex: Combien doit Kamel Trabelsi?',
                      hintStyle: GoogleFonts.ibmPlexSans(
                        fontSize: 13,
                        color: Colors.white.withAlpha(128),
                      ),
                      filled: true,
                      fillColor: Colors.white.withAlpha(38),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _askAI(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _askAI,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      size: 20,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
