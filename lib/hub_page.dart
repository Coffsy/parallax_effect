import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parallax_effect/data.dart';

// SvgPicture.asset('assets/layer-1.svg')
class HubPage extends StatefulWidget {
  const HubPage({Key? key}) : super(key: key);

  @override
  State<HubPage> createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {
  late final ScrollController _scrollController;
  late PageController _pageController;

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
      _pageViewOffset = _pageController.page ?? 0.0;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    _pageController = PageController(viewportFraction: 0.7);
    _pageController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // vertical speeds
  double l1Speed = 0.5;
  double l2Speed = 0.45;
  double l3Speed = 0.43;
  double l4Speed = 0.375;
  double sunSpeed = 0.20;

  // horizontal speeds
  double l1HSpeed = 0.1;
  double l2HSpeed = 0.08;
  double l3HSpeed = 0.075;
  double l4HSpeed = 0.07;

  // offset
  double _pageViewOffset = 0.0;
  double _scrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    var screenSize = MediaQuery.of(context).size;
    var layoutHeight = screenSize.height * 2;

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 66, 240, 210),
                Color.fromARGB(255, 253, 244, 193),
              ],
            ),
          ),
          child: Stack(
            children: [
              //* SUN
              Positioned(
                bottom: (screenSize.height * .50) +
                    (_scrollOffset * sunSpeed) -
                    padding.top,
                right: 0,
                left: 0,
                child: SvgPicture.asset(
                  'assets/sun.svg',
                  alignment: Alignment.bottomCenter,
                ),
              ),
              //* BIG MOUNTAIN
              Positioned(
                bottom: _scrollOffset * l4Speed,
                right: -(l4HSpeed * _scrollOffset),
                left: -(l4HSpeed * _scrollOffset),
                child: SvgPicture.asset(
                  'assets/mountains-layer-4.svg',
                  alignment: Alignment.bottomCenter,
                ),
              ),
              //* SMALL MOUNTAIN
              Positioned(
                bottom: _scrollOffset * l3Speed,
                right: -(l3HSpeed * _scrollOffset),
                left: -(l3HSpeed * _scrollOffset),
                child: SvgPicture.asset(
                  'assets/mountains-layer-2.svg',
                  alignment: Alignment.bottomCenter,
                ),
              ),
              //* TREES
              Positioned(
                bottom: _scrollOffset * l2Speed,
                right: -(l2HSpeed * _scrollOffset),
                left: -(l2HSpeed * _scrollOffset),
                child: SvgPicture.asset(
                  'assets/trees-layer-2.svg',
                  alignment: Alignment.bottomCenter,
                ),
              ),
              //* SHADOW
              Positioned(
                bottom: -2 + (_scrollOffset * l1Speed),
                right: -(l1HSpeed * _scrollOffset),
                left: -(l1HSpeed * _scrollOffset),
                height: screenSize.height,
                child: SvgPicture.asset(
                  'assets/layer-1.svg',
                  alignment: Alignment.bottomCenter,
                ),
              ),
              //* BODY PLACEHOLDER
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: _scrollController,
                  child: Container(
                    color: Colors.transparent,
                    height: layoutHeight,
                  ),
                ),
              ),
              //* BODY
              Positioned(
                top: screenSize.height -
                    padding.bottom +
                    (_scrollOffset * l1Speed * -1),
                right: 0,
                left: 0,
                child: Container(
                  height: screenSize.height,
                  color: Colors.black,
                  padding: const EdgeInsets.only(bottom: 30),
                  child: PageView.builder(
                      itemCount: paintings.length,
                      controller: _pageController,
                      itemBuilder: (context, i) {
                        return AnimatedOpacity(
                          duration: const Duration(seconds: 2),
                          opacity:
                              _scrollOffset > screenSize.height / 2 ? 1 : 0,
                          child: Container(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    paintings[i],
                                    height: 400,
                                    fit: BoxFit.cover,
                                    alignment: Alignment(
                                        -_pageViewOffset.abs() + i, 0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
