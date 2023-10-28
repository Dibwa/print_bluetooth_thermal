import 'package:flutter/material.dart';

class SquareTile extends StatefulWidget {
   String pictureUrl;

  SquareTile({ required this.pictureUrl});

  @override
  State<SquareTile> createState() => _SquareTileState();
}

class _SquareTileState extends State<SquareTile> {
  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(widget.pictureUrl),
      width: 55,
    );
  }
}
