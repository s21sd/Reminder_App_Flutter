import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:reminder_app/ui/home_page.dart';
import 'package:reminder_app/ui/login_page.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<MySplashScreen>
    with TickerProviderStateMixin {
  final double _buttonWidth = 100;

  late AnimationController _buttonScaleController;
  late Animation<double> _buttonScaleAnimation;
  late AnimationController _buttonWidthController;
  late Animation<double> _buttonWidthAnimation;
  late AnimationController _positionedController;
  late Animation<double> _positionedAnimation;
  late AnimationController _screenScaleController;
  late Animation<double> _screenScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initButtonScale();
    _initScreenScale();
    _checkUserLoggedIn();
  }

  void _initButtonScale() {
    _buttonScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buttonScaleAnimation =
        Tween<double>(begin: 1, end: .9).animate(_buttonScaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _buttonWidthController.forward();
            }
          });
  }

  void _initButtonWidth(double screenWidth) {
    _buttonWidthController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _buttonWidthAnimation = Tween<double>(begin: _buttonWidth, end: screenWidth)
        .animate(_buttonWidthController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _positionedController.forward();
        }
      });
  }

  void _initPositioned(double screenWidth) {
    _positionedController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _positionedAnimation = Tween<double>(begin: 10, end: screenWidth - 160)
        .animate(_positionedController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _screenScaleController.forward();
        }
      });
  }

  void _initScreenScale() {
    _screenScaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _screenScaleAnimation =
        Tween<double>(begin: 1, end: 24).animate(_screenScaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _navigateToNextPage();
            }
          });
  }

  Future<void> _checkUserLoggedIn() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simulating a delay for the splash screen
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Get.offAll(() => HomePage(
            imgUrl: user.photoURL,
            userId: user.uid,
          ));
    } else {
      Get.offAll(() => const LoginPage());
    }
  }

  void _navigateToNextPage() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Get.offAll(() => HomePage(
            imgUrl: user.photoURL,
            userId: user.uid,
          ));
    } else {
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  void dispose() {
    _buttonScaleController.dispose();
    _buttonWidthController.dispose();
    _positionedController.dispose();
    _screenScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    _initButtonWidth(screenWidth);
    _initPositioned(screenWidth);

    return CupertinoPageScaffold(
      backgroundColor: const Color.fromARGB(255, 255, 193, 7),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: SizedBox(
                      height: 300,
                      child: Lottie.asset(
                          'assets/animations/splashanimation.json',
                          fit: BoxFit.contain,
                          width: 400,
                          height: 400,
                          repeat: true)),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'reminder_app App',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    decoration: TextDecoration.none,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Streamline your day with ease: Never miss a moment with our intuitive reminder app.',
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color:
                          const Color.fromARGB(255, 59, 57, 57).withOpacity(.8),
                      fontSize: 15,
                      height: 1.5),
                ),
                const SizedBox(
                  height: 100,
                ),
                AnimatedBuilder(
                  animation: _buttonScaleController,
                  builder: (_, child) => Transform.scale(
                    scale: _buttonScaleAnimation.value,
                    child: CupertinoButton(
                      onPressed: () {
                        _buttonScaleController.forward();
                      },
                      child: Stack(
                        children: [
                          AnimatedBuilder(
                            animation: _buttonWidthController,
                            builder: (_, child) => Container(
                              height: _buttonWidth,
                              width: _buttonWidthAnimation.value,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(.7),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _positionedController,
                            builder: (_, child) => Positioned(
                              top: 10,
                              left: _positionedAnimation.value,
                              child: AnimatedBuilder(
                                animation: _screenScaleController,
                                builder: (_, child) => Transform.scale(
                                  scale: _screenScaleAnimation.value,
                                  child: Container(
                                    height: _buttonWidth - 20,
                                    width: _buttonWidth - 20,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: _screenScaleController.isDismissed
                                        ? const Icon(
                                            CupertinoIcons.chevron_forward,
                                            color: CupertinoColors.white,
                                            size: 35,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
