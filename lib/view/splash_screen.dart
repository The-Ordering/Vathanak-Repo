import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  int _currentPage = 0;
  final List<String> titles = [
    'Fuel Your Imagination,',
    'Endless Books, Endless',
    'Where Every Page'
  ];
  final List<String> subTitles = [
    'One Page at a Time',
    'Adventures',
    'Comes to Life'
  ];

  final List<String> text1 = [
    'Discover endless stories and Immerse',
    'Turn every moment into an adventure with',
    'Dive into captivating tales and let every page',
  ];

  final List<String> text2 = [
    'Yourself in the joy of reading anytime',
    'stories that inspire and entertain',
    'take you somewhere new to open word',
  ];

  final List<String> text3 = [
    'anywhere',
    'any-day',
    'any worlds view',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start off-screen
      end: const Offset(0.0, 0.0), // Slide to position
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.reset(); // Reset the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _animationController.reset(); // Reset the animation
    _animationController.forward(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Column(
              children: [
                SizedBox(height: 70,),
                Container(
                  width: double.infinity,
                  height: 250,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        child: Image.asset('assets/images/booking_1.png',fit: BoxFit.contain,),
                      ),
                      Container(
                        width: 250,
                        height: 250,
                        child: Image.asset('assets/images/booking_4.png',fit: BoxFit.contain,),
                      ),
                      Container(
                        width: 250,
                        height: 250,
                        child: Image.asset('assets/images/booking_6.png',fit: BoxFit.contain,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25,),
                Container(
                  height: 12,
                  width: double.infinity,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index){
                        return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: _currentPage == index ? 8 : 5,
                            height: _currentPage == index ? 8 : 5,
                            decoration:  BoxDecoration(
                              color:  _currentPage == index ? Colors.white : Colors.white,
                              shape: BoxShape.circle,
                            )
                        );
                      })
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SlideTransition(position: _slideAnimation,
                    child: Text(
                      titles[_currentPage],
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SlideTransition(position: _slideAnimation,
                    child: Text(
                      subTitles[_currentPage],
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SlideTransition(position: _slideAnimation,
                    child: Text(
                      text1[_currentPage],
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                  ),
                  SlideTransition(position: _slideAnimation,
                    child: Text(
                      text2[_currentPage],
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                  ),
                  SlideTransition(position: _slideAnimation,
                    child: Text(
                      text3[_currentPage],
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 110,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedOpacity(
                  opacity: _currentPage == 2 ? 0.0 : 1.0, // Hide the Skip button on page 3
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedContainer(
                    width: _currentPage == 2 ? 0 : 150, // Shrink the button width to 0
                    height: 50,
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFF0E5E1), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Optional: Handle skip functionality
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 16,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  width: _currentPage == 2 ? 320 : 150, // Expand the Next button on page 3
                  height: 50,
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Color(0xFFF0E5E1), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: TextButton(
                            onPressed: () {
                              if (_currentPage == 2) {
                                // Navigate to the next screen
                              } else {
                                // Navigate to the next page in the PageView
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              }
                            },
                            child: Text(
                              _currentPage == 2 ? 'Get Started' : 'Next',
                              style: const TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      AnimatedAlign(
                        alignment:
                        _currentPage == 2 ? Alignment.centerRight : Alignment.centerRight,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          width: 35,
                          height: 35,
                          margin: const EdgeInsets.only(right: 10), // Add some right padding
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
