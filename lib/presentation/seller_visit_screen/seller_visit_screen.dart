import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../services/supabase_service.dart';
import './widgets/seller_visit_header_widget.dart';
import './widgets/seller_visit_invoice_sheet_widget.dart';
import './widgets/seller_visit_product_list_widget.dart';
import './widgets/seller_visit_summary_widget.dart';

class SellerVisitScreen extends StatefulWidget {
  const SellerVisitScreen({super.key});

  @override
  State<SellerVisitScreen> createState() => _SellerVisitScreenState();
}

class _SellerVisitScreenState extends State<SellerVisitScreen> {
  // ── Sellers & selected seller ──────────────────────────────
  List<Map<String, dynamic>> _sellers = [];
  Map<String, dynamic>? _selectedSeller;
  bool _loadingSellers = true;

  // ── Products loaded from Supabase ──────────────────────────
  late List<VisitProduct> _products = [];
  bool _loadingProducts = true;

  final Map<String, int> _newStockToGive = {};
  bool _visitCompleted = false;
  bool _savingVisit = false;

  @override
  void initState() {
    super.initState();
    _loadSellers();
    _loadProducts();
  }

  // ── Load data from Supabase ────────────────────────────────

  Future<void> _loadSellers() async {
    setState(() => _loadingSellers = true);
    try {
      final data = await SupabaseService.getSellers();
      setState(() {
        _sellers = data;
        if (_sellers.isNotEmpty) _selectedSeller = _sellers.first;
      });
    } catch (e) {
      _showSnackBar('Erreur chargement vendeurs: $e', AppTheme.error);
    } finally {
      setState(() => _loadingSellers = false);
    }
  }

  Future<void> _loadProducts() async {
    setState(() => _loadingProducts = true);
    try {
      final data = await SupabaseService.getProducts();
      final products = data.map((p) => VisitProduct(
            id: p['id']?.toString() ?? '',
            name: p['name'] ?? '',
            category: p['category'] ?? '',
            lastGiven: 0,
            currentVisible: 0,
            pricePerUnit: (p['selling_price'] as num?)?.toDouble() ?? 0,
            unit: p['unit'] ?? 'pièce',
          )).toList();

      setState(() {
        _products = products;
        for (final p in _products) {
          _newStockToGive[p.id] = 0;
        }
      });
    } catch (e) {
      _showSnackBar('Erreur chargement produits: $e', AppTheme.error);
    } finally {
      setState(() => _loadingProducts = false);
    }
  }

  // ── Stock change handlers ──────────────────────────────────

  void _onVisibleStockChanged(String productId, int value) {
    setState(() {
      final idx = _products.indexWhere((p) => p.id == productId);
      if (idx != -1) {
        _products[idx] = _products[idx].copyWith(currentVisible: value);
      }
    });
  }

  void _onNewStockChanged(String productId, int value) {
    setState(() => _newStockToGive[productId] = value);
  }

  // ── Totals ─────────────────────────────────────────────────

  double get _totalOwed => _products.fold(0.0, (sum, p) {
        final sold = (p.lastGiven - p.currentVisible).clamp(0, p.lastGiven);
        return sum + (sold * p.pricePerUnit);
      });

  double get _previousDebt =>
      (_selectedSeller?['total_debt'] as num?)?.toDouble() ?? 0.0;

  double get _grandTotal => _totalOwed + _previousDebt;

  // ── Save visit to Supabase ─────────────────────────────────

  Future<void> _completeVisit() async {
    if (_selectedSeller == null) {
      _showSnackBar('Veuillez sélectionner un vendeur', AppTheme.warning);
      return;
    }

    setState(() => _savingVisit = true);

    try {
      final agentId = SupabaseService.currentUser?.id;
      final sellerId = _selectedSeller!['id'];

      // Build visit record
      final visit = {
        'seller_id': sellerId,
        'agent_id': agentId,
        'total_amount': _totalOwed,
        'notes': '',
      };

      // Build items list (only products with sold quantity > 0)
      final items = _products
          .where((p) => p.soldQuantity > 0)
          .map((p) => {
                'product_id': p.id,
                'product_name': p.name,
                'quantity': p.soldQuantity,
                'price_per_unit': p.pricePerUnit,
              })
          .toList();

      // Save visit + items to Supabase
      await SupabaseService.saveVisit(visit, items);

      // Update seller debt
      final newDebt = _previousDebt + _totalOwed;
      await SupabaseService.updateSeller(sellerId, {'total_debt': newDebt});

      setState(() => _visitCompleted = true);
      _showSnackBar('Visite enregistrée avec succès ✓', AppTheme.success);
    } catch (e) {
      _showSnackBar('Erreur sauvegarde: $e', AppTheme.error);
    } finally {
      setState(() => _savingVisit = false);
    }
  }

  void _showInvoice() {
    if (_selectedSeller == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SellerVisitInvoiceSheetWidget(
        sellerName: _selectedSeller!['name'] ?? '',
        sellerContact: _selectedSeller!['phone'] ?? '',
        sellerLocation: _selectedSeller!['address'] ?? '',
        products: _products,
        newStockToGive: _newStockToGive,
        totalOwed: _totalOwed,
        previousDebt: _previousDebt,
        grandTotal: _grandTotal,
        visitDate: DateTime.now(),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.info_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  style: GoogleFonts.ibmPlexSans(
                      fontSize: 14, fontWeight: FontWeight.w600))),
        ]),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    if (_loadingSellers || _loadingProducts) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(),
      body: isTablet ? _buildTabletLayout(context) : _buildPhoneLayout(context),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.primary),
        onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.adminDashboardScreen, (r) => false),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Visite vendeur',
              style: GoogleFonts.ibmPlexSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E))),
          Text(
            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            style: GoogleFonts.ibmPlexSans(fontSize: 12, color: AppTheme.muted),
          ),
        ],
      ),
      // Seller dropdown in AppBar
      actions: [
        if (_sellers.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButton<String>(
              value: _selectedSeller?['id']?.toString(),
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primary),
              style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary),
              items: _sellers.map((s) {
                return DropdownMenuItem<String>(
                  value: s['id']?.toString(),
                  child: Text(s['name'] ?? ''),
                );
              }).toList(),
              onChanged: (id) {
                setState(() {
                  _selectedSeller = _sellers.firstWhere(
                      (s) => s['id']?.toString() == id,
                      orElse: () => _sellers.first);
                  _visitCompleted = false;
                });
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 12,
              offset: const Offset(0, -4))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _showInvoice,
              icon: const Icon(Icons.receipt_long_rounded, size: 18),
              label: Text('Facture',
                  style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.primary),
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed:
                  (_visitCompleted || _savingVisit) ? null : _completeVisit,
              icon: _savingVisit
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Icon(
                      _visitCompleted
                          ? Icons.check_circle_rounded
                          : Icons.save_rounded,
                      size: 18),
              label: Text(
                _savingVisit
                    ? 'Enregistrement...'
                    : _visitCompleted
                        ? 'Visite enregistrée'
                        : 'Terminer la visite',
                style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _visitCompleted ? AppTheme.success : AppTheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SellerVisitHeaderWidget(
              sellerName: _selectedSeller?['name'] ?? 'Sélectionnez un vendeur',
              location: _selectedSeller?['address'] ?? '',
              contact: _selectedSeller?['phone'] ?? '',
              previousDebt: _previousDebt,
              lastVisitDate: 'Aujourd\'hui',
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: SellerVisitProductListWidget(
              products: _products,
              onVisibleStockChanged: _onVisibleStockChanged,
              onNewStockChanged: _onNewStockChanged,
              newStockToGive: _newStockToGive,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 160),
            child: SellerVisitSummaryWidget(
              products: _products,
              previousDebt: _previousDebt,
              totalOwed: _totalOwed,
              grandTotal: _grandTotal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 12, 0),
                  child: SellerVisitHeaderWidget(
                    sellerName:
                        _selectedSeller?['name'] ?? 'Sélectionnez un vendeur',
                    location: _selectedSeller?['address'] ?? '',
                    contact: _selectedSeller?['phone'] ?? '',
                    previousDebt: _previousDebt,
                    lastVisitDate: 'Aujourd\'hui',
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 12, 100),
                  child: SellerVisitProductListWidget(
                    products: _products,
                    onVisibleStockChanged: _onVisibleStockChanged,
                    onNewStockChanged: _onNewStockChanged,
                    newStockToGive: _newStockToGive,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 20, 24, 100),
            child: SellerVisitSummaryWidget(
              products: _products,
              previousDebt: _previousDebt,
              totalOwed: _totalOwed,
              grandTotal: _grandTotal,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Data Model ─────────────────────────────────────────────
class VisitProduct {
  final String id;
  final String name;
  final String category;
  final int lastGiven;
  final int currentVisible;
  final double pricePerUnit;
  final String unit;

  const VisitProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.lastGiven,
    required this.currentVisible,
    required this.pricePerUnit,
    required this.unit,
  });

  factory VisitProduct.fromMap(Map<String, dynamic> map) {
    return VisitProduct(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      lastGiven: (map['lastGiven'] as num?)?.toInt() ?? 0,
      currentVisible: (map['currentVisible'] as num?)?.toInt() ?? 0,
      pricePerUnit: (map['pricePerUnit'] as num?)?.toDouble() ?? 0,
      unit: map['unit'] ?? 'pièce',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'lastGiven': lastGiven,
        'currentVisible': currentVisible,
        'pricePerUnit': pricePerUnit,
        'unit': unit,
      };

  VisitProduct copyWith({
    String? id,
    String? name,
    String? category,
    int? lastGiven,
    int? currentVisible,
    double? pricePerUnit,
    String? unit,
  }) {
    return VisitProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      lastGiven: lastGiven ?? this.lastGiven,
      currentVisible: currentVisible ?? this.currentVisible,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      unit: unit ?? this.unit,
    );
  }

  int get soldQuantity => (lastGiven - currentVisible).clamp(0, lastGiven);
  double get lineTotal => soldQuantity * pricePerUnit;
}
