part of employ.widgets;

class FooterButton extends StatelessWidget {
  final double size;
  final IconData icon;
  final VoidCallback action;
  final Brightness theme;
  final bool enabled;

  const FooterButton({
    this.size = 60.0,
    required this.icon,
    required this.action,
    this.enabled = true,
    this.theme = Brightness.dark,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? action : null,
      icon: Icon(icon),
      color: (theme == Brightness.dark ? COLOR.greyish_brown : COLOR.white)
          .withOpacity(
        enabled ? 1.0 : 0.4,
      ),
      iconSize: size,
    );
  }
}
