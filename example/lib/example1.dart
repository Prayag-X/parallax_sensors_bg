import 'package:flutter/material.dart';
import 'package:parallax_sensors_bg/parallax_sensors_bg.dart';

class Example1 extends StatelessWidget {
  const Example1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: const Center(
            child: Text(
          'Example 1',
          style: TextStyle(color: Colors.blue),
        )),
      ),
      body: Parallax(
        sensor: ParallaxSensor.gyroscope,
        layers: [
          Layer(
            sensitivity: 1,
            image: const AssetImage('assets/example1/background.jpeg'),
            preventCrop: true,
          ),
          Layer(
            sensitivity: 4,
            image: const AssetImage('assets/example1/stars.png'),
            preventCrop: true,
          ),
          Layer(
              sensitivity: 7,
              image: const AssetImage('assets/example1/nebula.png'),
              preventCrop: true,
              opacity: 0.7),
          Layer(
              sensitivity: 10,
              image: const AssetImage('assets/example1/stars2.png'),
              preventCrop: true,
              opacity: 0.7),
          Layer(
              sensitivity: 13,
              image: const AssetImage('assets/example1/planet.png'),
              imageHeight: 150,
              imageFit: BoxFit.fitHeight),
        ],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Parallax Demo',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Using Gyroscope',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
