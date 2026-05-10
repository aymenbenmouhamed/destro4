import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../services/supabase_service.dart';
import './widgets/login_credentials_box_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/login_role_toggle_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isAdmin = true;
  bool _isLoading = false;

  late AnimationController _logoController;
  late AnimationController _formController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _formSlide;
  late Animation<double> _formOpacity;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _formController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    _formSlide =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
        );
    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOut),
    );

    Future.microtask(() async {
      await _logoController.forward();
      await Future.delayed(const Duration(milliseconds: 100));
      _formController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _formController.dispose();
    super.dispose();
  }

  void _onRoleChanged(bool isAdmin) {
    setState(() => _isAdmin = isAdmin);
  }

  // ✅ Real Supabase authentication
  void _onLogin(String email, String password) async {
    setState(() => _isLoading = true);

    try {
      // 1. Sign in with Supabase Auth
      final response = await SupabaseService.login(email, password);
      final user = response.user;

      if (user == null) throw Exception('Utilisateur introuvable');

      // 2. Get role from users table
      final role = await SupabaseService.getUserRole(user.id);

      if (!mounted) return;

      // 3. Navigate based on role
      if (role == 'admin') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.adminDashboardScreen,
          (r) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.sellerVisitScreen,
          (r) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;

      String message = 'Identifiants invalides. Veuillez réessayer.';
      if (e.toString().contains('Invalid login credentials')) {
        message = 'Email ou mot de passe incorrect.';
      } else if (e.toString().contains('network') ||
          e.toString().contains('SocketException')) {
        message = 'Erreur réseau. Vérifiez votre connexion.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.ibmPlexSans(fontSize: 14),
          ),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1565C0),
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 0 : 24,
                vertical: 32,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 480 : double.infinity,
                ),
                child: isTablet
                    ? _buildTabletCard(context)
                    : _buildPhoneLayout(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogo(),
          const SizedBox(height: 32),
          LoginRoleToggleWidget(isAdmin: _isAdmin, onChanged: _onRoleChanged),
          const SizedBox(height: 28),
          LoginFormWidget(
            isAdmin: _isAdmin,
            isLoading: _isLoading,
            onLogin: _onLogin,
          ),
          const SizedBox(height: 24),
          LoginCredentialsBoxWidget(isAdmin: _isAdmin),
        ],
      ),
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return Column(
      children: [
        ScaleTransition(
          scale: _logoScale,
          child: FadeTransition(opacity: _logoOpacity, child: _buildLogo()),
        ),
        const SizedBox(height: 40),
        SlideTransition(
          position: _formSlide,
          child: FadeTransition(
            opacity: _formOpacity,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(38),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoginRoleToggleWidget(
                    isAdmin: _isAdmin,
                    onChanged: _onRoleChanged,
                  ),
                  const SizedBox(height: 28),
                  LoginFormWidget(
                    isAdmin: _isAdmin,
                    isLoading: _isLoading,
                    onLogin: _onLogin,
                  ),
                  const SizedBox(height: 24),
                  LoginCredentialsBoxWidget(isAdmin: _isAdmin),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'DistriPro v2.4 • Tunis, Tunisie',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 12,
            color: Colors.white.withAlpha(153),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withAlpha(77),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.local_shipping_rounded,
            color: AppTheme.primary,
            size: 44,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'DistriPro',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Gestion de distribution professionnelle',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 13,
            color: Colors.white.withAlpha(204),
          ),
        ),
      ],
    );
  }
}
