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
        height: size.height * 0.53,
        width: size.width,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 193, 7),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
      ),
    );
  }
}
