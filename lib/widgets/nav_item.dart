import 'package:flutter/material.dart';

class NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  late bool _active;

  @override
  void initState() {
    super.initState();
    _active = widget.active;
  }

  @override
  void didUpdateWidget(covariant NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) {
      _active = widget.active;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Gestisci la logica di attivazione o richiama il callback onTap
        // Per gestire la navigazione verso le altre funzionalità, puoi utilizzare Navigator.
        setState(() {
          _active = !_active;
        });
        widget.onTap?.call();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, color: _active ? Colors.blue : Colors.grey),
          const SizedBox(height: 4),
          Text(
            widget.label,
            style: TextStyle(
              color: _active ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}