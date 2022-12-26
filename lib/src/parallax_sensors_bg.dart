import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'parallax_sensors.dart';

export 'parallax_sensors.dart';

class Layer {
  Layer({
    Key? key,
    required this.sensitivity,
    this.offset,
    this.image,
    this.imageFit = BoxFit.cover,
    this.preventCrop = false,
    this.imageHeight,
    this.imageWidth,
    this.imageBlurValue = 0,
    this.imageDarkenValue = 0,
    this.child,
  }) : super();

  final double sensitivity;
  final Offset? offset;
  final ImageProvider<Object>? image;
  final BoxFit imageFit;
  final bool preventCrop;
  final double? imageHeight;
  final double? imageWidth;
  double imageBlurValue = 0;
  double imageDarkenValue = 0;
  final Widget? child;

  Widget _build(int animationDuration, double maxSensitivity, double top,
          double bottom, double right, double left) =>
      AnimatedPositioned(
        duration: Duration(milliseconds: animationDuration),
        top: preventCrop
            ? (top - maxSensitivity) * sensitivity
            : top * sensitivity,
        bottom: preventCrop
            ? (bottom - maxSensitivity) * sensitivity
            : bottom * sensitivity,
        right: preventCrop
            ? (right - maxSensitivity) * sensitivity
            : right * sensitivity,
        left: preventCrop
            ? (left - maxSensitivity) * sensitivity
            : left * sensitivity,
        child: Container(
          height: imageHeight,
          width: imageWidth,
          decoration: BoxDecoration(
            image: image != null
                ? DecorationImage(
                    image: image!,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Stack(
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter:
                      ImageFilter.blur(sigmaX: imageBlurValue, sigmaY: imageBlurValue),
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(imageDarkenValue)),
                  ),
                ),
              ),
              child != null ? child! : const SizedBox.shrink(),
            ],
          ),
        ),
      );
}

class ParallaxBackground extends StatefulWidget {
  const ParallaxBackground({
    Key? key,
    this.sensor = ParallaxSensor.accelerometer,
    required this.layers,
    this.reverseVerticalAxis = false,
    this.reverseHorizontalAxis = false,
    this.lockVerticalAxis = false,
    this.lockHorizontalAxis = false,
    this.animationDuration = 250,
    this.child,
  }) : super(key: key);

  final ParallaxSensor sensor;
  final List<Layer> layers;
  final bool reverseVerticalAxis;
  final bool reverseHorizontalAxis;
  final bool lockVerticalAxis;
  final bool lockHorizontalAxis;
  final int animationDuration;
  final Widget? child;

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSensorEvent;
  StreamSubscription<UserAccelerometerEvent>? _userAccelerometerSensorEvent;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSensorEvent;
  StreamSubscription<MagnetometerEvent>? _magnetometerSensorEvent;
  double _top = 0, _bottom = 0, _right = 0, _left = 0, _maxSensitivity = 0;

  @override
  void initState() {
    switch (widget.sensor) {
      case ParallaxSensor.accelerometer:
        _accelerometerSensorEvent =
            accelerometerEvents.listen((AccelerometerEvent event) {
          setState(() {
            _maxSensitivity = 10;
            _top = widget.lockVerticalAxis
                ? 0
                : widget.reverseVerticalAxis
                    ? -event.y
                    : event.y;
            _bottom = widget.lockVerticalAxis
                ? 0
                : widget.reverseVerticalAxis
                    ? event.y
                    : -event.y;
            _right = widget.lockHorizontalAxis
                ? 0
                : widget.reverseHorizontalAxis
                    ? -event.x
                    : event.x;
            _left = widget.lockHorizontalAxis
                ? 0
                : widget.reverseHorizontalAxis
                    ? event.x
                    : -event.x;
          });
        });
        break;

      case ParallaxSensor.userAccelerometer:
        _userAccelerometerSensorEvent =
            userAccelerometerEvents.listen((UserAccelerometerEvent event) {
          setState(() {
            _maxSensitivity = 10;
            _top = widget.lockVerticalAxis
                ? 0
                : widget.reverseVerticalAxis
                    ? -event.y
                    : event.y;
            _bottom = widget.lockVerticalAxis
                ? 0
                : widget.reverseVerticalAxis
                    ? event.y
                    : -event.y;
            _right = widget.lockHorizontalAxis
                ? 0
                : widget.reverseHorizontalAxis
                    ? -event.x
                    : event.x;
            _left = widget.lockHorizontalAxis
                ? 0
                : widget.reverseHorizontalAxis
                    ? event.x
                    : -event.x;
          });
        });
        break;

      case ParallaxSensor.gyroscope:
        _gyroscopeSensorEvent = gyroscopeEvents.listen((GyroscopeEvent event) {
          setState(() {
            _maxSensitivity = 10;
            _top = widget.lockVerticalAxis
                ? 0
                : widget.reverseVerticalAxis
                    ? -event.x
                    : event.x;
            _bottom = widget.lockVerticalAxis
                ? 0
                : widget.reverseVerticalAxis
                    ? event.x
                    : -event.x;
            _right = widget.lockHorizontalAxis
                ? 0
                : widget.reverseHorizontalAxis
                    ? -event.y
                    : event.y;
            _left = widget.lockHorizontalAxis
                ? 0
                : widget.reverseHorizontalAxis
                    ? event.y
                    : -event.y;
          });
        });
        break;

      case ParallaxSensor.magnetometer:
        _magnetometerSensorEvent =
            magnetometerEvents.listen((MagnetometerEvent event) {
          setState(() {
            _maxSensitivity = 100;
            _top = widget.lockVerticalAxis
                ? 0
                : widget.reverseVerticalAxis
                    ? -event.y
                    : event.y;
            _bottom = widget.lockVerticalAxis
                ? 0
                : widget.reverseVerticalAxis
                    ? event.y
                    : -event.y;
            _right = widget.lockHorizontalAxis
                ? 0
                : widget.reverseHorizontalAxis
                    ? -event.x
                    : event.x;
            _left = widget.lockHorizontalAxis
                ? 0
                : widget.reverseHorizontalAxis
                    ? event.x
                    : -event.x;
          });
        });
        break;
    }
    super.initState();
  }

  @override
  void dispose() {
    _accelerometerSensorEvent?.cancel();
    _userAccelerometerSensorEvent?.cancel();
    _gyroscopeSensorEvent?.cancel();
    _magnetometerSensorEvent?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: widget.layers
              .map((layer) => layer._build(widget.animationDuration,
                  _maxSensitivity, _top, _bottom, _right, _left))
              .toList(),
        ),
        widget.child != null ? widget.child! : Container(),
      ],
    );
  }
}