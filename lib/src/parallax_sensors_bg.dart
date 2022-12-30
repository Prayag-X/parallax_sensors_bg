import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'parallax_sensors.dart';
export 'parallax_sensors.dart';

class Layer {
  /// A layer of the parallax.
  ///
  /// Image can be given through **[image]** parameter.
  /// Any widgets can be given through **[child]** parameter.
  ///
  /// ---
  /// **Note:** Image can also be given through **[child]** widget.
  /// But a separate **[image]** parameter is given along with its related controls
  /// (*[imageFit]*, *[preventCrop]*, *[imageHeight]*, *[imageWidth]*, *[imageBlurValue]*,
  /// *[imageDarkenValue]e*) for simpler use.
  Layer({
    Key? key,
    required this.sensitivity,
    this.offset,
    this.image,
    this.imageFit = BoxFit.cover,
    this.preventCrop = false,
    this.imageHeight,
    this.imageWidth,
    this.imageBlurValue,
    this.imageDarkenValue,
    this.opacity,
    this.child,
  }) : super();

  /// Moving sensitivity of the layer. The sensitivity of the layers
  /// (from bottom to top from parallax perspective)
  /// should be in increasing order.
  final double sensitivity;

  /// Position of the layer from the center.
  final Offset? offset;

  /// Image that the layer will show.
  ///
  /// By default, the **[image]** will take the size of the screen.
  /// Provide **[imageHeight]** and **[imageWidth]** for the preferred size.
  final ImageProvider<Object>? image;

  /// BoxFit type of the image.
  final BoxFit imageFit;

  /// If set to true, it will ignore the **[imageHeight]** and **[imageWidth]** if given
  /// and will set the height and width of the **[image]** slightly more than the screen size
  /// such that it doesn't get cropped even at the extreme value of the **[sensor]**.
  final bool preventCrop;

  /// Height of the **[image]**.
  ///
  /// ---
  /// **Note:** It will be ignored if **[preventCrop]** is set to true
  final double? imageHeight;

  /// Width of the **[image]**.
  ///
  /// ---
  /// **Note:** It will be ignored if **[preventCrop]** is set to true
  final double? imageWidth;

  /// Blurs the **[image]**.
  ///
  /// Value can be any positive fractional number
  double? imageBlurValue;

  /// Darkens the **[image]**.
  ///
  /// Value ranges from 0 to 1
  double? imageDarkenValue;

  /// Opacity of the layer.
  ///
  /// Value ranges from 0 to 1
  double? opacity;

  /// Any widget that will also move
  final Widget? child;

  /// Function to build the layer.
  /// Set to private to prevent its access from outside this library.
  Widget _build(context, int animationDuration, double maxSensitivity,
          double top, double bottom, double right, double left) =>
      AnimatedPositioned(
        duration: Duration(milliseconds: animationDuration),
        top: (preventCrop
                ? (top - maxSensitivity) * sensitivity
                : (top) * sensitivity +
                    (MediaQuery.of(context).size.height -
                            (imageHeight ??
                                MediaQuery.of(context).size.height)) /
                        2) +
            ((offset?.dy ?? 0) / 2),
        bottom: (preventCrop
                ? (bottom - maxSensitivity) * sensitivity
                : (bottom) * sensitivity +
                    (MediaQuery.of(context).size.height -
                            (imageHeight ??
                                MediaQuery.of(context).size.height)) /
                        2) -
            ((offset?.dy ?? 0) / 2),
        right: (preventCrop
                ? (right - maxSensitivity) * sensitivity
                : (right) * sensitivity +
                    (MediaQuery.of(context).size.width -
                            (imageWidth ?? MediaQuery.of(context).size.width)) /
                        2) -
            ((offset?.dx ?? 0) / 2),
        left: (preventCrop
                ? (left - maxSensitivity) * sensitivity
                : (left) * sensitivity +
                    (MediaQuery.of(context).size.width -
                            (imageWidth ?? MediaQuery.of(context).size.width)) /
                        2) +
            ((offset?.dx ?? 0) / 2),
        child: Opacity(
          opacity: opacity ?? 1,
          child: Container(
            height: imageHeight,
            width: imageWidth,
            decoration: BoxDecoration(
              image: image != null
                  ? DecorationImage(
                      image: image!,
                      fit: imageFit,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: imageBlurValue ?? 0,
                        sigmaY: imageBlurValue ?? 0),
                    child: Container(
                      height: imageHeight,
                      width: imageWidth,
                      decoration: BoxDecoration(
                          color:
                              Colors.black.withOpacity(imageDarkenValue ?? 0)),
                    ),
                  ),
                ),
                child ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      );
}

class Parallax extends StatefulWidget {
  /// Creates a parallax effect based on the motion and position of the device.
  ///
  /// The type of sensor to detect the motion can be given through **[sensor]**.
  /// The fixed body of the page can be given through **[child]**.
  const Parallax({
    Key? key,
    this.sensor = ParallaxSensor.accelerometer,
    required this.layers,
    this.reverseVerticalAxis = false,
    this.reverseHorizontalAxis = false,
    this.lockVerticalAxis = false,
    this.lockHorizontalAxis = false,
    this.animationDuration = 300,
    this.child,
  }) : super(key: key);

  /// Type of the sensor whose detected values will be used for parallax movement
  ///
  /// **[accelerometer]:**
  /// Discrete reading from an accelerometer. Accelerometers measure the velocity
  /// of the device. Note that these readings include the effects of gravity. Put
  /// simply, you can use accelerometer readings to tell if the device is moving in
  /// a particular direction.
  ///
  /// **[userAccelerometer]:**
  /// Like **[accelerometer]**, this is a discrete reading from an accelerometer
  /// and measures the velocity of the device. However, unlike
  /// **[accelerometer]**, this event does not include the effects of gravity.
  ///
  /// **[gyroscope]:**
  /// Discrete reading from a gyroscope. Gyroscopes measure the rate or rotation of
  /// the device in 3D space.
  ///
  /// **[magnetometer]:**
  /// Magnetometers measure the ambient magnetic field surrounding the sensor,
  /// returning values in microteslas ***μT*** for each three-dimensional axis.
  ///
  /// Consider that these samples may bear effects of Earth's magnetic field as
  /// well as local factors such as the metal of the device itself or nearby
  /// magnets, though most devices compensate for these factors.
  ///
  /// A compass is an example of a general utility for magnetometer data.
  final ParallaxSensor sensor;

  /// Individual layers for the parallax effect.
  ///
  /// The declaration of the layers sequentially are positioned from bottom to top.
  /// For example, in
  /// ```dart
  /// layers: [layer1, layer2, layer3]
  /// ```
  /// where layer1, layer2, layer3 are instances of the class **[Layer]**,
  /// layer1 will be at the bottom
  /// (farthest to viewer from parallax perspective)
  /// followed by layer2 and layer3 will be the topmost
  /// (nearest to viewer from parallax perspective)
  final List<Layer> layers;

  /// Reverses the movement of vertical axis
  final bool reverseVerticalAxis;

  /// Reverses the movement of horizontal axis
  final bool reverseHorizontalAxis;

  /// Stops the movement of vertical axis
  final bool lockVerticalAxis;

  /// Stops the movement of horizontal axis
  final bool lockHorizontalAxis;

  /// The duration it takes for the movement change to complete.
  /// Decreasing it will make the parallax effect seem discrete and rough.
  /// On the other hand, increasing it too much will make the responsiveness
  /// of the sensor too slow. Ideal value is from 200 to 400.
  final int animationDuration;

  /// The fixed body above the parallax layer
  final Widget? child;

  @override
  State<Parallax> createState() => _ParallaxState();
}

class _ParallaxState extends State<Parallax> {
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
                    ? event.y
                    : -event.y;
            _left = widget.lockHorizontalAxis
                ? 0
                : widget.reverseHorizontalAxis
                    ? -event.y
                    : event.y;
          });
        });
        break;

      case ParallaxSensor.magnetometer:
        _magnetometerSensorEvent =
            magnetometerEvents.listen((MagnetometerEvent event) {
          setState(() {
            _maxSensitivity = 50;
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
              .map((layer) => layer._build(context, widget.animationDuration,
                  _maxSensitivity, _top, _bottom, _right, _left))
              .toList(),
        ),
        widget.child ?? Container(),
      ],
    );
  }
}
