import 'package:flutter/cupertino.dart';

class ShapeImagePositioned extends StatelessWidget {
  const ShapeImagePositioned({super.key, this.top = -50});
  final double top;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: size.width,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 193, 7),
        ),
      ),
    );
  }
}
