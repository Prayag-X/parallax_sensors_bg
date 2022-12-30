import 'package:flutter/material.dart';
import 'package:parallax_sensors_bg/parallax_sensors_bg.dart';

class Example2 extends StatelessWidget {
  const Example2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: const Center(
            child: Text(
          'Example 2',
          style: TextStyle(color: Colors.blue),
        )),
      ),
      body: Parallax(
        sensor: ParallaxSensor.accelerometer,
        lockVerticalAxis: true,
        layers: [
          Layer(
            sensitivity: 1,
            image: const AssetImage('assets/example2/layer 6.png'),
            preventCrop: true,
          ),
          Layer(
            sensitivity: 5,
            image: const AssetImage('assets/example2/layer 5.png'),
            preventCrop: true,
          ),
          Layer(
              sensitivity: 10,
              image: const AssetImage('assets/example2/layer 4.png'),
              preventCrop: true,
              offset: const Offset(0, 200)),
          Layer(
              sensitivity: 15,
              image: const AssetImage('assets/example2/layer 3.png'),
              preventCrop: true,
              offset: const Offset(0, 150)),
          Layer(
              sensitivity: 20,
              image: const AssetImage('assets/example2/layer 2.png'),
              preventCrop: true,
              offset: const Offset(0, 150)),
          Layer(
              sensitivity: 25,
              image: const AssetImage('assets/example2/layer 1.png'),
              preventCrop: true,
              offset: const Offset(0, -490)),
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
                'Using Accelerometer',
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
