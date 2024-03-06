import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class StfScreen extends StatefulWidget {
  const StfScreen({
    super.key,
    required this.selectedIndex,
    required this.pageIndex,
    required this.pageName,
  });

  final int selectedIndex;
  final int pageIndex;
  final String pageName;

  @override
  State<StfScreen> createState() => _StfScreenState();
}

class _StfScreenState extends State<StfScreen> {
  int _clicks = 0;

  void _increase() {
    setState(() {
      _clicks++;
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    return Offstage(
      offstage: widget.selectedIndex != widget.pageIndex,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Page ${widget.pageName}',
              style: const TextStyle(fontSize: Sizes.size40),
            ),
            Text(
              'Number of Clicks: $_clicks',
              style: const TextStyle(fontSize: Sizes.size18),
            ),
            TextButton(
              onPressed: _increase,
              child: const Text(
                '+',
                style: TextStyle(fontSize: Sizes.size32),
              ),
            )
          ],
        ),
      ),
    );
  }
}
