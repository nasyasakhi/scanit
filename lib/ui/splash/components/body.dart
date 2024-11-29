import 'package:flutter/material.dart';
import 'package:qr_scanner/const.dart';
import 'package:qr_scanner/ui/splash/components/splash_content.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  List<Map<String, String>> splashData = [
    {
      "title": "QR Code",
      "subtitle": "Simplify your life by accessing  \n information instantly with a simple scan!",
      "image": "assets/images/logo_barcode.png"
    },
    {
      "title": "Scan QR Code!",
      "subtitle": "Unlock endless possibilities and \n connect effortlessly with just one scan",
      "image": "assets/images/splash_01.png"
    },
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    title: splashData[index]["title"]!,
                    subtitle: splashData[index]["subtitle"]!,
                    image: splashData[index]["image"]!,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                splashData.length,
                (index) => _dotsIndicator(index: index),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (currentPage == splashData.length - 1) {
                          Navigator.pushNamed(context, '/scanner');
                        } else {
                          _pageController.nextPage(
                            duration: animationDuration,
                            curve: Curves.ease,
                          );
                        }
                      },
                      child: Text(
                        currentPage == splashData.length - 1 ? "Get Started" : "Next",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/scanner');
                    },
                    child: const Text(
                      "Already Have An Account? Log In",
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer _dotsIndicator({required int index}) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: currentPage == index ? primaryColor : Colors.grey,
      ),
      width: currentPage == index ? 20 : 7,
      height: 5,
      duration: animationDuration,
    );
  }
}
