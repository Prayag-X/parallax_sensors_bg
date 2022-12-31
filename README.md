# Parallax Sensors Bg

Get a parallax effect in the background of a page that responds to a corresponding sensor 
detection (Accelerometer, Gyroscope, User accelerometer, Magnetometer)
<br> <br> *Note: Accelerometer is preferred over other sensors.*

<table>
  <tr>
    <td><img src="https://github.com/Prayag-X/parallax_sensors_bg/blob/main/assets/example1.gif" height="600"></td>
    <td><img src="https://github.com/Prayag-X/parallax_sensors_bg/blob/main/assets/example2.gif" height="600"></td>
  </tr>
</table>

<br>

## Features

<ul>
  <li> Supports 4 sensors: Accelerometer, User Accelerometer, Gyroscope, Magnetometer.
  </li>
  <li> Simplified use of image.
  </li> 
  <li> Predefined filters for image: Blur and darken.
  </li>
  <li> Any widgets can be used as a layer.
  </li>
  <li> Can lock or reverse the movement of any axis.
  </li>
  <li> Many parameters for precise customization.
  </li>
</ul>

<br>

## Getting started

Add dependency in ```pubspec.yaml``` and run ```flutter pub get```
```dart
dependencies:
  parallax_sensors_bg: ^1.0.0
```

Now import the package in your code:
```dart
import 'package:parallax_sensors_bg/parallax_sensors_bg.dart';
```

<br>

## Usage

Use it in the ```Scaffold``` ```body```

```dart
Parallax(
  sensors: ParallaxSensor.accelerometer,
  layers: [
    Layer(
      sensitivity: 1,
      image: NetworkImage('https://example.com/background.png'),
      preventCrop: true,
      imageBlurValue: 5,
    ),
    Layer(
      sensitivity: 7,
      image: AssetImage('assets/middle_layer.png'),
      imageHeight: 500,
      imageFit: BoxFit.fitHeight,
    ),
    Layer(
      sensitivity: 12,
      child: Text('Topmost layer'),
    ),
  ]
  child: Text('Page body here'),
),
```

<br>

## **Parallax** class arguments:

Argument | Type | Default | Description
--- | --- | --- | ---
sensor | `ParallaxSensor` | `ParallaxSensor.accelerometer` | Type of the sensor whose detected values will be used for parallax movement. (`accelerometer`, `userAccelerometer`, `gyroscope`, `magnetometer`).
layers | `List<Layer>` | `required` | Individual layers for the parallax effect. The declaration of the layers sequentially are positioned from bottom to top (Farthest to nearest from parallax perspective).
reverseVerticalAxis | `bool` | `false` | Reverses the movement of vertical axis.
reverseHorizontalAxis | `bool` | `false` | Reverses the movement of horizontal axis.
lockVerticalAxis | `bool` | `false` | Stops the movement of vertical axis.
lockHorizontalAxis | `bool` | `false` | Stops the movement of horizontal axis.
animationDuration | `int` | `300` | The duration in milliseconds it takes for the movement change to complete. Ideal value is from `200` to `400`.
child | `Widget?` | `null` | The fixed body of the page, above the parallax layer.

<br>

## **Layer** class arguments:

Argument | Type | Default | Description
--- | --- | --- | ---
sensitivity | `double` | `required` | Moving sensitivity of the layer.
offset | `Offset?` | `null` | Position of the layer from the center.
image | `ImageProvider<Object>?` | `null` | Image that the layer will show. By default, the image will take the size of the screen.
imageFit | `BoxFit` | `BoxFit.cover` | BoxFit type of the image.
imageHeight | `double?` | `null` | Height of the `image`.
imageWidth | `double?` | `null` | Width of the `image`.
preventCrop | `bool` | `false` | If set to true, it will ignore the `imageHeight` and `imageWidth` if given and will set the height and width of the `image` slightly more than the screen size such that it doesn't get cropped even at the extreme value of the `sensor`.
imageBlurValue | `double?` | `null` | Blurs the `image`. Value can be any positive fractional number.
imageDarkenValue | `double?` | `null` | Darkens the `image`. Value ranges from `0` to `1`.
opacity | `double?` | `null` | Opacity of the layer. Value ranges from `0` to `1`.
