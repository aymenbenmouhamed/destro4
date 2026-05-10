import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../seller_visit_screen.dart';

class SellerVisitProductListWidget extends StatelessWidget {
  final List<VisitProduct> products;
  final Function(String id, int value) onVisibleStockChanged;
  final Function(String id, int value) onNewStockChanged;
  final Map<String, int> newStockToGive;

  const SellerVisitProductListWidget({
    super.key,
    required this.products,
    required this.onVisibleStockChanged,
    required this.onNewStockChanged,
    required this.newStockToGive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.inventory_2_rounded,
              size: 18,
              color: AppTheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Saisie du stock visible',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Entrez le stock actuellement visible chez le vendeur',
          style: GoogleFonts.ibmPlexSans(fontSize: 13, color: AppTheme.muted),
        ),
        const SizedBox(height: 14),
        // Column headers
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Produit',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              _headerCell('Donné', flex: 2),
              _headerCell('Visible', flex: 2),
              _headerCell('Vendu', flex: 2),
              _headerCell('Montant', flex: 3),
            ],
          ),
        ),
        ...products.asMap().entries.map(
          (e) => _ProductRowWidget(
            product: e.value,
            isEven: e.key % 2 == 0,
            isLast: e.key == products.length - 1,
            newStock: newStockToGive[e.value.id] ?? 0,
            onVisibleChanged: (v) => onVisibleStockChanged(e.value.id, v),
            onNewStockChanged: (v) => onNewStockChanged(e.value.id, v),
          ),
        ),
        // New stock section
        Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.successContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.success.withAlpha(77), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.add_box_rounded,
                    size: 18,
                    color: AppTheme.success,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Nouveau stock à laisser',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...products.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _NewStockRow(
                    product: p,
                    currentValue: newStockToGive[p.id] ?? 0,
                    onChanged: (v) => onNewStockChanged(p.id, v),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerCell(String label, {int flex = 2}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: GoogleFonts.ibmPlexSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ProductRowWidget extends StatefulWidget {
  final VisitProduct product;
  final bool isEven;
  final bool isLast;
  final int newStock;
  final Function(int) onVisibleChanged;
  final Function(int) onNewStockChanged;

  const _ProductRowWidget({
    required this.product,
    required this.isEven,
    required this.isLast,
    required this.newStock,
    required this.onVisibleChanged,
    required this.onNewStockChanged,
  });

  @override
  State<_ProductRowWidget> createState() => _ProductRowWidgetState();
}

class _ProductRowWidgetState extends State<_ProductRowWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _pulseController;
  late Animation<Color?> _pulseColor;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.product.currentVisible > 0
          ? widget.product.currentVisible.toString()
          : '',
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _pulseColor =
        ColorTween(begin: AppTheme.primaryContainer, end: Colors.white).animate(
          CurvedAnimation(parent: _pulseController, curve: Curves.easeOutCubic),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onChanged(String val) {
    final parsed = int.tryParse(val) ?? 0;
    widget.onVisibleChanged(parsed);
    _pulseController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final sold = widget.product.soldQuantity;
    final lineTotal = widget.product.lineTotal;
    final borderRadius = widget.isLast
        ? const BorderRadius.vertical(bottom: Radius.circular(12))
        : BorderRadius.zero;

    return AnimatedBuilder(
      animation: _pulseColor,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: widget.isEven ? AppTheme.surface : AppTheme.surfaceVariant,
            borderRadius: borderRadius,
            border: Border(
              left: BorderSide(color: AppTheme.outlineVariant, width: 0.5),
              right: BorderSide(color: AppTheme.outlineVariant, width: 0.5),
              bottom: BorderSide(
                color: widget.isLast
                    ? Colors.transparent
                    : AppTheme.outlineVariant,
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                // Product name
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      Text(
                        '${widget.product.pricePerUnit.toStringAsFixed(2)} TND/${widget.product.unit}',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                // Last given
                Expanded(
                  flex: 2,
                  child: Text(
                    '${widget.product.lastGiven}',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.muted,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Visible stock input
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                      onChanged: _onChanged,
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: GoogleFonts.ibmPlexSans(
                          fontSize: 16,
                          color: AppTheme.outline,
                        ),
                        filled: true,
                        fillColor: AppTheme.primaryContainer.withAlpha(102),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppTheme.primary,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppTheme.primary.withAlpha(102),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppTheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                // Sold (auto-calculated)
                Expanded(
                  flex: 2,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: sold > 0
                          ? AppTheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$sold',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: sold > 0 ? AppTheme.primary : AppTheme.muted,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Line total
                Expanded(
                  flex: 3,
                  child: Text(
                    lineTotal > 0 ? '${lineTotal.toStringAsFixed(1)} TND' : '—',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: lineTotal > 0 ? AppTheme.debtRed : AppTheme.muted,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NewStockRow extends StatefulWidget {
  final VisitProduct product;
  final int currentValue;
  final Function(int) onChanged;

  const _NewStockRow({
    required this.product,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  State<_NewStockRow> createState() => _NewStockRowState();
}

class _NewStockRowState extends State<_NewStockRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentValue > 0 ? widget.currentValue.toString() : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.product.name,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Decrement
        _buildStepButton(
          icon: Icons.remove_rounded,
          onTap: () {
            final newVal = (widget.currentValue - 1).clamp(0, 999);
            _controller.text = newVal > 0 ? newVal.toString() : '';
            widget.onChanged(newVal);
          },
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 64,
          height: 44,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.success,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            onChanged: (val) => widget.onChanged(int.tryParse(val) ?? 0),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: GoogleFonts.ibmPlexSans(
                fontSize: 18,
                color: AppTheme.outline,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: AppTheme.success,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide(
                  color: AppTheme.success.withAlpha(128),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: AppTheme.success, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Increment
        _buildStepButton(
          icon: Icons.add_rounded,
          onTap: () {
            final newVal = widget.currentValue + 1;
            _controller.text = newVal.toString();
            widget.onChanged(newVal);
          },
          isAdd: true,
        ),
        const SizedBox(width: 8),
        Text(
          widget.product.unit,
          style: GoogleFonts.ibmPlexSans(fontSize: 12, color: AppTheme.muted),
        ),
      ],
    );
  }

  Widget _buildStepButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isAdd = false,
  }) {
    return Material(
      color: isAdd ? AppTheme.success : AppTheme.surfaceVariant,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            size: 20,
            color: isAdd ? Colors.white : AppTheme.muted,
          ),
        ),
      ),
    );
  }
}
