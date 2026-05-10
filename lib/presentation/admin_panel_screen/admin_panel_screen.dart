import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_navigation.dart';
import '../../services/supabase_service.dart';

// ─── Data Models ─────────────────────────────────────────────────────────────

class ProductModel {
  String id;
  String name;
  String category;
  double costPrice;
  double sellingPrice;
  int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.costPrice,
    required this.sellingPrice,
    required this.stock,
  });

  factory ProductModel.fromMap(Map<String, dynamic> m) => ProductModel(
        id: m['id']?.toString() ?? '',
        name: m['name'] ?? '',
        category: m['category'] ?? '',
        costPrice: (m['cost_price'] as num?)?.toDouble() ?? 0,
        sellingPrice: (m['selling_price'] as num?)?.toDouble() ?? 0,
        stock: (m['stock'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'category': category,
        'cost_price': costPrice,
        'selling_price': sellingPrice,
        'stock': stock,
      };
}

class SellerModel {
  String id;
  String name;
  String phone;
  String address;
  double totalDebt;

  SellerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.totalDebt,
  });

  factory SellerModel.fromMap(Map<String, dynamic> m) => SellerModel(
        id: m['id']?.toString() ?? '',
        name: m['name'] ?? '',
        phone: m['phone'] ?? '',
        address: m['address'] ?? '',
        totalDebt: (m['total_debt'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'address': address,
        'total_debt': totalDebt,
      };
}

// ─── Main Screen ──────────────────────────────────────────────────────────────

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<ProductModel> _products = [];
  List<SellerModel> _sellers = [];
  bool _loadingProducts = true;
  bool _loadingSellers = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProducts();
    _loadSellers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── Load from Supabase ───────────────────────────────────────────────────

  Future<void> _loadProducts() async {
    setState(() => _loadingProducts = true);
    try {
      final data = await SupabaseService.getProducts();
      setState(() => _products = data.map(ProductModel.fromMap).toList());
    } catch (e) {
      _showSnackBar('Erreur chargement produits: $e', AppTheme.error);
    } finally {
      setState(() => _loadingProducts = false);
    }
  }

  Future<void> _loadSellers() async {
    setState(() => _loadingSellers = true);
    try {
      final data = await SupabaseService.getSellers();
      setState(() => _sellers = data.map(SellerModel.fromMap).toList());
    } catch (e) {
      _showSnackBar('Erreur chargement vendeurs: $e', AppTheme.error);
    } finally {
      setState(() => _loadingSellers = false);
    }
  }

  // ─── Product CRUD ─────────────────────────────────────────────────────────

  void _showAddProductDialog() => _showProductDialog(null);
  void _showEditProductDialog(ProductModel p) => _showProductDialog(p);

  void _showProductDialog(ProductModel? existing) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final categoryCtrl = TextEditingController(text: existing?.category ?? '');
    final costCtrl =
        TextEditingController(text: existing?.costPrice.toString() ?? '');
    final sellCtrl =
        TextEditingController(text: existing?.sellingPrice.toString() ?? '');
    final stockCtrl =
        TextEditingController(text: existing?.stock.toString() ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                existing == null ? Icons.add_box_rounded : Icons.edit_rounded,
                color: AppTheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              existing == null ? 'Nouveau produit' : 'Modifier produit',
              style: GoogleFonts.ibmPlexSans(
                  fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogField(nameCtrl, 'Nom du produit',
                    Icons.label_rounded, required: true),
                const SizedBox(height: 12),
                _buildDialogField(
                    categoryCtrl, 'Catégorie', Icons.category_rounded),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDialogField(costCtrl, 'Prix coût (TND)',
                          Icons.price_change_outlined,
                          isNumber: true),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDialogField(sellCtrl, 'Prix vente (TND)',
                          Icons.sell_rounded,
                          isNumber: true),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDialogField(
                    stockCtrl, 'Stock initial', Icons.inventory_2_rounded,
                    isNumber: true),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Annuler',
                style: GoogleFonts.ibmPlexSans(color: AppTheme.muted)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(ctx);

              final data = {
                'name': nameCtrl.text.trim(),
                'category': categoryCtrl.text.trim().isEmpty
                    ? 'Général'
                    : categoryCtrl.text.trim(),
                'cost_price': double.tryParse(costCtrl.text) ?? 0,
                'selling_price': double.tryParse(sellCtrl.text) ?? 0,
                'stock': int.tryParse(stockCtrl.text) ?? 0,
              };

              try {
                if (existing == null) {
                  await SupabaseService.addProduct(data);
                  _showSnackBar('Produit ajouté ✓', AppTheme.success);
                } else {
                  await SupabaseService.updateProduct(existing.id, data);
                  _showSnackBar('Produit modifié ✓', AppTheme.success);
                }
                _loadProducts(); // Refresh from Supabase
              } catch (e) {
                _showSnackBar('Erreur: $e', AppTheme.error);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              minimumSize: const Size(100, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(existing == null ? 'Ajouter' : 'Enregistrer',
                style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteProduct(ProductModel product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppTheme.errorContainer,
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.delete_rounded,
                  color: AppTheme.error, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Supprimer produit'),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: GoogleFonts.ibmPlexSans(
                fontSize: 14, color: const Color(0xFF1A1A2E)),
            children: [
              const TextSpan(text: 'Supprimer '),
              TextSpan(
                  text: product.name,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const TextSpan(text: ' ? Cette action est irréversible.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Annuler',
                style: GoogleFonts.ibmPlexSans(color: AppTheme.muted)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await SupabaseService.deleteProduct(product.id);
                _showSnackBar('Produit supprimé', AppTheme.error);
                _loadProducts();
              } catch (e) {
                _showSnackBar('Erreur: $e', AppTheme.error);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              minimumSize: const Size(100, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Supprimer',
                style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ─── Seller CRUD ──────────────────────────────────────────────────────────

  void _showAddSellerDialog() => _showSellerDialog(null);
  void _showEditSellerDialog(SellerModel s) => _showSellerDialog(s);

  void _showSellerDialog(SellerModel? existing) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final addressCtrl = TextEditingController(text: existing?.address ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(
                existing == null
                    ? Icons.person_add_rounded
                    : Icons.edit_rounded,
                color: AppTheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              existing == null ? 'Nouveau vendeur' : 'Modifier vendeur',
              style: GoogleFonts.ibmPlexSans(
                  fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogField(
                    nameCtrl, 'Nom du vendeur', Icons.person_rounded,
                    required: true),
                const SizedBox(height: 12),
                _buildDialogField(phoneCtrl, 'Téléphone', Icons.phone_rounded),
                const SizedBox(height: 12),
                _buildDialogField(
                    addressCtrl, 'Adresse', Icons.location_on_rounded),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Annuler',
                style: GoogleFonts.ibmPlexSans(color: AppTheme.muted)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(ctx);

              final data = {
                'name': nameCtrl.text.trim(),
                'phone': phoneCtrl.text.trim(),
                'address': addressCtrl.text.trim(),
                'total_debt': existing?.totalDebt ?? 0,
              };

              try {
                if (existing == null) {
                  await SupabaseService.addSeller(data);
                  _showSnackBar('Vendeur ajouté ✓', AppTheme.success);
                } else {
                  await SupabaseService.updateSeller(existing.id, data);
                  _showSnackBar('Vendeur modifié ✓', AppTheme.success);
                }
                _loadSellers();
              } catch (e) {
                _showSnackBar('Erreur: $e', AppTheme.error);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              minimumSize: const Size(100, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(existing == null ? 'Ajouter' : 'Enregistrer',
                style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSeller(SellerModel seller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppTheme.errorContainer,
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.person_remove_rounded,
                  color: AppTheme.error, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Supprimer vendeur'),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: GoogleFonts.ibmPlexSans(
                fontSize: 14, color: const Color(0xFF1A1A2E)),
            children: [
              const TextSpan(text: 'Supprimer '),
              TextSpan(
                  text: seller.name,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const TextSpan(text: ' ? Toutes ses données seront perdues.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Annuler',
                style: GoogleFonts.ibmPlexSans(color: AppTheme.muted)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await SupabaseService.deleteSeller(seller.id);
                _showSnackBar('Vendeur supprimé', AppTheme.error);
                _loadSellers();
              } catch (e) {
                _showSnackBar('Erreur: $e', AppTheme.error);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              minimumSize: const Size(100, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Supprimer',
                style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      drawer:
          const AdminDrawerWidget(currentRoute: AppRoutes.adminPanelScreen),
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        scrolledUnderElevation: 2,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.menu_rounded,
                  size: 20, color: AppTheme.primary),
            ),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'Gestion',
          style: GoogleFonts.ibmPlexSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E)),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.muted,
          indicatorColor: AppTheme.primary,
          indicatorWeight: 3,
          labelStyle:
              GoogleFonts.ibmPlexSans(fontSize: 14, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              GoogleFonts.ibmPlexSans(fontSize: 14, fontWeight: FontWeight.w400),
          tabs: const [
            Tab(icon: Icon(Icons.store_rounded, size: 20), text: 'Produits'),
            Tab(icon: Icon(Icons.people_rounded, size: 20), text: 'Vendeurs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _loadingProducts
              ? const Center(child: CircularProgressIndicator())
              : _ProductsTab(
                  products: _products,
                  onAdd: _showAddProductDialog,
                  onEdit: _showEditProductDialog,
                  onDelete: _confirmDeleteProduct,
                ),
          _loadingSellers
              ? const Center(child: CircularProgressIndicator())
              : _SellersTab(
                  sellers: _sellers,
                  onAdd: _showAddSellerDialog,
                  onEdit: _showEditSellerDialog,
                  onDelete: _confirmDeleteSeller,
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_tabController.index == 0) {
            _showAddProductDialog();
          } else {
            _showAddSellerDialog();
          }
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: AnimatedBuilder(
          animation: _tabController,
          builder: (_, __) => Text(
            _tabController.index == 0 ? 'Ajouter produit' : 'Ajouter vendeur',
            style:
                GoogleFonts.ibmPlexSans(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  Widget _buildDialogField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool required = false,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      style: GoogleFonts.ibmPlexSans(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: AppTheme.muted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
        ),
      ),
      validator: required
          ? (v) =>
              (v == null || v.trim().isEmpty) ? 'Ce champ est requis' : null
          : null,
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: GoogleFonts.ibmPlexSans(
                color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ─── Products Tab ─────────────────────────────────────────────────────────────

class _ProductsTab extends StatefulWidget {
  final List<ProductModel> products;
  final VoidCallback onAdd;
  final void Function(ProductModel) onEdit;
  final void Function(ProductModel) onDelete;

  const _ProductsTab({
    required this.products,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<_ProductsTab> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products
        .where((p) =>
            p.name.toLowerCase().contains(_search.toLowerCase()) ||
            p.category.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Column(
      children: [
        _buildSearchBar('Rechercher un produit...'),
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptyState('Aucun produit trouvé', Icons.store_rounded)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _ProductCard(
                    product: filtered[i],
                    onEdit: () => widget.onEdit(filtered[i]),
                    onDelete: () => widget.onDelete(filtered[i]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(String hint) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: TextField(
        onChanged: (v) => setState(() => _search = v),
        style: GoogleFonts.ibmPlexSans(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.ibmPlexSans(fontSize: 14, color: AppTheme.muted),
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppTheme.muted, size: 20),
          filled: true,
          fillColor: AppTheme.surfaceVariant,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String msg, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: AppTheme.outlineVariant),
          const SizedBox(height: 12),
          Text(msg,
              style:
                  GoogleFonts.ibmPlexSans(fontSize: 15, color: AppTheme.muted)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCard(
      {required this.product, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final margin = product.sellingPrice - product.costPrice;
    final marginPct =
        product.costPrice > 0 ? (margin / product.costPrice * 100) : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.inventory_2_rounded,
                      color: AppTheme.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                          style: GoogleFonts.ibmPlexSans(
                              fontSize: 15, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: AppTheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(product.category,
                            style: GoogleFonts.ibmPlexSans(
                                fontSize: 11,
                                color: AppTheme.muted,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        const Icon(Icons.edit_rounded,
                            size: 18, color: AppTheme.primary),
                        const SizedBox(width: 10),
                        Text('Modifier',
                            style: GoogleFonts.ibmPlexSans(fontSize: 14)),
                      ]),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        const Icon(Icons.delete_rounded,
                            size: 18, color: AppTheme.error),
                        const SizedBox(width: 10),
                        Text('Supprimer',
                            style: GoogleFonts.ibmPlexSans(
                                fontSize: 14, color: AppTheme.error)),
                      ]),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.more_vert_rounded,
                        size: 18, color: AppTheme.muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildPriceChip('Coût',
                    '${product.costPrice.toStringAsFixed(2)} TND',
                    AppTheme.muted, AppTheme.surfaceVariant),
                const SizedBox(width: 8),
                _buildPriceChip('Vente',
                    '${product.sellingPrice.toStringAsFixed(2)} TND',
                    AppTheme.primary, AppTheme.primaryContainer),
                const Spacer(),
                _buildStockBadge(product.stock),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.trending_up_rounded,
                    size: 14,
                    color: margin >= 0 ? AppTheme.success : AppTheme.error),
                const SizedBox(width: 4),
                Text(
                  'Marge: ${margin.toStringAsFixed(2)} TND (${marginPct.toStringAsFixed(1)}%)',
                  style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      color: margin >= 0 ? AppTheme.success : AppTheme.error,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceChip(
      String label, String value, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  GoogleFonts.ibmPlexSans(fontSize: 10, color: AppTheme.muted)),
          Text(value,
              style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: textColor)),
        ],
      ),
    );
  }

  Widget _buildStockBadge(int stock) {
    final isLow = stock < 20;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: isLow ? AppTheme.warningContainer : AppTheme.successContainer,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              isLow
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_rounded,
              size: 12,
              color: isLow ? AppTheme.warning : AppTheme.success),
          const SizedBox(width: 4),
          Text('Stock: $stock',
              style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isLow ? AppTheme.warning : AppTheme.success)),
        ],
      ),
    );
  }
}

// ─── Sellers Tab ──────────────────────────────────────────────────────────────

class _SellersTab extends StatefulWidget {
  final List<SellerModel> sellers;
  final VoidCallback onAdd;
  final void Function(SellerModel) onEdit;
  final void Function(SellerModel) onDelete;

  const _SellersTab({
    required this.sellers,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_SellersTab> createState() => _SellersTabState();
}

class _SellersTabState extends State<_SellersTab> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.sellers
        .where((s) =>
            s.name.toLowerCase().contains(_search.toLowerCase()) ||
            s.phone.contains(_search) ||
            s.address.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Column(
      children: [
        _buildSearchBar('Rechercher un vendeur...'),
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptyState('Aucun vendeur trouvé', Icons.people_rounded)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _SellerCard(
                    seller: filtered[i],
                    onEdit: () => widget.onEdit(filtered[i]),
                    onDelete: () => widget.onDelete(filtered[i]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(String hint) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: TextField(
        onChanged: (v) => setState(() => _search = v),
        style: GoogleFonts.ibmPlexSans(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.ibmPlexSans(fontSize: 14, color: AppTheme.muted),
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppTheme.muted, size: 20),
          filled: true,
          fillColor: AppTheme.surfaceVariant,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String msg, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: AppTheme.outlineVariant),
          const SizedBox(height: 12),
          Text(msg,
              style:
                  GoogleFonts.ibmPlexSans(fontSize: 15, color: AppTheme.muted)),
        ],
      ),
    );
  }
}

class _SellerCard extends StatelessWidget {
  final SellerModel seller;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SellerCard(
      {required this.seller, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final hasDebt = seller.totalDebt > 0;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [AppTheme.primary, AppTheme.secondary]),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      seller.name.isNotEmpty
                          ? seller.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(seller.name,
                          style: GoogleFonts.ibmPlexSans(
                              fontSize: 15, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.phone_rounded,
                              size: 12, color: AppTheme.muted),
                          const SizedBox(width: 4),
                          Text(
                              seller.phone.isEmpty
                                  ? 'Non renseigné'
                                  : seller.phone,
                              style: GoogleFonts.ibmPlexSans(
                                  fontSize: 12, color: AppTheme.muted)),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        const Icon(Icons.edit_rounded,
                            size: 18, color: AppTheme.primary),
                        const SizedBox(width: 10),
                        Text('Modifier',
                            style: GoogleFonts.ibmPlexSans(fontSize: 14)),
                      ]),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        const Icon(Icons.delete_rounded,
                            size: 18, color: AppTheme.error),
                        const SizedBox(width: 10),
                        Text('Supprimer',
                            style: GoogleFonts.ibmPlexSans(
                                fontSize: 14, color: AppTheme.error)),
                      ]),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.more_vert_rounded,
                        size: 18, color: AppTheme.muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on_rounded,
                    size: 14, color: AppTheme.muted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                      seller.address.isEmpty
                          ? 'Adresse non renseignée'
                          : seller.address,
                      style: GoogleFonts.ibmPlexSans(
                          fontSize: 12, color: AppTheme.muted),
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: hasDebt
                          ? AppTheme.debtContainer
                          : AppTheme.successContainer,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                          hasDebt
                              ? Icons.account_balance_wallet_rounded
                              : Icons.check_circle_rounded,
                          size: 12,
                          color: hasDebt ? AppTheme.debtRed : AppTheme.success),
                      const SizedBox(width: 4),
                      Text(
                          hasDebt
                              ? '${seller.totalDebt.toStringAsFixed(0)} TND'
                              : 'Soldé',
                          style: GoogleFonts.ibmPlexSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: hasDebt
                                  ? AppTheme.debtRed
                                  : AppTheme.success)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
