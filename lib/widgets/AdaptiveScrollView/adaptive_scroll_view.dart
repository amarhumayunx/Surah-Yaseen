import 'package:flutter/material.dart';

/// Adaptive scroll view that enables/disables scrolling based on:
/// - [hasAd]: When true (banner or native ad present), scroll is always active
///   so content can scroll above the ad and stay visible.
/// - When false: Scroll is only active when content overflows the viewport.
///   If content fits, scroll is disabled (no bounce effect).
///
/// Ensures components are always properly shown.
class AdaptiveScrollView extends StatefulWidget {
  final Widget child;
  /// When true, scroll is always enabled (banner/native ad takes space).
  final bool hasAd;

  const AdaptiveScrollView({
    super.key,
    required this.child,
    this.hasAd = false,
  });

  @override
  State<AdaptiveScrollView> createState() => _AdaptiveScrollViewState();
}

class _AdaptiveScrollViewState extends State<AdaptiveScrollView> {
  final ScrollController _scrollController = ScrollController();
  bool _needsScroll = true; // Default to scroll until we measure
  bool _hasMeasured = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_measureOverflow);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _measureOverflow(_) {
    if (!mounted || _hasMeasured) return;
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    // maxScrollExtent > 0 means content overflows viewport
    final overflows = position.maxScrollExtent > 1;

    if (mounted && (!_hasMeasured || _needsScroll != (widget.hasAd || overflows))) {
      setState(() {
        _needsScroll = widget.hasAd || overflows;
        _hasMeasured = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // When hasAd, always enable scroll so content can scroll above banner
    final scrollEnabled = widget.hasAd || _needsScroll;

    return SingleChildScrollView(
      controller: _scrollController,
      physics: scrollEnabled
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      child: widget.child,
    );
  }
}
