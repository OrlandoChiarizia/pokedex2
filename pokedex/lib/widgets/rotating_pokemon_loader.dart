import 'dart:math';
import 'package:flutter/material.dart';

class RotatingPokemonLoader extends StatefulWidget {
  @override
  _RotatingPokemonLoaderState createState() => _RotatingPokemonLoaderState();
}

class _RotatingPokemonLoaderState extends State<RotatingPokemonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _controller,
        child: Image.asset(
          'assets/images/pokeball.png',
          width: 80,
          height: 80,
        ),
      ),
    );
  }
}
