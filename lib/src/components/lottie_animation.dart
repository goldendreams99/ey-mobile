part of employ.widgets;

class LottieAnim extends StatefulWidget {
  final Size size;
  final Duration duration;
  final String path;
  final VoidCallback? callback;
  final bool itRepeatable;

  const LottieAnim({
    required this.size,
    required this.duration,
    required this.path,
    this.callback,
    this.itRepeatable = false,
  });

  @override
  _LottieAnimState createState() => _LottieAnimState();
}

class _LottieAnimState extends State<LottieAnim>
    with SingleTickerProviderStateMixin {
  LottieComposition? lottieComposition;
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    loadLottieAnimation(widget.path).then((composition) {
      lottieComposition = composition;
      if (mounted)
        controller?.forward().then((e) {
          if (widget.itRepeatable) controller?.repeat();
          if (widget.callback != null) widget.callback?.call();
        });
    });
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    controller?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<LottieComposition> loadLottieAnimation(String assetName) async {
    return AssetLottie(assetName).load();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie(
      composition: lottieComposition,
      height: widget.size.height,
      width: widget.size.width,
      controller: controller,
    );
  }
}
