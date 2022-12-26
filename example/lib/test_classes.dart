import 'package:flutter/material.dart';

class Trying {
  Widget? child;
  Trying({this.child});

  Widget _ChildWiget() =>child!;
}

class TryingBuild extends StatelessWidget {
  const TryingBuild({
    Key? key,
    required this.tryingBuild,
  }) : super(key: key);

  final Trying tryingBuild;

  @override
  Widget build(BuildContext context) {
    return tryingBuild._ChildWiget();
  }
}